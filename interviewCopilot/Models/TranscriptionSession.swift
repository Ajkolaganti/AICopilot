import Foundation

struct TranscriptionSession: Identifiable, Codable {
    let id: String
    let text: String
    let date: Date
    let duration: TimeInterval
    
    static var empty: TranscriptionSession {
        TranscriptionSession(
            id: UUID().uuidString,
            text: "",
            date: Date(),
            duration: 0
        )
    }
} 