import Foundation

import FeedbackDomainInterface
import RemoteDataSourceInterface

public struct DefaultFeedbackRepository: FeedbackRepository {
    private let dataSource: FeedbackDataSource
    
    public init(dataSource: FeedbackDataSource) {
        self.dataSource = dataSource
    }
    
    public func fetch(id: Int) async throws -> FeedbackData {
        let response = try await dataSource.fetchFeedback(retrospectionId: id)
        return response.data.toDomain()
    }
    
    public func create(id: Int) async throws -> FeedbackData {
        let response = try await dataSource.createFeedback(retrospectionId: id)
        return response.data.toDomain()
    }
}

