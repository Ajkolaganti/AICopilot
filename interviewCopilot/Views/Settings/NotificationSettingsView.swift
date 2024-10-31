import SwiftUI

struct NotificationSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("notifyNewFeatures") private var notifyNewFeatures = true
    @AppStorage("notifyInterviewReminders") private var notifyInterviewReminders = true
    @AppStorage("notifyResults") private var notifyResults = true
    @AppStorage("notifyTips") private var notifyTips = true
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Toggle("Interview Reminders", isOn: $notifyInterviewReminders)
                    Toggle("Interview Results", isOn: $notifyResults)
                    Toggle("Daily Practice Tips", isOn: $notifyTips)
                    Toggle("New Features", isOn: $notifyNewFeatures)
                } header: {
                    Text("Notification Preferences")
                } footer: {
                    Text("Choose which notifications you'd like to receive")
                }
            }
            .navigationTitle("Notifications")
            .navigationBarItems(trailing: Button("Done") { dismiss() })
        }
    }
} 