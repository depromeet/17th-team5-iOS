import Foundation
import SwiftUI
import PhotosUI

import DesignKit

import LinkDomainInterface

public struct PhotoItem: Identifiable, Equatable {
    public let id: UUID
    public let photosPickerItem: PhotosPickerItem
    public var loadedImage: Image?
    public var imageData: Data?
    
    public init(
        id: UUID = UUID(),
        photosPickerItem: PhotosPickerItem,
        loadedImage: Image? = nil,
        imageData: Data? = nil
    ) {
        self.id = id
        self.photosPickerItem = photosPickerItem
        self.loadedImage = loadedImage
        self.imageData = imageData
    }
}

public enum PrincipleEvaluation: Equatable {
    case keep
    case normal
    case notKeep
}

extension PrincipleEvaluation {
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
        
        public init(title: String,
                    lineWidth: CGFloat,
                    foregroundColor: Color,
                    image: Image,
                    textColor: Color,
                    font: FontModel) {
            self.title = title
            self.lineWidth = lineWidth
            self.foregroundColor = foregroundColor
            self.image = image
            self.textColor = textColor
            self.font = font
        }
    }
}

public struct PrincipleReviewPageState: Equatable {
    public var selectedEvaluation: PrincipleEvaluation?
    public var principleDetailShown: Bool
    public var text: String
    public var linkMetadataList: [LinkMetadata]
    public var linkSources: [String]
    public var selectedPhotoItems: [PhotosPickerItem]
    public var loadedImages: [Image]
    public var imageDatas: [Data]
    public var photoItems: [PhotoItem]
    
    public init(
        selectedEvaluation: PrincipleEvaluation? = nil,
        principleDetailShown: Bool = false,
        text: String = "",
        linkMetadataList: [LinkMetadata] = [],
        linkSources: [String] = [],
        selectedPhotoItems: [PhotosPickerItem] = [],
        loadedImages: [Image] = [],
        imageDatas: [Data] = [],
        photoItems: [PhotoItem] = []
    ) {
        self.selectedEvaluation = selectedEvaluation
        self.principleDetailShown = principleDetailShown
        self.text = text
        self.linkMetadataList = linkMetadataList
        self.linkSources = linkSources
        self.selectedPhotoItems = selectedPhotoItems
        self.loadedImages = loadedImages
        self.imageDatas = imageDatas
        self.photoItems = photoItems
    }
}

