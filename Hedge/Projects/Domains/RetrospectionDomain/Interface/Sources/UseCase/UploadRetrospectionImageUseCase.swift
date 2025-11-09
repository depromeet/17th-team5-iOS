import Foundation

public protocol UploadRetrospectionImageUseCase {
    func execute(
        domain: String,
        fileData: Data,
        fileName: String,
        mimeType: String
    ) async throws -> UploadedImage
}

