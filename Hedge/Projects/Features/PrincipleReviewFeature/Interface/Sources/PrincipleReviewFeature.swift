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
import RetrospectionDomainInterface

@Reducer
public struct PrincipleReviewFeature {
    private let fetchLinkUseCase: FetchLinkUseCase
    private let uploadImageUseCase: UploadRetrospectionImageUseCase
    
    public init(
        fetchLinkUseCase: FetchLinkUseCase,
        uploadImageUseCase: UploadRetrospectionImageUseCase
    ) {
        self.fetchLinkUseCase = fetchLinkUseCase
        self.uploadImageUseCase = uploadImageUseCase
    }
    
    @ObservableState
    public struct State: Equatable {
        
        public var tradeType: TradeType
        public var stock: StockSearch
        public var tradeHistory: TradeHistory
        public var principleGroup: PrincipleGroup
        public var principles: [Principle]
        public var pageStates: [PrincipleReviewPageState] = []
        public var linkModalShown: Bool = false
        public var addLink: String = ""
        public var currentPageIndex: Int = 0
        public var uploadedImagesPerPage: [[UploadedImage]] = []
        
        public var totalIndex: Int {
            principles.count
        }
        
        public var endAngle: Double {
            let totalCount = Double(pageStates.count)
            var selectedCount = Double(pageStates.compactMap { $0.selectedEvaluation }.count)
            
            if selectedCount == 0 { selectedCount = 0.01 }
            
            return selectedCount / totalCount
        }
        
        public var isComplete: Bool {
            let totalCount = pageStates.count
            let selectedCount = pageStates.compactMap { $0.selectedEvaluation }.count
            
            return totalCount == selectedCount
        }
        
        public var selectedPrinciple: Principle {
            principles[currentPageIndex]
        }
        
        public var currentPageState: PrincipleReviewPageState {
            get {
                if currentPageIndex < pageStates.count {
                    return pageStates[currentPageIndex]
                }
                return PrincipleReviewPageState()
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
                    principleGroup: PrincipleGroup) {
            self.tradeType = tradeType
            self.stock = stock
            self.tradeHistory = tradeHistory
            self.principleGroup = principleGroup
            self.principles = principleGroup.principles
            self.pageStates = Array(repeating: PrincipleReviewPageState(), count: principles.count)
            self.uploadedImagesPerPage = Array(repeating: [], count: principles.count)
        }
        
        public func evalutionStyle(_ lhs: PrincipleEvaluation?, _ rhs: PrincipleEvaluation) -> PrincipleEvaluation.Style {
            let isSelected: Bool = lhs == rhs
            let image: Image = isSelected ? rhs.selectedImage : rhs.unselectedImage
            
            return PrincipleEvaluation.Style(title: rhs.title,
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
        case completeButtonTapped
        case loadPhotos
        case addLinkButtonTapped(String)
        case deletePhoto(UUID)
        case deleteLink(Int)
        case pageChanged(Int)
    }
    public enum InnerAction {
        case linkDismiss
        case uploadImagesSuccess([[UploadedImage]])
        case uploadImagesFailure(Error)
    }
    public enum AsyncAction {
        case loadImagesFromPhotos([PhotosPickerItem])
        case fetchLinkMetadata(String)
        case uploadImages([(Int, [Data])], total: Int)
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
        case .completeButtonTapped:
            let uploadTargets = state.pageStates.enumerated().compactMap { index, page -> (Int, [Data])? in
                guard !page.imageDatas.isEmpty else { return nil }
                return (index, page.imageDatas)
            }
            guard !uploadTargets.isEmpty else {
                return .none
            }
            return .send(.async(.uploadImages(uploadTargets, total: state.pageStates.count)))
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
                if index < state.currentPageState.imageDatas.count {
                    state.currentPageState.imageDatas.remove(at: index)
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
        case .uploadImagesSuccess(let perPage):
            dump(perPage)
            state.uploadedImagesPerPage = perPage
            return .none
        case .uploadImagesFailure(let error):
            Log.error("Failed to upload images: \(error)")
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
                var datas: [Data] = []
                var updatedPhotoItems: [PhotoItem] = []
                
                for photoItem in photoItems {
                    guard let data = try? await photoItem.loadTransferable(type: Data.self),
                          let uiImage = UIImage(data: data) else {
                        updatedPhotoItems.append(PhotoItem(photosPickerItem: photoItem, loadedImage: nil, imageData: nil))
                        continue
                    }
                    
                    let loadedImage = Image(uiImage: uiImage)
                    images.append(loadedImage)
                    
                    if let jpegData = uiImage.jpegData(compressionQuality: 0.8) {
                        datas.append(jpegData)
                        updatedPhotoItems.append(PhotoItem(photosPickerItem: photoItem, loadedImage: loadedImage, imageData: jpegData))
                    } else {
                        datas.append(data)
                        updatedPhotoItems.append(PhotoItem(photosPickerItem: photoItem, loadedImage: loadedImage, imageData: data))
                    }
                }
                
                await send(.binding(.set(\.currentPageState.loadedImages, images)))
                await send(.binding(.set(\.currentPageState.imageDatas, datas)))
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
        case .uploadImages(let uploadTargets, let total):
            return .run { [uploadImageUseCase] send in
                var perPageResults = Array(repeating: [UploadedImage](), count: total)
                do {
                    for (index, datas) in uploadTargets {
                        var uploadedForPage: [UploadedImage] = []
                        for data in datas {
                            let fileName = "retrospection_\(UUID().uuidString).jpg"
                            let result = try await uploadImageUseCase.execute(
                                domain: "retrospection",
                                fileData: data,
                                fileName: fileName,
                                mimeType: "image/jpeg"
                            )
                            uploadedForPage.append(result)
                        }
                        if index < perPageResults.count {
                            perPageResults[index] = uploadedForPage
                        }
                    }
                    await send(.inner(.uploadImagesSuccess(perPageResults)))
                } catch {
                    await send(.inner(.uploadImagesFailure(error)))
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
