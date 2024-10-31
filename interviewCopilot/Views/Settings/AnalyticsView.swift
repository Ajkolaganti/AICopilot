import SwiftUI
import Charts

struct AnalyticsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var userManager = UserManager.shared
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Overall Stats
                    statsOverview
                    
                    // Performance Chart
                    performanceChart
                    
                    // Interview Types Breakdown
                    interviewTypesBreakdown
                }
                .padding()
            }
            .navigationTitle("Analytics")
            .navigationBarItems(trailing: Button("Done") { dismiss() })
        }
    }
    
    private var statsOverview: some View {
        VStack(spacing: 16) {
            Text("Overall Performance")
                .font(.title2.bold())
            
            HStack(spacing: 20) {
                StatBox(
                    title: "Total Interviews",
                    value: "\(userManager.userStats?.totalInterviews ?? 0)",
                    icon: "person.2.fill"
                )
                
                StatBox(
                    title: "Average Score",
                    value: "\(userManager.userStats?.averageScore ?? 0)%",
                    icon: "chart.bar.fill"
                )
            }
        }
    }
    
    private var performanceChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Progress Over Time")
                .font(.title2.bold())
            
            // Placeholder for actual chart implementation
            Rectangle()
                .fill(Color.secondary.opacity(0.2))
                .frame(height: 200)
                .overlay(
                    Text("Performance Chart")
                        .foregroundColor(.secondary)
                )
        }
    }
    
    private var interviewTypesBreakdown: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Interview Types")
                .font(.title2.bold())
            
            VStack(spacing: 12) {
                InterviewTypeRow(type: "Technical", count: 5, percentage: 40)
                InterviewTypeRow(type: "Behavioral", count: 4, percentage: 35)
                InterviewTypeRow(type: "Custom", count: 3, percentage: 25)
            }
        }
    }
}

struct StatBox: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
            
            Text(value)
                .font(.title2.bold())
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(12)
    }
}

struct InterviewTypeRow: View {
    let type: String
    let count: Int
    let percentage: Double
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(type)
                    .font(.headline)
                Spacer()
                Text("\(count) interviews")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.secondary.opacity(0.2))
                    
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: geometry.size.width * percentage / 100)
                }
            }
            .frame(height: 8)
            .cornerRadius(4)
        }
    }
} 