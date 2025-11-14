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
    @State private var isAnimating: Bool = false
    
    public init(store: StoreOf<PrincipleReviewFeature>) {
        self.store = store
    }
    
    public var body: some View {
        Group {
            if store.state.isSubmitting {
                ZStack(alignment: .center) {
                    Color.hedgeUI.backgroundWhite
                    
                    Circle()
                        .trim(from: 0.0, to: 0.35)
                        .stroke(Color.hedgeUI.brandPrimary, style: StrokeStyle(lineWidth: 3.5, lineCap: .round))
                        .frame(width: 32, height: 32)
                        .rotationEffect(.degrees(-90))
                        .rotationEffect(.degrees(isAnimating ? 360 : 0))
                        .animation(
                            .linear(duration: 0.8)
                            .repeatForever(autoreverses: false),
                            value: isAnimating
                        )
                        .onAppear { isAnimating = true }
                        .onDisappear { isAnimating = false }
                }
            } else {
                mainContent
            }
        }
    }
    
    private var mainContent: some View {
        
        VStack(spacing: 0) {
            if isFocused == false {
                navigationBar
                stockSummaryView
                
                HedgeSpacer(height: 1)
                    .color(Color.hedgeUI.neutralBgSecondary)
                    .padding(.horizontal, 20)
                
                HedgeSpacer(height: 16)
            }
            
            GeometryReader { geometry in
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 0) {
                            ForEach(0..<store.principles.count, id: \.self) { index in
                                singleReviewView(for: index)
                                    .frame(width: geometry.size.width)
                                    .id(index)
                                    .background(
                                        GeometryReader { itemGeometry in
                                            Color.clear
                                                .preference(
                                                    key: ScrollOffsetPreferenceKey.self,
                                                    value: [index: itemGeometry.frame(in: .named("scroll")).minX]
                                                )
                                        }
                                    )
                            }
                        }
                    }
                    .coordinateSpace(name: "scroll")
                    .scrollTargetBehavior(.paging)
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { offsets in
                        guard !offsets.isEmpty else { return }
                        
                        // 화면 중앙에 가장 가까운 아이템 찾기
                        let screenCenter = geometry.size.width / 2
                        var closestIndex = currentPageIndex
                        var minDistance: CGFloat = .infinity
                        
                        for (index, offset) in offsets {
                            // 아이템의 중앙 위치 계산
                            let itemCenter = offset + geometry.size.width / 2
                            let distance = abs(itemCenter - screenCenter)
                            if distance < minDistance {
                                minDistance = distance
                                closestIndex = index
                            }
                        }
                        
                        if closestIndex != currentPageIndex {
                            currentPageIndex = closestIndex
                        }
                    }
                    .ignoresSafeArea(edges: .bottom)
                }
            }
        }
        .onChange(of: currentPageIndex) { _, newValue in
            send(.pageChanged(newValue))
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
        .hedgeModal(
            isPresented: $store.state.cautionModalPresented,
            title: "링크를 더 추가할 수 없어요",
            subtitle: "3개까지만 추가할 수 있어요",
            showIcon: false,
            actions: .init(
                primaryTitle: "확인",
                onPrimary: {
                    send(.cautionModalTapped)
                }))
        .hedgeModal(
            isPresented: $store.state.backCautionModalPresented,
            title: "정말 이전으로 갈까요?",
            subtitle: "기록 중인 회고가 저장되지 않아요",
            actions: .init(
                primaryTitle: "이전으로",
                onPrimary: {
                    send(.backConfirmButtonTapped)
                },
                secondaryTitle: "취소",
                onSecondary: {
                    send(.backCancelButttonTapped)
                })
        )
        .overlay(alignment: .bottom) {
            if focusWithAnimation {
                keyboardResourceButtonView
            } else {
                ZStack(alignment: .bottom) {
                    // 그라디언트 배경 (뒤에 위치)
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color.white.opacity(0.0), location: 0.0),
                            .init(color: Color.white.opacity(0.7), location: 0.21),
                            .init(color: Color.white.opacity(0.98), location: 1.0)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: 82)
                    .allowsHitTesting(false)
                    
                    // pageFloatingView (바닥에 딱 붙음)
                    pageFloatingView
                        .padding(.bottom, 32)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
        }
        .ignoresSafeArea(.container, edges: .bottom)
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
            
            Text("지키셨나요?")
                .foregroundStyle(Color.hedgeUI.grey900)
                .font(FontModel.body3Medium)
                .fixedSize(horizontal: false, vertical: true)
            
            HStack(alignment: .top, spacing: 0) {
                Text(store.principles[index].principle)
                    .foregroundStyle(Color.hedgeUI.grey900)
                    .font(FontModel.h1Semibold)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .layoutPriority(1)
                
                Spacer(minLength: 8)
                
                Rectangle()
                    .frame(width: 12, height: 0)
                    .foregroundStyle(.clear)
                
                Image.hedgeUI.arrowDown
                    .renderingMode(.template)
                    .foregroundStyle(Color.hedgeUI.textAssistive)
                    .padding(.top, 4)
                    .onTapGesture {
                        send(.pricipleToggleButtonTapped,
                             animation: .easeInOut(duration: 0.3))
                        isPresented = true
                    }
            }
        }
               .padding(.vertical, 10)
               .padding(.horizontal, 20)
               .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private func principleDetailView(for index: Int) -> some View {
        if store.currentPageState.principleDetailShown {
            Text(store.principles[index].description)
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
            
            if !isFocused {
                resourceButtonView
            }
            
            ScrollView(.horizontal) {
                HStack(alignment: .top, spacing: 12) {
                    ForEach(store.currentPageState.photoItems) { photoItem in
                        ZStack(alignment: .topTrailing) {
                            if let image = photoItem.loadedImage {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 120, height: 120)
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
        // .padding(.bottom, 20)
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
            maxSelectionCount: 3,
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
    }
    
    // MARK: - Scroll Offset Preference Key
    private struct ScrollOffsetPreferenceKey: PreferenceKey {
        static var defaultValue: [Int: CGFloat] = [:]
        static func reduce(value: inout [Int: CGFloat], nextValue: () -> [Int: CGFloat]) {
            value.merge(nextValue(), uniquingKeysWith: { _, new in new })
        }
    }
}
