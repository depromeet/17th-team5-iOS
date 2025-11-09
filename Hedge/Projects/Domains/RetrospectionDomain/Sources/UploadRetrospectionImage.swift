import Foundation

import RetrospectionDomainInterface

public struct UploadRetrospectionImage: UploadRetrospectionImageUseCase {
    private let repository: RetrospectionRepository
    
    public init(repository: RetrospectionRepository) {
        self.repository = repository
    }
    
    public func execute(
        domain: String,
        fileData: Data,
        fileName: String,
        mimeType: String
    ) async throws -> UploadedImage {
        try await repository.uploadImage(
            domain: domain,
            fileData: fileData,
            fileName: fileName,
            mimeType: mimeType
        )
    }
}

