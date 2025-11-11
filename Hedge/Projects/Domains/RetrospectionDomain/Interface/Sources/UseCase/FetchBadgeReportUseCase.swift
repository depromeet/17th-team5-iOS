import Foundation

public protocol FetchBadgeReportUseCase {
    func execute() async throws -> RetrospectionBadgeReport
}

