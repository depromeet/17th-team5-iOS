import SwiftUI
import PhotosUI

import ComposableArchitecture

import PrincipleReviewFeatureInterface
import DesignKit
import Core

@ViewAction(for: PrincipleReviewFeature.self)
public struct PrincipleReviewView: View {
    @Bindable public var store: StoreOf<PrincipleReviewFeature>
    
    @State private var isPresented: Bool = false
    @State private var focusWithAnimation: Bool = false
    @State private var focusWithoutAnimation: Bool = false
    @FocusState private var isFocused: Bool
    
    public init(store: StoreOf<PrincipleReviewFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            HedgeSpacer(height: 16)
            
            ZStack(alignment: .topLeading) {
                if focusWithAnimation {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(store.selectedPrinciple.principle)
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
                        
                        HedgeSpacer(height: 12)
                            .color(.clear)
                        
                        HedgeSpacer(height: 1)
                            .color(Color.hedgeUI.neutralBgSecondary)
                    }
                    .padding(.top, 12)
                    .padding(.horizontal, 20)
                } else {
                    VStack(alignment: .leading, spacing: 0) {
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
                    }
                    .opacity(focusWithoutAnimation ? 0 : 1)
                }
            }
            
            textInputView
            
            Spacer()
            
            if focusWithAnimation {
                keyboardResourceButtonView
            }
        }
        .onAppear {
            send(.onAppear)
        }
        .onTapGesture {
            isFocused = false
        }
        .onChange(of: isFocused) { _, newValue in
            focusWithoutAnimation = newValue
            
            withAnimation(.easeInOut(duration: 0.3)) {
                focusWithAnimation = newValue
            }
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
            
            Text(store.stock.title)
                .foregroundStyle(Color.hedgeUI.textAlternative)
                .font(FontModel.label2Medium)
            
            Rectangle()
                .frame(width: 2, height: 0)
                .foregroundStyle(.clear)
            
            Text("\(store.tradeHistory.tradingPrice)\(store.tradeHistory.concurrency)・" +
                 "\(store.tradeHistory.tradingQuantity)주 \(store.tradeType.rawValue)")
                .foregroundStyle(
                    store.tradeType == .buy ?
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
                Text(store.selectedPrinciple.principle)
                    .foregroundStyle(Color.hedgeUI.grey900)
                    .font(FontModel.h1Semibold)
                
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
        if store.principleDetailShown {
            Text(store.selectedPrinciple.principle)
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
                
                let style = store.state.evalutionStyle(store.selectedEvaluation, .keep)
                
                RoundedRectangle(cornerRadius: 16)
                    .stroke(lineWidth: style.lineWidth)
                    .foregroundStyle(style.foregroundColor)
                    .frame(height: 103)
                    .overlay {
                        VStack(alignment: .center, spacing: 4) {
                            style.image
                                .resizable()
                                .frame(width: 40, height: 40)
                            
                            Text(style.title)
                                .foregroundStyle(style.textColor)
                                .font(style.font)
                        }
                    }
            }
            .buttonStyle(PlainButtonStyle())
            
            Button {
                send(.normalButtonTapped, animation: .easeInOut(duration: 0.3))
            } label: {
                let style = store.state.evalutionStyle(store.selectedEvaluation, .normal)
                
                RoundedRectangle(cornerRadius: 16)
                    .stroke(lineWidth: style.lineWidth)
                    .foregroundStyle(style.foregroundColor)
                    .frame(height: 103)
                    .overlay {
                        VStack(alignment: .center, spacing: 4) {
                            style.image
                                .resizable()
                                .frame(width: 40, height: 40)
                            
                            Text(style.title)
                                .foregroundStyle(style.textColor)
                                .font(style.font)
                        }
                    }
            }
            .buttonStyle(PlainButtonStyle())
            
            Button {
                send(.notKeepButtonTapped, animation: .easeInOut(duration: 0.3))
            } label: {
                let style = store.state.evalutionStyle(store.selectedEvaluation, .notKeep)
                
                RoundedRectangle(cornerRadius: 16)
                    .stroke(lineWidth: style.lineWidth)
                    .foregroundStyle(style.foregroundColor)
                    .frame(height: 103)
                    .overlay {
                        VStack(alignment: .center, spacing: 4) {
                            style.image
                                .resizable()
                                .frame(width: 40, height: 40)
                            
                            Text(style.title)
                                .foregroundStyle(style.textColor)
                                .font(style.font)
                        }
                    }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, 20)
    }
    
    private var textInputView: some View {
        
        ScrollView {
            ZStack(alignment: .topLeading) {
                if store.text.isEmpty {
                    Text("이유 남기기")
                        .font(FontModel.body3Medium)
                        .foregroundStyle(Color.hedgeUI.textAssistive)
                        .padding(.horizontal, 4)
                        .padding(.top, 8)
                }
                
                TextEditor(text: $store.text)
                    .focused($isFocused)
                    .tint(.black)
                    .font(FontModel.body3Medium)
                    .foregroundStyle(Color.hedgeUI.textTitle)
                    .scrollContentBackground(.hidden)
            }
            
            if !focusWithAnimation {
                resourceButtonView
            }
            
             ScrollView(.horizontal) {
                 HStack(alignment: .top, spacing: 12) {
                     ForEach(store.photoItems) { photoItem in
                         ZStack(alignment: .topTrailing) {
                             if let image = photoItem.loadedImage {
                                 image
                                     .resizable()
                                     .aspectRatio(contentMode: .fit)
                                     .frame(width: 120)
                                     .clipped()
                                     .cornerRadius(18)
                             } else {
                                 // 로딩 중이거나 실패한 경우
                                 Rectangle()
                                     .fill(Color.hedgeUI.neutralBgSecondary)
                                     .frame(width: 120, height: 120)
                                     .cornerRadius(18)
                                     .overlay {
                                         ProgressView()
                                     }
                             }
                             
                             Button {
                                 send(.deletePhoto(photoItem.id))
                             } label: {
                                 Image.hedgeUI.closeFillWhite
                             }
                             .padding(.top, 4)
                             .padding(.trailing, 4)
                         }
                     }
                 }
             }
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
        .padding(.bottom, 8)
        .scrollIndicators(.hidden)
    }
    
    private var resourceButtonView: some View {
        HStack(spacing: 7) {
            
            photoPickerView
            
            Button {
                
            } label: {
                Image.hedgeUI.link
                    .renderingMode(.template)
                    .foregroundStyle(Color.hedgeUI.textAssistive)
                    .padding(4)
            }
            
            Spacer()
        }
    }
    
    private var keyboardResourceButtonView: some View {
        
        VStack(spacing: 0) {
            HedgeSpacer(height: 1)
                .color(Color.hedgeUI.neutralBgSecondary)
            
            HedgeSpacer(height: 7)
            
            HStack(alignment: .center, spacing: 4) {
                
                photoPickerView
                
                Button {
                    
                } label: {
                    Image.hedgeUI.link
                        .renderingMode(.template)
                        .foregroundStyle(Color.hedgeUI.textAssistive)
                        .padding(5)
                }
                
                Spacer()
                
                Button {
                    isFocused = false
                } label: {
                    Text("남기기")
                        .font(FontModel.body1Semibold)
                        .foregroundStyle(Color.hedgeUI.brandDarken)
                }
            }
            .padding(.bottom, 8)
            .padding(.horizontal, 12)
        }
    }
    
    private var photoPickerView: some View {
        PhotosPicker(
            selection: $store.selectedPhotoItems,
            matching: .images
        ) {
            Image.hedgeUI.image
                .renderingMode(.template)
                .foregroundStyle(Color.hedgeUI.textAssistive)
                .padding(.horizontal, 4)
        }
        .onChange(of: store.selectedPhotoItems) { _, _ in
            send(.loadPhotos)
        }
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
