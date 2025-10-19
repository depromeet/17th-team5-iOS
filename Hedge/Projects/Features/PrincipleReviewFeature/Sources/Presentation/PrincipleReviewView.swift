import SwiftUI

import ComposableArchitecture

import PrincipleReviewFeatureInterface
import DesignKit
import Core

@ViewAction(for: PrincipleReviewFeature.self)
public struct PrincipleReviewView: View {
    @Bindable public var store: StoreOf<PrincipleReviewFeature>
    @State private var isPresented: Bool = false
    @State private var textEditorHeight: CGFloat = 22
    
    @FocusState private var isFocused: Bool
    
    public init(store: StoreOf<PrincipleReviewFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            if isFocused {
                VStack(alignment: .leading, spacing: 4) {
                    Text(store.state.selectedPrinciple.principle)
                        .foregroundStyle(Color.hedgeUI.textTitle)
                        .font(FontModel.body2Semibold)
                    
                    if let evaluation = store.selectedEvaluation {
                        HStack(alignment: .center, spacing: 4) {
                            evaluation.selectedImage
                                .resizable()
                                .frame(width: 18, height: 18)
                            
                            Text(evaluation.title)
                                .foregroundStyle(Color.hedgeUI.brandDarken)
                                .font(FontModel.body3Semibold)
                        }
                    } else {
                        HStack(alignment: .center, spacing: 3) {
                            Image.hedgeUI.keepDisabled
                                .resizable()
                                .frame(width: 18, height: 18)
                            
                            Image.hedgeUI.normalDisabled
                                .resizable()
                                .frame(width: 18, height: 18)
                            
                            Image.hedgeUI.notKeepDisabled
                                .resizable()
                                .frame(width: 18, height: 18)
                            
                            Spacer()
                                .frame(width: 1)
                                .foregroundStyle(.clear)
                        
                            Text("선택 전")
                                .foregroundStyle(Color.hedgeUI.textAssistive)
                                .font(FontModel.body3Medium)
                        }
                    }
                    
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
                
                HedgeSpacer(height: 1)
                    .color(Color.hedgeUI.neutralBgSecondary)
                    .padding(.horizontal, 20)
                
            } else {
                navigationBar
                
                stockSummaryView
                
                HedgeSpacer(height: 1)
                    .color(Color.hedgeUI.neutralBgSecondary)
                    .padding(.horizontal, 20)
                
                HedgeSpacer(height: 16)
                    .padding(.horizontal, 20)
                
                // 원칙 요약
                principleSummaryView
                
                // 원칙 상세
                principleDetailView
                
                HedgeSpacer(height: 24)
                
                principleEvaluationView
                
                HedgeSpacer(height: 8)
                
                Spacer()
            }
            
            textInputView
            
            resourceButtonView
        }
        .onAppear {
            send(.onAppear)
        }
        .onTapGesture {
            isFocused = false
        }
    }
    
    private var navigationBar: some View {
        HedgeNavigationBar(buttonText: "", onLeftButtonTap: {
            send(.backButtonTapped)
        })
    }
    
    private var stockSummaryView: some View {
        HStack(spacing: 0) {
            Rectangle()
                .frame(width: 20, height: 0)
                .foregroundStyle(.clear)
            
            Image.hedgeUI.stockThumbnailDemo
                .resizable()
                .frame(width: 22, height: 22)
            
            Rectangle()
                .frame(width: 8, height: 0)
                .foregroundStyle(.clear)
            
            Text(store.state.stock.title)
                .foregroundStyle(Color.hedgeUI.textAlternative)
                .font(FontModel.label2Medium)
            
            Rectangle()
                .frame(width: 2, height: 0)
                .foregroundStyle(.clear)
            
            Text("\(store.state.tradeHistory.tradingPrice)\(store.state.tradeHistory.concurrency)・\(store.state.tradeHistory.tradingQuantity)주 \(store.state.tradeType.rawValue)")
                .foregroundStyle(
                    store.state.tradeType == .buy ?
                    Color.hedgeUI.tradeBuy : Color.hedgeUI.tradeSell
                )
                .font(FontModel.label2Semibold)
            
            Spacer()
        }
        .padding(.top, 12)
        .padding(.bottom, 16)
    }
    
    private var principleSummaryView: some View {
        VStack(alignment: .leading,
               spacing: 4) {
            
            Text("지키셨나요?")
                .foregroundStyle(Color.hedgeUI.grey900)
                .font(FontModel.body3Medium)
            
            HStack(spacing: 0) {
                Text(store.state.selectedPrinciple.principle)
                    .foregroundStyle(Color.hedgeUI.grey900)
                    .font(isFocused ? FontModel.body2Semibold : FontModel.h1Semibold)
                
                Spacer()
                
                Rectangle()
                    .frame(width: 12, height: 0)
                    .foregroundStyle(.black)
                
                Image.hedgeUI.arrowDown
                    .renderingMode(.template)
                    .foregroundStyle(Color.hedgeUI.textAssistive)
                    .onTapGesture {
                        send(.pricipleToggleButtonTapped,
                             animation: .easeInOut(duration: 0.3))
                        isPresented = true
                    }
            }
        }
               .padding(.vertical, 10)
               .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    private var principleDetailView: some View {
        if store.state.principleDetailShown {
            Text(store.state.selectedPrinciple.principle)
                .font(FontModel.body3Medium)
                .foregroundStyle(Color.hedgeUI.textAlternative)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
        }
    }
    
    private var principleEvaluationView: some View {
        HStack(spacing: 8) {
            
            Button {
                send(.keepButtonTapped, animation: .easeInOut(duration: 0.3))
            } label: {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(lineWidth: store.state.selectedEvaluation == .keep ? 1.5 : 1)
                    .foregroundStyle(store.state.selectedEvaluation == .keep ? Color.hedgeUI.brandPrimary : Color.hedgeUI.neutralBgSecondary)
                    .frame(height: 103)
                    .overlay {
                        VStack(alignment: .center, spacing: 4) {
                            (store.state.selectedEvaluation == .keep ? Image.hedgeUI.keep : Image.hedgeUI.keepDisabled)
                                .resizable()
                                .frame(width: 40, height: 40)
                            
                            Text("지켰어요")
                                .foregroundStyle(store.state.selectedEvaluation == .keep ? Color.hedgeUI.brandDarken : Color.hedgeUI.textAlternative)
                                .font(store.state.selectedEvaluation == .keep ? FontModel.label1Semibold : FontModel.label1Medium)
                        }
                    }
            }
            .buttonStyle(PlainButtonStyle())
            
            Button {
                send(.normalButtonTapped, animation: .easeInOut(duration: 0.3))
            } label: {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(lineWidth: store.state.selectedEvaluation == .normal ? 1.5 : 1)
                    .foregroundStyle(store.state.selectedEvaluation == .normal ? Color.hedgeUI.brandPrimary : Color.hedgeUI.neutralBgSecondary)
                    .frame(height: 103)
                    .overlay {
                        VStack(alignment: .center, spacing: 4) {
                            (store.state.selectedEvaluation == .normal ? Image.hedgeUI.normal : Image.hedgeUI.normalDisabled)
                                .resizable()
                                .frame(width: 40, height: 40)
                            
                            Text("보통이에요")
                                .foregroundStyle(store.state.selectedEvaluation == .normal ? Color.hedgeUI.brandDarken : Color.hedgeUI.textAlternative)
                                .font(store.state.selectedEvaluation == .normal ? FontModel.label1Semibold : FontModel.label1Medium)
                        }
                    }
            }
            .buttonStyle(PlainButtonStyle())
            
            Button {
                send(.notKeepButtonTapped, animation: .easeInOut(duration: 0.3))
            } label: {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(lineWidth: store.state.selectedEvaluation == .notKeep ? 1.5 : 1)
                    .foregroundStyle(store.state.selectedEvaluation == .notKeep ? Color.hedgeUI.brandPrimary : Color.hedgeUI.neutralBgSecondary)
                    .frame(height: 103)
                    .overlay {
                        VStack(alignment: .center, spacing: 4) {
                            (store.state.selectedEvaluation == .notKeep ? Image.hedgeUI.notKeep : Image.hedgeUI.notKeepDisabled)
                                .resizable()
                                .frame(width: 40, height: 40)
                            
                            Text("안지켰어요")
                                .foregroundStyle(store.state.selectedEvaluation == .notKeep ? Color.hedgeUI.brandDarken : Color.hedgeUI.textAlternative)
                                .font(store.state.selectedEvaluation == .notKeep ? FontModel.label1Semibold : FontModel.label1Medium)
                        }
                    }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, 20)
    }
    
    private var textInputView: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $store.state.text)
                .focused($isFocused)
                .tint(.black)
                .font(FontModel.body3Medium)
                .foregroundStyle(Color.hedgeUI.textTitle)
                .scrollContentBackground(.hidden)
                .frame(height: textEditorHeight, alignment: .topLeading)
            
            if store.state.text.isEmpty && !isFocused {
                Text("이유 남기기")
                    .font(FontModel.body3Medium)
                    .foregroundStyle(Color.hedgeUI.textAssistive)
                    .padding(.horizontal, 8)
            }
            
            GeometryReader { geo in
                Text((store.state.text.isEmpty ? " " : store.state.text) + " ")
                    .font(FontModel.body3Medium)
                    .padding(.horizontal, 8)
                    .frame(width: geo.size.width, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .opacity(0)
                    .background(
                        GeometryReader { inner in
                            Color.clear.preference(key: TextEditorHeightKey.self, value: inner.size.height)
                        }
                    )
            }
        }
        .onPreferenceChange(TextEditorHeightKey.self) { height in
            textEditorHeight = height
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
        .padding(.bottom, 8)
        .id("textEditorArea")
    }
    
    private var resourceButtonView: some View {
        HStack(spacing: 7) {
            Image.hedgeUI.image
                .renderingMode(.template)
                .foregroundStyle(Color.hedgeUI.textAssistive)
                .padding(4)
            
            Image.hedgeUI.link
                .renderingMode(.template)
                .foregroundStyle(Color.hedgeUI.textAssistive)
                .padding(4)
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

private struct TextEditorHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    PrincipleReviewView(store: .init(initialState: PrincipleReviewFeature.State(
        tradeType: .sell,
        stock: .init(symbol: "symbol", title: "삼성전자", market: "market"),
        tradeHistory: .init(tradingPrice: "97,700",
                            tradingQuantity: "10",
                            tradingDate: "123123",
                            concurrency: "원"),
        principles: [.init(id: 0, principle: "원칙 1입니다."),
                     .init(id: 1, principle: "원칙 2입니다.")]),
                                     reducer: { PrincipleReviewFeature() } ))
}
