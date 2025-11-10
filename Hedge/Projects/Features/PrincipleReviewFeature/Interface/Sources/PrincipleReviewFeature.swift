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
import FeedbackDomainInterface

@Reducer
public struct PrincipleReviewFeature {
    private let fetchLinkUseCase: FetchLinkUseCase
    private let uploadImageUseCase: UploadRetrospectionImageUseCase
    private let createRetrospectionUseCase: CreateRetrospectionUseCase
    private let fetchFeedbackUseCase: FetchFeedbackUseCase
    
    public init(
        fetchLinkUseCase: FetchLinkUseCase,
        uploadImageUseCase: UploadRetrospectionImageUseCase,
        createRetrospectionUseCase: CreateRetrospectionUseCase,
        fetchFeedbackUseCase: FetchFeedbackUseCase
    ) {
        self.fetchLinkUseCase = fetchLinkUseCase
        self.uploadImageUseCase = uploadImageUseCase
        self.createRetrospectionUseCase = createRetrospectionUseCase
        self.fetchFeedbackUseCase = fetchFeedbackUseCase
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
        public var isSubmitting: Bool = false
        public var submissionResult: RetrospectionCreateResult?
        public var feedback: FeedbackData?
        
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
        case resetUploadedImages(pageIndex: Int)
        case createRetrospectionSuccess(RetrospectionCreateResult)
        case createRetrospectionFailure(Error)
        case fetchFeedbackSuccess(FeedbackData)
        case fetchFeedbackFailure(Error)
    }
    public enum AsyncAction {
        case loadImagesFromPhotos([PhotosPickerItem])
        case fetchLinkMetadata(String)
        case uploadImages([(Int, [Data])], total: Int)
        case createRetrospection(RetrospectionCreateRequest)
        case fetchFeedback(Int)
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

private func buildCreateRequest(state: PrincipleReviewFeature.State) -> RetrospectionCreateRequest? {
    let symbol = state.stock.code
    let market = state.stock.market //"NASDAQ"
    let orderType = state.tradeType.toRequest
    let price = parseInteger(from: state.tradeHistory.tradingPrice)
    let volume = parseInteger(from: state.tradeHistory.tradingQuantity)
    let currency = state.tradeHistory.concurrency.isEmpty ? "KRW" : state.tradeHistory.concurrency
    guard let orderDate = normalizeDateString(state.tradeHistory.tradingDate) else { return nil }
    let returnRate = parseDouble(from: state.tradeHistory.yield)
    
    guard !state.principles.isEmpty, !state.pageStates.isEmpty else {
        return nil
    }
    
    let pageCount = state.pageStates.count
    let imageResults = state.uploadedImagesPerPage.count == pageCount
    ? state.uploadedImagesPerPage
    : Array(repeating: [UploadedImage](), count: pageCount)
    
    var checks: [RetrospectionPrincipleCheckRequest] = []
    
    for index in 0..<min(state.principles.count, state.pageStates.count) {
        let principle = state.principles[index]
        let pageState = state.pageStates[index]
        
        guard let evaluation = pageState.selectedEvaluation else { continue }
        
        let status = evaluation.toRetrospectionStatus()
        let reason = pageState.text
        let imageIds = index < imageResults.count ? imageResults[index].map { $0.imageId } : []
        let links = pageState.linkSources
        
        let check = RetrospectionPrincipleCheckRequest(
            principleId: principle.id,
            status: status,
            reason: reason,
            imageIds: imageIds,
            links: links
        )
        checks.append(check)
    }
    
    guard !checks.isEmpty else { return nil }
    
    return RetrospectionCreateRequest(
        symbol: symbol,
        market: market,
        orderType: orderType,
        price: price,
        currency: currency,
        volume: volume,
        orderDate: orderDate,
        returnRate: returnRate,
        principleChecks: checks
    )
}

private func parseInteger(from string: String) -> Int {
    let filtered = string.filter { "0123456789".contains($0) }
    return Int(filtered) ?? 0
}

private func parseDouble(from string: String?) -> Double? {
    guard let string = string else { return nil }
    let trimmed = string
        .replacingOccurrences(of: "%", with: "")
        .replacingOccurrences(of: ",", with: "")
        .trimmingCharacters(in: .whitespacesAndNewlines)
    return Double(trimmed)
}

private func normalizeDateString(_ string: String) -> String? {
    let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else { return nil }
    
    let sanitized = trimmed.replacingOccurrences(of: ".", with: "-")
        .replacingOccurrences(of: "/", with: "-")
    
    let inputPatterns = ["yyyy-MM-dd", "yyyyMMdd"]
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "yyyy-MM-dd"
    outputFormatter.locale = Locale(identifier: "en_US_POSIX")
    outputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    
    let inputFormatter = DateFormatter()
    inputFormatter.locale = Locale(identifier: "en_US_POSIX")
    inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    
    for pattern in inputPatterns {
        inputFormatter.dateFormat = pattern
        if let date = inputFormatter.date(from: sanitized) {
            return outputFormatter.string(from: date)
        }
    }
    
    // 직접 숫자만 남아있고 길이가 8인 경우 수동 포맷
    let digits = sanitized.filter { $0.isNumber }
    if digits.count == 8 {
        let year = digits.prefix(4)
        let month = digits.dropFirst(4).prefix(2)
        let day = digits.suffix(2)
        return "\(year)-\(month)-\(day)"
    }
    
    return nil
}

private extension PrincipleEvaluation {
    func toRetrospectionStatus() -> RetrospectionPrincipleStatus {
        switch self {
        case .keep:
            return .kept
        case .normal:
            return .neutral
        case .notKeep:
            return .notKept
        }
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
            state.isSubmitting = true
            state.submissionResult = nil
            state.uploadedImagesPerPage = Array(repeating: [], count: state.pageStates.count)
            
            let uploadTargets = state.pageStates.enumerated().compactMap { index, page -> (Int, [Data])? in
                guard !page.imageDatas.isEmpty else { return nil }
                return (index, page.imageDatas)
            }
            
            if uploadTargets.isEmpty {
                guard let request = buildCreateRequest(state: state) else {
                    state.isSubmitting = false
                    return .none
                }
                return .send(.async(.createRetrospection(request)))
            } else {
                return .send(.async(.uploadImages(uploadTargets, total: state.pageStates.count)))
            }
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
            if state.currentPageIndex < state.uploadedImagesPerPage.count {
                state.uploadedImagesPerPage[state.currentPageIndex] = []
            }
            return .none
        case .addLinkButtonTapped(let link):
            return .send(.delegate(.addLink(link)))
        case .deleteLink(let index):
            if index < state.currentPageState.linkMetadataList.count {
                state.currentPageState.linkMetadataList.remove(at: index)
            }
            if index < state.currentPageState.linkSources.count {
                state.currentPageState.linkSources.remove(at: index)
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
            state.uploadedImagesPerPage = perPage
            guard let request = buildCreateRequest(state: state) else {
                state.isSubmitting = false
                return .none
            }
            return .send(.async(.createRetrospection(request)))
        case .uploadImagesFailure(let error):
            Log.error("Failed to upload images: \(error)")
            state.isSubmitting = false
            return .none
        case .resetUploadedImages(let pageIndex):
            if pageIndex < state.uploadedImagesPerPage.count {
                state.uploadedImagesPerPage[pageIndex] = []
            }
            return .none
        case .createRetrospectionSuccess(let result):
            state.isSubmitting = true
            state.submissionResult = result
            return .send(.async(.fetchFeedback(result.id)))
        case .createRetrospectionFailure(let error):
            state.isSubmitting = false
            Log.error("Failed to create retrospection: \(error)")
            return .none
        case .fetchFeedbackSuccess(let feedbackData):
            state.isSubmitting = false
            state.feedback = feedbackData
            return .none
        case .fetchFeedbackFailure(let error):
            state.isSubmitting = false
            Log.error("Failed to fetch feedback: \(error)")
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
            let pageIndex = state.currentPageIndex
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
                await send(.inner(.resetUploadedImages(pageIndex: pageIndex)))
            }
            
        case .fetchLinkMetadata(let urlString):
            return .run { [linkMetadataList = state.currentPageState.linkMetadataList,
                           linkSources = state.currentPageState.linkSources] send in
                do {
                    let metadata = try await fetchLinkUseCase.execute(urlString: urlString)
                    await send(.binding(.set(\.currentPageState.linkMetadataList, linkMetadataList + [metadata])))
                    await send(.binding(.set(\.currentPageState.linkSources, linkSources + [urlString])))
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
        case .createRetrospection(let request):
            return .run { [createRetrospectionUseCase] send in
                do {
                    let result = try await createRetrospectionUseCase.execute(request)
                    await send(.inner(.createRetrospectionSuccess(result)))
                } catch {
                    await send(.inner(.createRetrospectionFailure(error)))
                }
            }
        case .fetchFeedback(let retrospectionId):
            return .run { [fetchFeedbackUseCase] send in
                do {
                    let feedback = try await fetchFeedbackUseCase.execute(id: retrospectionId)
                    await send(.inner(.fetchFeedbackSuccess(feedback)))
                } catch {
                    await send(.inner(.fetchFeedbackFailure(error)))
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
