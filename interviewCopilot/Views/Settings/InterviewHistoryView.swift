import SwiftUI

struct InterviewHistory: Identifiable, Codable {
    let id: String
    let date: Date
    let mode: String
    let duration: TimeInterval
    let score: Int
}

struct InterviewHistoryView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("interviewHistory") private var historyData: Data?
    
    private var interviews: [InterviewHistory] {
        if let data = historyData,
           let decoded = try? JSONDecoder().decode([InterviewHistory].self, from: data) {
            return decoded
        }
        return []
    }
    
    var body: some View {
        NavigationView {
            List {
                if interviews.isEmpty {
                    Text("No interviews yet")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(interviews) { interview in
                        InterviewHistoryRow(interview: interview)
                    }
                }
            }
            .navigationTitle("Interview History")
            .navigationBarItems(trailing: Button("Done") { dismiss() })
        }
    }
}

struct InterviewHistoryRow: View {
    let interview: InterviewHistory
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(interview.mode)
                    .font(.headline)
                Spacer()
                Text(interview.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Label("\(Int(interview.duration / 60)) min", systemImage: "clock")
                Spacer()
                Label("\(interview.score)%", systemImage: "chart.bar.fill")
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
} 