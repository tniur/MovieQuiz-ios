import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThan(_ result: GameRecord) -> Bool {
        if total == 0 {
            return false
        }
        else {
            return Double(result.correct) / Double(result.total) <= Double(correct) / Double(total)
        }
    }
}
