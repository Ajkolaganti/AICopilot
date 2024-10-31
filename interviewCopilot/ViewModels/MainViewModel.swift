import Foundation
import Combine
import UIKit

@MainActor
class MainViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var selectedCategory: PracticeTopic.TopicCategory = .dataStructures
    @Published var topics: [PracticeTopic] = []
    @Published var resources: [Resource] = []
    @Published var recentInterviews: [InterviewHistory] = []
    @Published var filteredTopics: [PracticeTopic] = []
    
    private var cancellables = Set<AnyCancellable>()
    private let userDefaults = UserDefaults.standard
    
    init() {
        loadData()
        setupSearch()
    }
    
    private func setupSearch() {
        $searchText
            .combineLatest($selectedCategory)
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] searchText, category in
                self?.filterTopics(searchText: searchText, category: category)
            }
            .store(in: &cancellables)
    }
    
    private func filterTopics(searchText: String, category: PracticeTopic.TopicCategory) {
        var filtered = topics
        
        // Apply category filter
        filtered = filtered.filter { topic in
            topic.category == category
        }
        
        // Apply search filter
        if !searchText.isEmpty {
            filtered = filtered.filter { topic in
                topic.title.localizedCaseInsensitiveContains(searchText) ||
                topic.description.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        filteredTopics = filtered
    }
    
    func loadData() {
        // Load topics
        if let data = userDefaults.data(forKey: "practiceTopics"),
           let decoded = try? JSONDecoder().decode([PracticeTopic].self, from: data) {
            topics = decoded
        } else {
            topics = PracticeTopic.sampleTopics
            savePracticeTopics()
        }
        
        // Load resources
        resources = Resource.sampleResources
        
        // Load recent interviews
        if let data = userDefaults.data(forKey: "interviewHistory"),
           let decoded = try? JSONDecoder().decode([InterviewHistory].self, from: data) {
            recentInterviews = Array(decoded.prefix(5))
        }
        
        filterTopics(searchText: searchText, category: selectedCategory)
    }
    
    func savePracticeTopics() {
        if let encoded = try? JSONEncoder().encode(topics) {
            userDefaults.set(encoded, forKey: "practiceTopics")
        }
    }
    
    func updateTopicProgress(topicId: String, progress: Double) {
        if let index = topics.firstIndex(where: { $0.id == topicId }) {
            topics[index].progress = progress
            savePracticeTopics()
        }
    }
    
    func openResource(_ resource: Resource) {
        UIApplication.shared.open(resource.url)
    }
} 
