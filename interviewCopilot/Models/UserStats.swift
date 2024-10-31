import Foundation

struct UserStats: Codable {
    var totalInterviews: Int
    var totalHours: Double
    var averageScore: Int
    var joinDate: Date
    
    static var empty: UserStats {
        UserStats(
            totalInterviews: 0,
            totalHours: 0.0,
            averageScore: 0,
            joinDate: Date()
        )
    }
} 