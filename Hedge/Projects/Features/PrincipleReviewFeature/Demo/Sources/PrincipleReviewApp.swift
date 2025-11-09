import SwiftUI
import PrincipleReviewFeature
import PrincipleReviewFeatureInterface
import LinkDomainInterface
import LinkDomain
import RetrospectionDomainInterface
import Shared

@main
struct PrincipleReviewApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            
            let linkUseCase = MockFetchLink()
            let uploadUseCase = MockUploadRetrospectionImageUseCase()
            
            PrincipleReviewView(store: .init(initialState: PrincipleReviewFeature.State(
                tradeType: .sell,
                stock: .init(symbol: "symbol", title: "삼성전자", market: "market"),
                tradeHistory: .init(tradingPrice: "97,700",
                                    tradingQuantity: "10",
                                    tradingDate: "123123",
                                    concurrency: "원"),
                principles: [.init(id: 0, principle: "원칙 1입니다."),
                             .init(id: 1, principle: "원칙 2입니다.")]),
                                             reducer: {
                PrincipleReviewFeature(
                    fetchLinkUseCase: linkUseCase,
                    uploadImageUseCase: uploadUseCase
                )
            } ))
        }
    }
}

struct MockUploadRetrospectionImageUseCase: UploadRetrospectionImageUseCase {
    func execute(domain: String, fileData: Data, fileName: String, mimeType: String) async throws -> UploadedImage {
        UploadedImage(imageId: 0, objectKey: "mock", fileName: fileName, fileSize: fileData.count)
    }
}
