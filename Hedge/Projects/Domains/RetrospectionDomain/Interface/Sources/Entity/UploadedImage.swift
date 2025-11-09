import Foundation

public struct UploadedImage: Equatable {
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

