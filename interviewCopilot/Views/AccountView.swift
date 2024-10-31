import SwiftUI

struct AccountView: View {
    @StateObject private var userManager = UserManager.shared
    @Environment(\.colorScheme) var colorScheme
    @State private var showSubscription = false
    @State private var showingPrivacyPolicy = false
    @State private var showingTerms = false
    @State private var showingHelp = false
    @State private var showingNotificationSettings = false
    @State private var showingInterviewHistory = false
    @State private var showingAnalytics = false
    @State private var showingSecuritySettings = false
    @State private var isRestoringPurchases = false
    
    private let accentGradient = LinearGradient(
        colors: [.blue, .purple, .pink],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    var body: some View {
        NavigationView {
            ZStack {
                // Dynamic background
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
                        // Profile Header
                        profileHeader
                        
                        // Stats Section
                        statsSection
                        
                        // Subscription Card
                        subscriptionCard
                        
                        // Settings Section
                        settingsSection
                        
                        // Account Actions
                        accountActions
                    }
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle("Account")
            .fullScreenCover(isPresented: $showSubscription) {
                SubscriptionView()
            }
            .sheet(isPresented: $showingNotificationSettings) {
                NotificationSettingsView()
            }
            .sheet(isPresented: $showingInterviewHistory) {
                InterviewHistoryView()
            }
            .sheet(isPresented: $showingAnalytics) {
                AnalyticsView()
            }
            .sheet(isPresented: $showingSecuritySettings) {
                SecuritySettingsView()
            }
            .sheet(isPresented: $showingHelp) {
                HelpSupportView()
            }
            .sheet(isPresented: $showingPrivacyPolicy) {
                PrivacyPolicyView()
            }
            .sheet(isPresented: $showingTerms) {
                TermsOfServiceView()
            }
        }
    }
    
    private var profileHeader: some View {
        VStack(spacing: 20) {
            // Profile Image
            ZStack {
                Circle()
                    .fill(accentGradient)
                    .frame(width: 100, height: 100)
                    .overlay(
                        Circle()
                            .stroke(.ultraThinMaterial, lineWidth: 2)
                    )
                    .shadow(color: Color.purple.opacity(0.3), radius: 10, x: 0, y: 5)
                
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 8) {
                Text(userManager.currentUser?.email ?? "")
                    .font(.title3.bold())
                    .foregroundColor(.primary)
                
                if let joinDate = userManager.currentUser?.joinDate {
                    Text("Member since \(joinDate.formatted(.dateTime.month().year()))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.top)
    }
    
    private var statsSection: some View {
        HStack(spacing: 20) {
            StatCard(
                title: "Interviews",
                value: "\(userManager.userStats?.totalInterviews ?? 0)",
                icon: "person.2.fill"
            )
            StatCard(
                title: "Hours",
                value: String(format: "%.1f", userManager.userStats?.totalHours ?? 0),
                icon: "clock.fill"
            )
            StatCard(
                title: "Score",
                value: "\(userManager.userStats?.averageScore ?? 0)%",
                icon: "chart.bar.fill"
            )
        }
        .padding(.horizontal)
    }
    
    private var subscriptionCard: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Subscription")
                        .font(.headline)
                    Text("Current Plan")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                subscriptionBadge
            }
            
            if userManager.currentUser?.subscriptionStatus == .subscribed {
                Divider()
                
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.secondary)
                    Text("Valid until: \(formattedExpiryDate)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
            
            if userManager.currentUser?.subscriptionStatus != .subscribed {
                Button(action: {
                    showSubscription = true
                }) {
                    Text("Upgrade to Premium")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(accentGradient)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 3)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(colorScheme == .dark ? 
                      Color(.systemGray6).opacity(0.8) : 
                      Color.white.opacity(0.8))
                .background(.ultraThinMaterial)
        )
        .padding(.horizontal)
    }
    
    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Settings")
                .font(.title3.bold())
                .padding(.horizontal)
            
            VStack(spacing: 8) {
                settingsButton(
                    title: "Notification Preferences",
                    icon: "bell.fill",
                    color: Color.red
                ) {
                    showingNotificationSettings = true
                }
                
                settingsButton(
                    title: "Interview History",
                    icon: "clock.arrow.circlepath",
                    color: Color.blue
                ) {
                    showingInterviewHistory = true
                }
                
                settingsButton(
                    title: "Performance Analytics",
                    icon: "chart.bar.xaxis",
                    color: Color.purple
                ) {
                    showingAnalytics = true
                }
                
                settingsButton(
                    title: "Account Security",
                    icon: "lock.shield.fill",
                    color: Color.green
                ) {
                    showingSecuritySettings = true
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var accountActions: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Account")
                .font(.title3.bold())
                .padding(.horizontal)
            
            VStack(spacing: 8) {
                accountActionButton(
                    title: isRestoringPurchases ? "Restoring..." : "Restore Purchases",
                    icon: "arrow.clockwise",
                    action: {
                        Task {
                            isRestoringPurchases = true
                            await userManager.restorePurchases()
                            isRestoringPurchases = false
                        }
                    }
                )
                
                accountActionButton(
                    title: "Help & Support",
                    icon: "questionmark.circle",
                    action: {
                        showingHelp = true
                    }
                )
                
                accountActionButton(
                    title: "Privacy Policy",
                    icon: "hand.raised.fill",
                    action: {
                        showingPrivacyPolicy = true
                    }
                )
                
                accountActionButton(
                    title: "Terms of Service",
                    icon: "doc.text",
                    action: {
                        showingTerms = true
                    }
                )
                
                accountActionButton(
                    title: "Sign Out",
                    icon: "rectangle.portrait.and.arrow.right",
                    isDestructive: true,
                    action: {
                        userManager.signOut()
                    }
                )
            }
            .padding(.horizontal)
        }
    }
    
    private func settingsButton(title: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(color)
                    )
                
                Text(title)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption.bold())
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(colorScheme == .dark ? 
                          Color(.systemGray6).opacity(0.8) : 
                          Color.white.opacity(0.8))
                    .background(.ultraThinMaterial)
            )
        }
    }
    
    private func accountActionButton(
        title: String,
        icon: String,
        isDestructive: Bool = false,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(isDestructive ? .red : .primary)
                    .frame(width: 32, height: 32)
                
                Text(title)
                    .foregroundColor(isDestructive ? .red : .primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption.bold())
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(colorScheme == .dark ? 
                          Color(.systemGray6).opacity(0.8) : 
                          Color.white.opacity(0.8))
                    .background(.ultraThinMaterial)
            )
        }
    }
    
    private var subscriptionBadge: some View {
        let status = userManager.currentUser?.subscriptionStatus ?? .none
        let backgroundColor: Color
        let textColor: Color = .white
        
        switch status {
        case .subscribed:
            backgroundColor = .green
        case .trial:
            backgroundColor = .orange
        case .none:
            backgroundColor = .gray
        }
        
        return Text(status.rawValue.capitalized)
            .font(.caption.bold())
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(backgroundColor)
            .foregroundColor(textColor)
            .clipShape(Capsule())
    }
    
    private var formattedExpiryDate: String {
        guard let date = userManager.currentUser?.subscriptionExpiryDate else {
            return "N/A"
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

// MARK: - Supporting Views
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.title2.bold())
                    .foregroundColor(.primary)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(colorScheme == .dark ? 
                      Color(.systemGray6).opacity(0.8) : 
                      Color.white.opacity(0.8))
                .background(.ultraThinMaterial)
        )
    }
} 