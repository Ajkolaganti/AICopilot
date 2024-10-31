import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Group {
                        policySection(
                            title: "Information We Collect",
                            content: """
                            We collect information that you provide directly to us, including:
                            • Email address and account information
                            • Interview recordings and transcripts
                            • Performance data and analytics
                            • Usage information and preferences
                            """
                        )
                        
                        policySection(
                            title: "How We Use Your Information",
                            content: """
                            Your information is used to:
                            • Provide and improve our services
                            • Personalize your experience
                            • Analyze usage patterns
                            • Send important notifications
                            """
                        )
                        
                        policySection(
                            title: "Data Security",
                            content: """
                            We implement appropriate security measures to protect your personal information:
                            • Encryption of sensitive data
                            • Secure data storage
                            • Regular security audits
                            • Access controls
                            """
                        )
                        
                        policySection(
                            title: "Your Rights",
                            content: """
                            You have the right to:
                            • Access your personal data
                            • Request data deletion
                            • Opt-out of communications
                            • Update your information
                            """
                        )
                    }
                    
                    Group {
                        policySection(
                            title: "Data Retention",
                            content: """
                            We retain your information for as long as:
                            • Your account is active
                            • Needed to provide services
                            • Required by law
                            """
                        )
                        
                        policySection(
                            title: "Contact Us",
                            content: """
                            For privacy-related questions:
                            Email: privacy@interviewcopilot.com
                            Address: 123 Tech Street, San Francisco, CA 94105
                            """
                        )
                    }
                }
                .padding()
            }
            .navigationTitle("Privacy Policy")
            .navigationBarItems(trailing: Button("Done") { dismiss() })
        }
    }
    
    private func policySection(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3.bold())
            
            Text(content)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
} 