import Foundation

import RetrospectionDomainInterface

public struct UploadImageResponseDTO: Decodable {
    public let code: String
    public let message: String
    public let data: UploadImageDataDTO
    
    public init(code: String, message: String, data: UploadImageDataDTO) {
        self.code = code
        self.message = message
        self.data = data
    }
}

public struct UploadImageDataDTO: Decodable {
    public let imageId: Int
    public let objectKey: String
    public let fileName: String
    public let fileSize: Int
    
    public init(
        imageId: Int,
        objectKey: String,
        fileName: String,
        fileSize: Int
    ) {
        self.imageId = imageId
        self.objectKey = objectKey
        self.fileName = fileName
        self.fileSize = fileSize
    }
}

public extension UploadImageDataDTO {
    func toDomain() -> UploadedImage {
        UploadedImage(
            imageId: imageId,
            objectKey: objectKey,
            fileName: fileName,
            fileSize: fileSize
        )
    }
}

