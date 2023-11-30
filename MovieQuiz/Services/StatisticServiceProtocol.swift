import Foundation

protocol StatisticServiceProtocol {
    var correctAnswers: Int { get }
    var totalAnswers: Int { get }
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    func store(correct: Int, total: Int)
}
