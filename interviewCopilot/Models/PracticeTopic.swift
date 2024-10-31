import Foundation

struct PracticeTopic: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let category: TopicCategory
    var progress: Double
    var completedQuestions: Int
    var totalQuestions: Int
    
    enum TopicCategory: String, Codable, CaseIterable {
        case dataStructures = "Data Structures"
        case algorithms = "Algorithms"
        case systemDesign = "System Design"
        case behavioral = "Behavioral"
    }
    
    static let sampleTopics = [
        PracticeTopic(
            id: UUID().uuidString,
            title: "Data Structures",
            description: "Arrays, LinkedLists, Trees...",
            category: .dataStructures,
            progress: 0.7,
            completedQuestions: 35,
            totalQuestions: 50
        ),
        PracticeTopic(
            id: UUID().uuidString,
            title: "Algorithms",
            description: "Sorting, Searching, Dynamic Programming...",
            category: .algorithms,
            progress: 0.5,
            completedQuestions: 25,
            totalQuestions: 50
        ),
        PracticeTopic(
            id: UUID().uuidString,
            title: "System Design",
            description: "Scalability, Database Design...",
            category: .systemDesign,
            progress: 0.3,
            completedQuestions: 15,
            totalQuestions: 50
        ),
        PracticeTopic(
            id: UUID().uuidString,
            title: "Behavioral",
            description: "Leadership, Problem Solving...",
            category: .behavioral,
            progress: 0.8,
            completedQuestions: 40,
            totalQuestions: 50
        )
    ]
} 