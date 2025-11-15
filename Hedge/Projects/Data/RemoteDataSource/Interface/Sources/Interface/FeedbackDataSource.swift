import Foundation

public protocol FeedbackDataSource {
    func fetchFeedback(retrospectionId: Int) async throws -> FeedbackResponseDTO
    func createFeedback(retrospectionId: Int) async throws -> FeedbackResponseDTO
}

