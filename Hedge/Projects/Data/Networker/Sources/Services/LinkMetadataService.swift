import Foundation

public protocol LinkMetadataServiceProtocol {
    func fetchLinkMetadata(from urlString: String) async throws -> (title: String, imageURL: String?, newSource: String)
}

public struct LinkMetadataService: LinkMetadataServiceProtocol {
    private let provider: ProviderProtocol
    
    public init(provider: ProviderProtocol) {
        self.provider = provider
    }
    
    public func fetchLinkMetadata(from urlString: String) async throws -> (title: String, imageURL: String?, newSource: String) {
        guard let url = URL(string: urlString) else {
            throw LinkMetadataError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15", forHTTPHeaderField: "User-Agent")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            // 여러 인코딩 시도
            var html: String?
            
            // 1. UTF-8 시도 (네이버, 다음, 대부분의 최신 사이트)
            html = String(data: data, encoding: .utf8)
            
            // 2. UTF-8이 실패하면 EUC-KR 시도 (네이트 등 한국 사이트)
            if html == nil {
                let eucKR = CFStringConvertEncodingToNSStringEncoding(0x0940)
                html = String(data: data, encoding: String.Encoding(rawValue: eucKR))
            }
            
            // 3. 그래도 실패하면 ISO-8859-1 시도
            if html == nil {
                html = String(data: data, encoding: .isoLatin1)
            }
            
            guard let htmlContent = html else {
                throw LinkMetadataError.encodingFailed
            }
            
            let newsSource = getNewsSource(from: url)
            let (title, imageURL) = parseHTML(html: htmlContent, baseURL: url)
            
            return (title, imageURL, newsSource)
        } catch {
            throw LinkMetadataError.networkError(error)
        }
    }
    
    // MARK: - Private Methods
    
    private func getNewsSource(from url: URL) -> String {
        guard let host = url.host else { return "" }
        
        if host.contains("naver") {
            return "네이버 뉴스"
        } else if host.contains("daum") {
            return "다음 뉴스"
        } else if host.contains("nate") {
            return "네이트 뉴스"
        } else if host.contains("chosun") {
            return "조선일보"
        } else if host.contains("joongang") {
            return "중앙일보"
        } else if host.contains("donga") {
            return "동아일보"
        } else if host.contains("hani") {
            return "한겨레"
        } else if host.contains("khan") {
            return "경향신문"
        } else if host.contains("mk") {
            return "매일경제"
        } else if host.contains("hankyung") {
            return "한국경제"
        } else if host.contains("yna") || host.contains("yonhap") {
            return "연합뉴스"
        } else if host.contains("sbs") {
            return "SBS 뉴스"
        } else if host.contains("kbs") {
            return "KBS 뉴스"
        } else if host.contains("mbc") {
            return "MBC 뉴스"
        } else if host.contains("jtbc") {
            return "JTBC 뉴스"
        } else {
            return host
        }
    }
    
    private func parseHTML(html: String, baseURL: URL) -> (title: String, imageURL: String?) {
        var title = ""
        var imageURL: String?
        
        // 제목 추출 (title 태그)
        if let titleRange = html.range(of: "<title[^>]*>(.*?)</title>", options: .regularExpression) {
            let titleTag = String(html[titleRange])
            if let contentRange = titleTag.range(of: "(?<=<title[^>]*>).*?(?=</title>)", options: .regularExpression) {
                title = String(titleTag[contentRange])
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .replacingOccurrences(of: "&quot;", with: "\"")
                    .replacingOccurrences(of: "&amp;", with: "&")
                    .replacingOccurrences(of: "&lt;", with: "<")
                    .replacingOccurrences(of: "&gt;", with: ">")
            }
        }
        
        // Open Graph 제목 확인 (더 정확한 제목일 수 있음)
        if let ogTitleRange = html.range(of: "<meta[^>]*property=['\"]og:title['\"][^>]*content=['\"]([^'\"]*)['\"]", options: .regularExpression) {
            let ogTitleTag = String(html[ogTitleRange])
            if let contentRange = ogTitleTag.range(of: "(?<=content=['\"])[^'\"]*", options: .regularExpression) {
                let ogTitle = String(ogTitleTag[contentRange])
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .replacingOccurrences(of: "&quot;", with: "\"")
                    .replacingOccurrences(of: "&amp;", with: "&")
                if !ogTitle.isEmpty {
                    title = ogTitle
                }
            }
        }
        
        // 이미지 추출 - Open Graph 이미지 우선
        let ogImagePattern = "<meta[^>]*property=['\"]og:image['\"][^>]*content=['\"]([^'\"]*)['\"][^>]*>"
        if let regex = try? NSRegularExpression(pattern: ogImagePattern, options: [.caseInsensitive, .dotMatchesLineSeparators]) {
            let nsString = html as NSString
            let results = regex.matches(in: html, range: NSRange(location: 0, length: nsString.length))
            
            for result in results {
                if result.numberOfRanges >= 2 {
                    let range = result.range(at: 1)
                    if range.location != NSNotFound {
                        let extractedImageURL = nsString.substring(with: range)
                        if !extractedImageURL.isEmpty {
                            imageURL = resolveURL(extractedImageURL, baseURL: baseURL)
                            break
                        }
                    }
                }
            }
        }
        
        // Open Graph 이미지가 없으면 img 태그에서 첫 번째 이미지 찾기
        if imageURL == nil {
            let imgPattern = "<img[^>]*src=['\"]([^'\"]*)['\"][^>]*>"
            if let regex = try? NSRegularExpression(pattern: imgPattern, options: [.caseInsensitive, .dotMatchesLineSeparators]) {
                let nsString = html as NSString
                let results = regex.matches(in: html, range: NSRange(location: 0, length: nsString.length))
                
                for result in results {
                    if result.numberOfRanges >= 2 {
                        let range = result.range(at: 1)
                        if range.location != NSNotFound {
                            let extractedImageURL = nsString.substring(with: range)
                            if !extractedImageURL.isEmpty && !extractedImageURL.contains("data:image") {
                                imageURL = resolveURL(extractedImageURL, baseURL: baseURL)
                                break
                            }
                        }
                    }
                }
            }
        }
        
        return (title: title, imageURL: imageURL)
    }
    
    private func resolveURL(_ urlString: String, baseURL: URL) -> String {
        if urlString.hasPrefix("http://") || urlString.hasPrefix("https://") {
            return urlString
        } else if urlString.hasPrefix("//") {
            return "https:" + urlString
        } else if urlString.hasPrefix("/") {
            if let scheme = baseURL.scheme, let host = baseURL.host {
                return "\(scheme)://\(host)\(urlString)"
            }
        }
        return urlString
    }
}

// MARK: - Errors

public enum LinkMetadataError: Error, Equatable {
    case invalidURL
    case encodingFailed
    case networkError(Error)
    
    public static func == (lhs: LinkMetadataError, rhs: LinkMetadataError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL),
             (.encodingFailed, .encodingFailed):
            return true
        case (.networkError(let lhsError), .networkError(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}
