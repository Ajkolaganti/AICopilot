import SwiftUI

struct TermsOfServiceView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Group {
                        termsSection(
                            title: "1. Acceptance of Terms",
                            content: """
                            By accessing or using Interview Copilot, you agree to be bound by these Terms of Service and all applicable laws and regulations.
                            """
                        )
                        
                        termsSection(
                            title: "2. User Accounts",
                            content: """
                            • You must maintain accurate account information
                            • You are responsible for maintaining account security
                            • Accounts are for individual use only
                            • You must be 13 years or older to use the service
                            """
                        )
                        
                        termsSection(
                            title: "3. Subscription Services",
                            content: """
                            • Subscription fees are billed in advance
                            • Free trial terms and conditions apply
                            • Cancellation policy and refund terms
                            • Automatic renewal terms
                            """
                        )
                        
                        termsSection(
                            title: "4. Intellectual Property",
                            content: """
                            • All content and materials are owned by Interview Copilot
                            • Limited license for personal use
                            • Restrictions on content usage and distribution
                            • User-generated content terms
                            """
                        )
                    }
                    
                    Group {
                        termsSection(
                            title: "5. Prohibited Activities",
                            content: """
                            Users may not:
                            �� Violate any laws or regulations
                            • Share account credentials
                            • Reverse engineer the service
                            • Use the service for unauthorized purposes
                            """
                        )
                        
                        termsSection(
                            title: "6. Termination",
                            content: """
                            We reserve the right to:
                            • Suspend or terminate accounts
                            • Modify or discontinue services
                            • Remove content without notice
                            """
                        )
                        
                        termsSection(
                            title: "7. Disclaimer",
                            content: """
                            • Service provided "as is"
                            • No guarantees of uninterrupted service
                            • Not responsible for third-party content
                            """
                        )
                        
                        termsSection(
                            title: "8. Contact Information",
                            content: """
                            For legal inquiries:
                            Email: legal@interviewcopilot.com
                            Address: 123 Tech Street, San Francisco, CA 94105
                            """
                        )
                    }
                }
                .padding()
            }
            .navigationTitle("Terms of Service")
            .navigationBarItems(trailing: Button("Done") { dismiss() })
        }
    }
    
    private func termsSection(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3.bold())
            
            Text(content)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
} 