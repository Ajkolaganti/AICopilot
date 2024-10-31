import Foundation

struct Resource: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let icon: String
    let type: ResourceType
    let url: URL
    
    enum ResourceType: String, Codable {
        case guide = "Guide"
        case questionBank = "Question Bank"
        case video = "Video"
    }
    
    static let sampleResources = [
        Resource(
            id: UUID().uuidString,
            title: "Interview Guide",
            description: "Comprehensive preparation guide",
            icon: "book.fill",
            type: .guide,
            url: URL(string: "https://interviewcopilot.com/guide")!
        ),
        Resource(
            id: UUID().uuidString,
            title: "Question Bank",
            description: "1000+ practice questions",
            icon: "list.bullet.clipboard",
            type: .questionBank,
            url: URL(string: "https://interviewcopilot.com/questions")!
        ),
        Resource(
            id: UUID().uuidString,
            title: "Video Tutorials",
            description: "Learn from experts",
            icon: "play.circle.fill",
            type: .video,
            url: URL(string: "https://interviewcopilot.com/tutorials")!
        )
    ]
} 