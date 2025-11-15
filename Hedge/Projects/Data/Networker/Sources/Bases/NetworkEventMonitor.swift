import Foundation
import Alamofire

final class NetworkEventMonitor: EventMonitor {
    let queue = DispatchQueue(label: "network.event.monitor")
    
    func requestDidResume(_ request: Request) {
        print("➡️ [EventMonitor] Request Did Resume: \(request.description)")
    }
    
    func request(_ request: DataRequest, didParseResponse response: DataResponse<Data?, AFError>) {
        let url = request.request?.url?.absoluteString ?? "unknown url"
        let method = request.request?.httpMethod ?? "unknown"
        let statusCode = response.response?.statusCode ?? -1
        
        print("🌐 [EventMonitor] Parsed Response: \(method) \(url) | status: \(statusCode)")
        
        // 400번대 이상 에러인 경우 응답 body 파싱
        if statusCode >= 400 {
            if let data = response.data,
               let body = String(data: data, encoding: .utf8),
               !body.isEmpty {
                print("❌ [EventMonitor] Error Response Body: \(body)")
            }
            
            // 에러 메시지 파싱 시도
            if let data = response.data {
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let message = json["message"] as? String {
                    print("❌ [EventMonitor] Error Message: \(message)")
                }
            }
        }
        
        if let error = response.error {
            print("❌ [EventMonitor] Error: \(error)")
        }
    }
    
    func requestDidFinish(_ request: Request) {
        if let dataRequest = request as? DataRequest,
           let url = dataRequest.request?.url?.absoluteString,
           let method = dataRequest.request?.httpMethod {
            // response를 가져올 수 없으므로 didParseResponse에서 처리
            print("🏁 [EventMonitor] Request Did Finish: \(method) \(url)")
        } else {
            print("🏁 [EventMonitor] Request Did Finish: \(request.description)")
        }
    }
    
    func request(_ request: DataRequest, didFailTask task: URLSessionTask, earlyWithError error: Error) {
        print("⚠️ [EventMonitor] Request Failed Early: \(request.description) | error: \(error)")
    }
}

