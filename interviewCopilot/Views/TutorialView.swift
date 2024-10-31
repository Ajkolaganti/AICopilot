import SwiftUI

struct TutorialView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentPage = 0
    
    private let tutorials = [
        TutorialPage(
            title: "Welcome to Interview Copilot",
            description: "Your AI-powered interview preparation assistant",
            icon: "brain.head.profile"
        ),
        TutorialPage(
            title: "Practice Interviews",
            description: "Choose from technical, behavioral, or custom interview modes",
            icon: "person.2.fill"
        ),
        TutorialPage(
            title: "Real-time Feedback",
            description: "Get instant feedback and suggestions to improve your responses",
            icon: "text.bubble.fill"
        ),
        TutorialPage(
            title: "Track Progress",
            description: "Monitor your improvement with detailed analytics",
            icon: "chart.bar.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            TabView(selection: $currentPage) {
                ForEach(0..<tutorials.count, id: \.self) { index in
                    TutorialPageView(page: tutorials[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            
            VStack {
                Spacer()
                
                if currentPage == tutorials.count - 1 {
                    Button("Get Started") {
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.bottom, 50)
                }
            }
        }
    }
}

struct TutorialPage: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
}

struct TutorialPageView: View {
    let page: TutorialPage
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: page.icon)
                .font(.system(size: 80))
                .foregroundStyle(.blue)
            
            Text(page.title)
                .font(.title.bold())
                .multilineTextAlignment(.center)
            
            Text(page.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
        .padding()
    }
} 