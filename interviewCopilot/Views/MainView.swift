import SwiftUI

struct MainView: View {
    @StateObject private var userManager = UserManager.shared
    @StateObject private var viewModel = MainViewModel()
    @State private var showNewInterview = false
    @State private var selectedMode: InterviewMode?
    @State private var showingTutorial = false
    
    private let accentGradient = LinearGradient(
        colors: [.blue, .purple, .pink],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Color(.systemBackground)
                    .overlay(
                        GeometryReader { geometry in
                            Circle()
                                .fill(Color.blue.opacity(0.1))
                                .blur(radius: 30)
                                .offset(x: -geometry.size.width * 0.5, y: -geometry.size.height * 0.2)
                            Circle()
                                .fill(Color.purple.opacity(0.1))
                                .blur(radius: 30)
                                .offset(x: geometry.size.width * 0.5, y: geometry.size.height * 0.2)
                        }
                    )
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        welcomeSection
                        searchAndFilterSection
                        interviewModesSection
                        
                        if !viewModel.recentInterviews.isEmpty {
                            recentInterviewsSection
                        }
                        
                        practiceTopicsSection
                        resourcesSection
                    }
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle("Interview Copilot")
            .sheet(isPresented: $showNewInterview) {
                if let mode = selectedMode {
                    TechnicalCopilotView(interviewMode: mode)
                }
            }
            .sheet(isPresented: $showingTutorial) {
                TutorialView()
            }
        }
    }
    
    private var welcomeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Welcome back,")
                .font(.title2)
            Text(userManager.currentUser?.email ?? "")
                .font(.title.bold())
                .foregroundStyle(accentGradient)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
    
    private var interviewModesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Interview Modes", icon: "person.2.fill")
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    InterviewModeCard(
                        mode: .technical,
                        description: "Data structures, algorithms, and system design",
                        icon: "laptopcomputer",
                        gradient: LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing),
                        selectedMode: $selectedMode,
                        showInterview: $showNewInterview
                    )
                    
                    InterviewModeCard(
                        mode: .behavioral,
                        description: "Leadership, teamwork, and problem-solving",
                        icon: "person.2.fill",
                        gradient: LinearGradient(colors: [.purple, .pink], startPoint: .leading, endPoint: .trailing),
                        selectedMode: $selectedMode,
                        showInterview: $showNewInterview
                    )
                    
                    InterviewModeCard(
                        mode: .custom,
                        description: "Create your own interview format",
                        icon: "slider.horizontal.3",
                        gradient: LinearGradient(colors: [.pink, .orange], startPoint: .leading, endPoint: .trailing),
                        selectedMode: $selectedMode,
                        showInterview: $showNewInterview
                    )
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var recentInterviewsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Recent Interviews", icon: "clock.fill")
            
            ForEach(viewModel.recentInterviews) { interview in
                RecentInterviewRow(interview: interview)
            }
            .padding(.horizontal)
        }
    }
    
    private var searchAndFilterSection: some View {
        VStack(spacing: 16) {
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField("Search topics, questions...", text: $viewModel.searchText)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
            )
            
            // Category Filter
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(PracticeTopic.TopicCategory.allCases, id: \.self) { category in
                        CategoryButton(
                            title: category.rawValue,
                            isSelected: viewModel.selectedCategory == category
                        ) {
                            viewModel.selectedCategory = category
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
    }
    
    private var practiceTopicsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Practice Topics", icon: "book.fill")
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(viewModel.filteredTopics) { topic in
                    PracticeTopicCard(topic: topic)
                        .onTapGesture {
                            // Navigate to topic detail view
                        }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var resourcesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Resources", icon: "folder.fill")
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.resources) { resource in
                        ResourceCard(resource: resource)
                            .onTapGesture {
                                viewModel.openResource(resource)
                            }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

// MARK: - Supporting Views
struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.blue : Color(.systemGray6))
                )
                .foregroundColor(isSelected ? .white : .primary)
        }
    }
}

struct PracticeTopicCard: View {
    let topic: PracticeTopic
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(topic.title)
                .font(.headline)
            Text(topic.description)
                .font(.caption)
                .foregroundColor(.secondary)
            ProgressView(value: topic.progress)
                .tint(.blue)
            Text("\(topic.completedQuestions)/\(topic.totalQuestions) completed")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(colorScheme == .dark ? 
                      Color(.systemGray6).opacity(0.8) : 
                      Color.white.opacity(0.8))
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct ResourceCard: View {
    let resource: Resource
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: resource.icon)
                .font(.title2)
                .foregroundColor(.blue)
            Text(resource.title)
                .font(.headline)
            Text(resource.description)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(width: 160)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(colorScheme == .dark ? 
                      Color(.systemGray6).opacity(0.8) : 
                      Color.white.opacity(0.8))
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct SectionHeader: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack {
            Label(title, systemImage: icon)
                .font(.title3.bold())
            Spacer()
            Button("See All") {
                // Implement navigation to full list
            }
            .font(.subheadline)
            .foregroundColor(.blue)
        }
        .padding(.horizontal)
    }
}

struct RecentInterviewRow: View {
    let interview: InterviewHistory
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(interview.mode)
                    .font(.headline)
                Text(interview.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("\(interview.score)%")
                .font(.headline)
                .foregroundColor(interview.score >= 70 ? .green : .red)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
} 