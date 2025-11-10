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
            let createUseCase = MockCreateRetrospectionUseCase()
            
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
                    uploadImageUseCase: uploadUseCase,
                    createRetrospectionUseCase: createUseCase
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

struct MockCreateRetrospectionUseCase: CreateRetrospectionUseCase {
    func execute(_ request: RetrospectionCreateRequest) async throws -> RetrospectionCreateResult {
        RetrospectionCreateResult(
            id: 1,
            userId: 1,
            symbol: request.symbol,
            market: request.market,
            orderType: request.orderType,
            price: request.price,
            currency: request.currency,
            volume: request.volume,
            orderDate: request.orderDate,
            returnRate: request.returnRate,
            createdAt: ISO8601DateFormatter().string(from: .now),
            updatedAt: ISO8601DateFormatter().string(from: .now)
        )
    }
}
