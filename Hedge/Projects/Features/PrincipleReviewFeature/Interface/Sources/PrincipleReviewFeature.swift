import Foundation
import Combine
import PhotosUI
import SwiftUI

import ComposableArchitecture

import Core
import Shared
import DesignKit

import LinkDomainInterface
import StockDomainInterface
import PrinciplesDomainInterface

public struct PhotoItem: Identifiable, Equatable {
    public let id = UUID()
    public let photosPickerItem: PhotosPickerItem
    public var loadedImage: Image?
    
    public init(photosPickerItem: PhotosPickerItem, loadedImage: Image? = nil) {
        self.photosPickerItem = photosPickerItem
        self.loadedImage = loadedImage
    }
}

@Reducer
public struct PrincipleReviewFeature {
    private let fetchLinkUseCase: FetchLinkUseCase
    
    public init(fetchLinkUseCase: FetchLinkUseCase) {
        self.fetchLinkUseCase = fetchLinkUseCase
    }
    
    public enum Evaluation {
        case keep
        case normal
        case notKeep
        
        public var selectedImage: Image {
            switch self {
            case .keep:
                return Image.hedgeUI.keep
            case .normal:
                return Image.hedgeUI.normal
            case .notKeep:
                return Image.hedgeUI.notKeep
            }
        }
        
        public var unselectedImage: Image {
            switch self {
            case .keep:
                return Image.hedgeUI.keepDisabled
            case .normal:
                return Image.hedgeUI.normalDisabled
            case .notKeep:
                return Image.hedgeUI.notKeepDisabled
            }
        }
        
        public var title: String {
            switch self {
            case .keep:
                return "지켰어요"
            case .normal:
                return "보통이에요"
            case .notKeep:
                return "안지켰어요"
            }
        }
        
        public struct Style {
            public let title: String
            public let lineWidth: CGFloat
            public let foregroundColor: Color
            public let image: Image
            public let textColor: Color
            public let font: FontModel
        }
    }
    
    // 각 페이지별 독립적인 상태
    public struct PageState: Equatable {
        public var selectedEvaluation: Evaluation? = nil
        public var principleDetailShown: Bool = false
        public var text: String = ""
        public var linkMetadataList: [LinkMetadata] = []
        public var selectedPhotoItems: [PhotosPickerItem] = []
        public var loadedImages: [Image] = []
        public var photoItems: [PhotoItem] = []
        
        public init() {}
    }
    
    @ObservableState
    public struct State: Equatable {
        public var tradeType: TradeType
        public var stock: StockSearch
        public var tradeHistory: TradeHistory
        public var principles: [Principle]
        public var pageStates: [PageState] = []
        public var linkModalShown: Bool = false
        public var addLink: String = ""
        public var currentPageIndex: Int = 0
        
        public var totalIndex: Int {
            principles.count
        }
        
        public var endAngle: Double {
            let totalCount = Double(pageStates.count)
            var selectedCount = Double(pageStates.compactMap { $0.selectedEvaluation }.count)
            
            if selectedCount == 0 { selectedCount = 0.01 }
            
            return selectedCount / totalCount
        }
        
        public var selectedPrinciple: Principle {
            principles[currentPageIndex]
        }
        
        public var currentPageState: PageState {
            get {
                if currentPageIndex < pageStates.count {
                    return pageStates[currentPageIndex]
                }
                return PageState()
            }
            set {
                if currentPageIndex < pageStates.count {
                    pageStates[currentPageIndex] = newValue
                }
            }
        }
        
        public init(tradeType: TradeType,
                    stock: StockSearch,
                    tradeHistory: TradeHistory,
                    principles: [Principle]) {
            self.tradeType = tradeType
            self.stock = stock
            self.tradeHistory = tradeHistory
            self.principles = principles
            self.pageStates = Array(repeating: PageState(), count: principles.count)
        }
        
        public func evalutionStyle(_ lhs: Evaluation?, _ rhs: Evaluation) -> Evaluation.Style {
            let isSelected: Bool = lhs == rhs
            let image: Image = isSelected ? rhs.selectedImage : rhs.unselectedImage
            
            return Evaluation.Style(title: rhs.title,
                         lineWidth: isSelected ? 1.5 : 1,
                         foregroundColor: isSelected ? Color.hedgeUI.brandPrimary : Color.hedgeUI.neutralBgSecondary,
                         image: image,
                         textColor: isSelected ? Color.hedgeUI.brandDarken : Color.hedgeUI.textAlternative,
                         font: isSelected ? FontModel.label1Semibold : FontModel.label1Medium)
        }
    }
    
    public enum Action: FeatureAction, ViewAction, BindableAction {
        case binding(BindingAction<State>)
        case view(View)
        case inner(InnerAction)
        case async(AsyncAction)
        case scope(ScopeAction)
        case delegate(DelegateAction)
    }
    
    public enum View {
        case onAppear
        case backButtonTapped
        case keepButtonTapped
        case normalButtonTapped
        case notKeepButtonTapped
        case pricipleToggleButtonTapped
        case linkButtonTapped
        case loadPhotos
        case addLinkButtonTapped(String)
        case deletePhoto(UUID)
        case deleteLink(Int)
        case pageChanged(Int)
    }
    public enum InnerAction {
        case linkDismiss
    }
    public enum AsyncAction {
        case loadImagesFromPhotos([PhotosPickerItem])
        case fetchLinkMetadata(String)
    }
    public enum ScopeAction { }
    public enum DelegateAction {
        case addLink(String)
    }
    
    // MARK: - Debounce ID
    private enum CancelID { case searchDebounce }
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce(reducerCore)
    }
}

extension PrincipleReviewFeature {
    // MARK: - Reducer Core
    func reducerCore(
        _ state: inout State,
        _ action: Action
    ) -> Effect<Action> {
        switch action {
        case .binding:
            return .none
            
        case .view(let action):
            return viewCore(&state, action)
            
        case .inner(let action):
            return innerCore(&state, action)
            
        case .async(let action):
            return asyncCore(&state, action)
            
        case .scope(let action):
            return scopeCore(&state, action)
            
        case .delegate(let action):
            return delegateCore(&state, action)
        }
    }
    
    // MARK: - View Core
    func viewCore(
        _ state: inout State,
        _ action: View
    ) -> Effect<Action> {
        switch action {
        case .onAppear:
            return .none
        case .backButtonTapped:
            return .none
        case .keepButtonTapped:
            state.currentPageState.selectedEvaluation = state.currentPageState.selectedEvaluation == .keep ? nil : .keep
            return .none
        case .normalButtonTapped:
            state.currentPageState.selectedEvaluation = state.currentPageState.selectedEvaluation == .normal ? nil : .normal
            return .none
        case .notKeepButtonTapped:
            state.currentPageState.selectedEvaluation = state.currentPageState.selectedEvaluation == .notKeep ? nil : .notKeep
            return .none
        case .pricipleToggleButtonTapped:
            state.currentPageState.principleDetailShown.toggle()
            return .none
        case .linkButtonTapped:
            state.linkModalShown = true
            return .none
        case .loadPhotos:
            // selectedPhotoItems를 photoItems로 동기화
            state.currentPageState.photoItems = state.currentPageState.selectedPhotoItems.map { PhotoItem(photosPickerItem: $0) }
            return .send(.async(.loadImagesFromPhotos(state.currentPageState.selectedPhotoItems)))
        case .deletePhoto(let photoId):
            // ID로 PhotoItem 찾아서 삭제
            if let index = state.currentPageState.photoItems.firstIndex(where: { $0.id == photoId }) {
                state.currentPageState.photoItems.remove(at: index)
                // selectedPhotoItems와 loadedImages도 동기화
                if index < state.currentPageState.selectedPhotoItems.count {
                    state.currentPageState.selectedPhotoItems.remove(at: index)
                }
                if index < state.currentPageState.loadedImages.count {
                    state.currentPageState.loadedImages.remove(at: index)
                }
            }
            return .none
        case .addLinkButtonTapped(let link):
            return .send(.delegate(.addLink(link)))
        case .deleteLink(let index):
            if index < state.currentPageState.linkMetadataList.count {
                state.currentPageState.linkMetadataList.remove(at: index)
            }
            return .none
        case .pageChanged(let newIndex):
            state.currentPageIndex = newIndex
            return .none
        }
    }
    
    // MARK: - Inner Core
    func innerCore(
        _ state: inout State,
        _ action: InnerAction
    ) -> Effect<Action> {
        switch action {
        case .linkDismiss:
            state.linkModalShown = false
            return .none
        }
    }
    
    // MARK: - Async Core
    func asyncCore(
        _ state: inout State,
        _ action: AsyncAction
    ) -> Effect<Action> {
        switch action {
        case .loadImagesFromPhotos(let photoItems):
            return .run { send in
                var images: [Image] = []
                var updatedPhotoItems: [PhotoItem] = []
                
                for photoItem in photoItems {
                    if let data = try? await photoItem.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        let loadedImage = Image(uiImage: uiImage)
                        images.append(loadedImage)
                        updatedPhotoItems.append(PhotoItem(photosPickerItem: photoItem, loadedImage: loadedImage))
                    } else {
                        updatedPhotoItems.append(PhotoItem(photosPickerItem: photoItem, loadedImage: nil))
                    }
                }
                
                await send(.binding(.set(\.currentPageState.loadedImages, images)))
                await send(.binding(.set(\.currentPageState.photoItems, updatedPhotoItems)))
            }
            
        case .fetchLinkMetadata(let urlString):
            return .run { [linkMetadataList = state.currentPageState.linkMetadataList] send in
                do {
                    let metadata = try await fetchLinkUseCase.execute(urlString: urlString)
                    await send(.binding(.set(\.currentPageState.linkMetadataList, linkMetadataList + [metadata])))
                } catch {
                    // 에러 처리는 필요에 따라 추가
                    print("Failed to fetch link metadata: \(error)")
                }
            }
        }
    }
    
    // MARK: - Scope Core
    func scopeCore(
        _ state: inout State,
        _ action: ScopeAction
    ) -> Effect<Action> {
        
    }
    
    // MARK: - Delegate Core
    func delegateCore(
        _ state: inout State,
        _ action: DelegateAction
    ) -> Effect<Action> {
        switch action {
        case .addLink(let link):
            state.addLink = link
            return .concatenate(
                .send(.inner(.linkDismiss)),
                .send(.async(.fetchLinkMetadata(link)))
            )
        }
    }
}
