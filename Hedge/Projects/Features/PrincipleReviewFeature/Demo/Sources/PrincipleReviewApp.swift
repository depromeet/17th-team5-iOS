import SwiftUI
import PrincipleReviewFeature
import PrincipleReviewFeatureInterface
import LinkDomainInterface
import LinkDomain
import RetrospectionDomainInterface
import FeedbackDomainInterface
import Shared

@main
struct PrincipleReviewApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            
            let linkUseCase = MockFetchLink()
            let uploadUseCase = MockUploadRetrospectionImageUseCase()
            let createUseCase = MockCreateRetrospectionUseCase()
            let feedbackUseCase = MockFetchFeedbackUseCase()
            
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
                    createRetrospectionUseCase: createUseCase,
                    fetchFeedbackUseCase: feedbackUseCase
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

struct MockFetchFeedbackUseCase: FetchFeedbackUseCase {
    func execute(id: Int) async throws -> FeedbackData {
        FeedbackData(
            symbol: "005930",
            price: 10000,
            volume: 5,
            orderType: "BUY",
            keptCount: 2,
            neutralCount: 1,
            notKeptCount: 1,
            badge: "감각의 전성기",
            keep: ["시장 흐름을 정확히 읽었어요."],
            fix: ["기록을 조금 더 구체화해보세요."],
            next: ["다음에도 침착하게 대응하세요."]
        )
    }
}
