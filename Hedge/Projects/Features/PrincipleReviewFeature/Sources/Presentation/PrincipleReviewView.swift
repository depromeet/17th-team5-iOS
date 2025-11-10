import SwiftUI
import PhotosUI

import ComposableArchitecture

import PrincipleReviewFeatureInterface
import LinkDomainInterface
import DesignKit
import Kingfisher
import Core

@ViewAction(for: PrincipleReviewFeature.self)
public struct PrincipleReviewView: View {
    @Bindable public var store: StoreOf<PrincipleReviewFeature>
    
    @State private var isPresented: Bool = false
    @State private var focusWithAnimation: Bool = false
    @State private var focusWithoutAnimation: Bool = false
    @FocusState private var isFocused: Bool
    @State private var currentPageIndex: Int = 0
    @State private var modalPresented: Bool = true
    
    public init(store: StoreOf<PrincipleReviewFeature>) {
        self.store = store
    }
    
    public var body: some View {
        
        VStack(spacing: 0) {
            if isFocused == false {
                navigationBar
                stockSummaryView
                
                HedgeSpacer(height: 1)
                    .color(Color.hedgeUI.neutralBgSecondary)
                    .padding(.horizontal, 20)
                
                HedgeSpacer(height: 16)
                    
                
                Text("지키셨나요?")
                    .foregroundStyle(Color.hedgeUI.grey900)
                    .font(FontModel.body3Medium)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            TabView(selection: $currentPageIndex) {
                ForEach(0..<store.principles.count, id: \.self) { index in
                    singleReviewView(for: index)
                        .tag(index)
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onChange(of: currentPageIndex) { _, newValue in
            send(.pageChanged(newValue))
        }
        .overlay(alignment: .bottom) {
            if !focusWithAnimation {
                VStack(spacing: 0) {
                    pageFloatingView
                }
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
        .overlay {
            if store.state.linkModalShown {
                HedgeLinkModal(shown: $store.state.linkModalShown) { link in
                    send(.addLinkButtonTapped(link))
                }
            }
        }
        // .hedgeModal(isPresented: $modalPresented, title: "123", actions: .init(primaryTitle: "1", onPrimary: {
        //     print("44")
        // }))
    }
    
    // MARK: - Single Review View
    private func singleReviewView(for index: Int) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            
            ZStack(alignment: .topLeading) {
                if focusWithAnimation {
                    HedgeSpacer(height: 16)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(store.principles[index].principle)
                            .foregroundStyle(Color.hedgeUI.textTitle)
                            .font(FontModel.body2Semibold)
                        
                        if let evaluation = store.currentPageState.selectedEvaluation {
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
                        
                        
                        // 원칙 요약 (현재 페이지의 원칙)
                        principleSummaryView(for: index)
                        
                        // 원칙 상세
                        principleDetailView(for: index)
                        
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
    }
    
    private var navigationBar: some View {
        return HedgeNavigationBar(title: "원칙이름", buttonText: "완료", state: store.state.isComplete ? .active : .disabled, onLeftButtonTap: {
            send(.backButtonTapped)
        }) {
            send(.completeButtonTapped)
        }
    }
    
    private var stockSummaryView: some View {
        HStack(spacing: 0) {
            Rectangle()
                .frame(width: 20, height: 0)
                .foregroundStyle(.clear)
            
            if let logo = store.state.stock.logo {
                KFImage(URL(string: logo)!)
                    .resizable()
                    .frame(width: 22, height: 22)
            } else {
                Image.hedgeUI.stockThumbnailDemo
            }
            
            Rectangle()
                .frame(width: 8, height: 0)
                .foregroundStyle(.clear)
            
            Text(store.stock.companyName)
                .foregroundStyle(Color.hedgeUI.textAlternative)
                .font(FontModel.label2Medium)
            
            Rectangle()
                .frame(width: 2, height: 0)
                .foregroundStyle(.clear)
            
            Text("\(store.tradeHistory.tradingPrice)・" +
                 "\(store.tradeHistory.tradingQuantity) \(store.tradeType.rawValue)")
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
    
    private func principleSummaryView(for index: Int) -> some View {
        VStack(alignment: .leading,
               spacing: 4) {
            
            HStack(spacing: 0) {
                Text(store.principles[index].principle)
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
    private func principleDetailView(for index: Int) -> some View {
        if store.currentPageState.principleDetailShown {
            Text(store.principles[index].principle)
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
                
                let style = store.state.evalutionStyle(store.currentPageState.selectedEvaluation, .keep)
                
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
                let style = store.state.evalutionStyle(store.currentPageState.selectedEvaluation, .normal)
                
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
                let style = store.state.evalutionStyle(store.currentPageState.selectedEvaluation, .notKeep)
                
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
                if store.currentPageState.text.isEmpty {
                    Text("이유 남기기")
                        .font(FontModel.body3Medium)
                        .foregroundStyle(Color.hedgeUI.textAssistive)
                        .padding(.horizontal, 4)
                        .padding(.top, 8)
                }
                
                TextEditor(text: $store.currentPageState.text)
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
                    ForEach(store.currentPageState.photoItems) { photoItem in
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
            
            // 링크 메타데이터 표시
            ForEach(Array(store.currentPageState.linkMetadataList.enumerated()), id: \.offset) { index, metadata in
                linkMetadataView(metadata, index: index)
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
                send(.linkButtonTapped)
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
                    send(.linkButtonTapped)
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
            selection: $store.currentPageState.selectedPhotoItems,
            matching: .images
        ) {
            Image.hedgeUI.image
                .renderingMode(.template)
                .foregroundStyle(Color.hedgeUI.textAssistive)
                .padding(.horizontal, 4)
        }
        .onChange(of: store.currentPageState.selectedPhotoItems) { _, _ in
            send(.loadPhotos)
        }
    }
    
    private func linkMetadataView(_ metadata: LinkMetadata, index: Int) -> some View {
        
        ZStack(alignment: .topTrailing) {
            // 이미지
            HStack(alignment: .center, spacing: 16) {
                if let imageURL = metadata.imageURL,
                   let url = URL(string: imageURL) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.hedgeUI.neutralBgSecondary)
                    }
                    .frame(width: 98, height: 98)
                    .clipped()
                    .cornerRadius(8)
                } else {
                    Rectangle()
                        .fill(Color.hedgeUI.neutralBgSecondary)
                        .frame(width: 98, height: 98)
                        .cornerRadius(8)
                }
                
                // 텍스트 정보
                VStack(alignment: .leading, spacing: 6) {
                    Text(metadata.title)
                        .font(FontModel.label2Semibold)
                        .foregroundStyle(Color.hedgeUI.textPrimary)
                        .lineLimit(2)
                    
                    Text(metadata.newsSource)
                        .font(FontModel.caption1Medium)
                        .foregroundStyle(Color.hedgeUI.textAlternative)
                }
                
                Spacer()
            }
            
            // 삭제 버튼
            Button {
                send(.deleteLink(index))
            } label: {
                Image.hedgeUI.closeFill
                    .renderingMode(.template)
                    .foregroundStyle(Color.hedgeUI.textAssistive)
                    .padding(3)
            }
            .padding(.top, 5)
            .padding(.trailing, 4)
        }
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.hedgeUI.neutralBgSecondary, lineWidth: 1.2)
        )
    }
    
    private var pageFloatingView: some View {
        VStack(spacing: 0) {
            // 그라데이션 배경
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0),
                    Color.white.opacity(0.2),
                    Color.white.opacity(0.98)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 32)
            
            // 메인 카드 컨테이너
            HStack(spacing: 12) {
                // 왼쪽 아이콘 영역
                ZStack {
                    // 🔥 이모지가 있는 원형 배경
                    Circle()
                        .fill(Color.hedgeUI.neutralBgSecondary)
                        .frame(width: 24, height: 24)
                        .overlay {
                            Text("🔥")
                                .font(FontModel.caption1Semibold)
                        }
                    
                    // 초록색 원형 인디케이터
                    Circle()
                        .trim(from: 0.0, to: store.endAngle)
                        .stroke(Color.hedgeUI.brandPrimary, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                        .frame(width: 24, height: 24)
                        .rotationEffect(.degrees(-90))
                }
                
                // 페이지 인디케이터 영역
                HStack(spacing: 8) {
                    // 페이지 인디케이터들
                    ForEach(0..<store.principles.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPageIndex ? Color.hedgeUI.brandPrimary : Color.hedgeUI.brandDisabled)
                            .frame(width: 6, height: 6)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 29)
                    .fill(Color.white)
                    .shadow(
                        color: Color.black.opacity(0.1),
                        radius: 30,
                        x: 0,
                        y: 6
                    )
            )
            .padding(.horizontal, 0)
            .padding(.bottom, 32)
        }
    }
}
