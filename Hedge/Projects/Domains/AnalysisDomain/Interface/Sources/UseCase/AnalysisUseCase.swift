import Foundation

public protocol AnalysisUseCase {
    func execute(market: String, symbol: String, time: String) async throws -> String
}
