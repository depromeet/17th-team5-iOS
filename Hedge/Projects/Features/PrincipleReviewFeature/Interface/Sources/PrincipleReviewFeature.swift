import Foundation
import Combine
import PhotosUI
import SwiftUI

import ComposableArchitecture

import Core
import Shared
import DesignKit

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
        
        public static func style(_ lhs: Evaluation?, _ rhs: Evaluation) -> Style {
            let isSelected: Bool = lhs == rhs
            let image: Image = isSelected ? rhs.selectedImage : rhs.unselectedImage
            
            return Style(title: rhs.title,
                         lineWidth: isSelected ? 1.5 : 1,
                         foregroundColor: isSelected ? Color.hedgeUI.brandPrimary : Color.hedgeUI.neutralBgSecondary,
                         image: image,
                         textColor: isSelected ? Color.hedgeUI.brandDarken : Color.hedgeUI.textAlternative,
                         font: isSelected ? FontModel.label1Semibold : FontModel.label1Medium)
        }
    }
    
    public init() {
        
    }
    
    @ObservableState
    public struct State: Equatable {
        public var tradeType: TradeType
        public var stock: StockSearch
        public var tradeHistory: TradeHistory
        public var principles: [Principle]
        public var selectedEvaluation: Evaluation? = nil
        public var principleDetailShown: Bool = false
        public var text: String = ""
        public var selectedPhotoItems: [PhotosPickerItem] = []
        public var loadedImages: [Image] = []
        public var photoItems: [PhotoItem] = []
        
        public var totalIndex: Int {
            principles.count
        }
        
        private var selectedIndex: Int = 0
        
        public var selectedPrinciple: Principle {
            principles[selectedIndex]
        }
        
        public init(tradeType: TradeType,
                    stock: StockSearch,
                    tradeHistory: TradeHistory,
                    principles: [Principle]) {
            self.tradeType = tradeType
            self.stock = stock
            self.tradeHistory = tradeHistory
            self.principles = principles
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
        case deletePhoto(UUID)
    }
    public enum InnerAction { }
    public enum AsyncAction {
        case loadImagesFromPhotos([PhotosPickerItem])
    }
    public enum ScopeAction { }
    public enum DelegateAction { }
    
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
            state.selectedEvaluation = state.selectedEvaluation == .keep ? nil : .keep
            return .none
        case .normalButtonTapped:
            state.selectedEvaluation = state.selectedEvaluation == .normal ? nil : .normal
            return .none
        case .notKeepButtonTapped:
            state.selectedEvaluation = state.selectedEvaluation == .notKeep ? nil : .notKeep
            return .none
        case .pricipleToggleButtonTapped:
            state.principleDetailShown.toggle()
            return .none
        case .linkButtonTapped:
            return .none
        case .loadPhotos:
            // selectedPhotoItems를 photoItems로 동기화
            state.photoItems = state.selectedPhotoItems.map { PhotoItem(photosPickerItem: $0) }
            return .send(.async(.loadImagesFromPhotos(state.selectedPhotoItems)))
        case .deletePhoto(let photoId):
            // ID로 PhotoItem 찾아서 삭제
            if let index = state.photoItems.firstIndex(where: { $0.id == photoId }) {
                state.photoItems.remove(at: index)
                // selectedPhotoItems와 loadedImages도 동기화
                if index < state.selectedPhotoItems.count {
                    state.selectedPhotoItems.remove(at: index)
                }
                if index < state.loadedImages.count {
                    state.loadedImages.remove(at: index)
                }
            }
            return .none
        }
    }
    
    // MARK: - Inner Core
    func innerCore(
        _ state: inout State,
        _ action: InnerAction
    ) -> Effect<Action> {
        
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
                
                await send(.binding(.set(\.loadedImages, images)))
                await send(.binding(.set(\.photoItems, updatedPhotoItems)))
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
        
    }
}
