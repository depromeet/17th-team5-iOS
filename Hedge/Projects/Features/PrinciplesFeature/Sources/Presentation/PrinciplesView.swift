import SwiftUI
import ComposableArchitecture
import DesignKit
import PrinciplesFeatureInterface
import StockDomainInterface

@ViewAction(for: PrinciplesFeature.self)
public struct PrinciplesView: View {
    @Bindable public var store: StoreOf<PrinciplesFeature>
    
    public init(store: StoreOf<PrinciplesFeature>) {
        self.store = store
    }
    
    public var body: some View {
        PrinciplesChecklistView(store: store)
            .onAppear {
                send(.onAppear)
            }
    }
}

// MARK: - Principles Checklist View
@ViewAction(for: PrinciplesFeature.self)
struct PrinciplesChecklistView: View {
    @Bindable var store: StoreOf<PrinciplesFeature>
    
    private let principles = [
        "주가가 오르는 흐름이면 매수, 하락 흐름이면 매도하기",
        "기업의 본질 가치보다 낮게 거래되는 주식을 찾아 장기 보유하기",
        "단기 등락에 흔들리지 말고 기업의 장기 성장성에 집중하기",
        "분산 투자 원칙을 지키고 감정적 결정을 피하기",
        "리스크를 관리하며 손절 기준을 미리 정해두기"
    ]
    
    private var dynamicTitle: String {
        let count = store.selectedPrinciples.count
        let tradeTypeText = store.tradeType.rawValue
        return "\(tradeTypeText) 원칙 \(count)개 선택됨"
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HedgeNavigationBar(
                buttonText: "건너뛰기",
                onLeftButtonTap: {
                    send(.skipTapped)
                }
            )
            
            VStack(spacing: 20) {
                Text(dynamicTitle)
                    .font(.h1Semibold)
                    .foregroundStyle(Color.hedgeUI.textTitle)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                VStack(spacing: 12) {
                    ForEach(principles.indices, id: \.self) { index in
                        Button(action: {
                            send(.principleToggled(index))
                        }) {
                            HStack {
                                Text(principles[index])
                                    .font(.body3Medium)
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.leading)
                                
                                Spacer()
                                
                                if store.selectedPrinciples.contains(index) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(Color.hedgeUI.brandPrimary)
                                } else {
                                    Image(systemName: "circle")
                                        .foregroundColor(Color.hedgeUI.textSecondary)
                                }
                            }
                            .padding()
                            .background(Color.hedgeUI.neutralBgSecondary)
                            .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                HedgeActionButton("다음") {
                    send(.completeTapped)
                }
                .size(.medium)
                .padding(.horizontal, 20)
                .padding(.bottom, 34)
            }
        }
        .background(Color.hedgeUI.backgroundWhite.ignoresSafeArea())
    }
}

#Preview {
    PrinciplesView(store: .init(
        initialState: PrinciplesFeature.State(
            tradeType: .sell,
            stock: StockSearch(symbol: "005930", title: "삼성전자", market: "KOSPI"),
            tradingPrice: "70,000",
            tradingQuantity: "10",
            tradingDate: "2025년 9월 26일",
            yield: "+10%",
            reasonText: "기업 실적이 좋아 보여서"
        ),
        reducer: {
            PrinciplesFeature(coordinator: DefaultPrinciplesCoordinator(
                navigationController: UINavigationController(),
                tradeType: .sell,
                stock: StockSearch(symbol: "005930", title: "삼성전자", market: "KOSPI"),
                tradingPrice: "70,000",
                tradingQuantity: "10",
                tradingDate: "2025년 9월 26일",
                yield: "+10%",
                reasonText: "기업 실적이 좋아 보여서"
            ))
        }
    ))
}