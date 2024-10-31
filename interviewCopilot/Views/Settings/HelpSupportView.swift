import SwiftUI

struct HelpSupportView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section("Common Questions") {
                    FAQRow(question: "How do interviews work?", answer: "Our AI-powered system guides you through practice interviews...")
                    FAQRow(question: "How is my score calculated?", answer: "Your score is based on multiple factors including...")
                    FAQRow(question: "Can I review past interviews?", answer: "Yes, all your interviews are saved in the history...")
                }
                
                Section("Contact Support") {
                    Button(action: {
                        // Implement email support
                    }) {
                        Label("Email Support", systemImage: "envelope")
                    }
                    
                    Button(action: {
                        // Implement chat support
                    }) {
                        Label("Live Chat", systemImage: "message")
                    }
                }
                
                Section("Resources") {
                    Link(destination: URL(string: "https://docs.interviewcopilot.com")!) {
                        Label("Documentation", systemImage: "book")
                    }
                    
                    Link(destination: URL(string: "https://interviewcopilot.com/blog")!) {
                        Label("Blog", systemImage: "newspaper")
                    }
                }
            }
            .navigationTitle("Help & Support")
            .navigationBarItems(trailing: Button("Done") { dismiss() })
        }
    }
}

struct FAQRow: View {
    let question: String
    let answer: String
    @State private var isExpanded = false
    
    var body: some View {
        DisclosureGroup(
            isExpanded: $isExpanded,
            content: {
                Text(answer)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.vertical, 8)
            },
            label: {
                Text(question)
                    .font(.headline)
            }
        )
    }
} 