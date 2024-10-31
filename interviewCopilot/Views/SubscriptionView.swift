import SwiftUI
import StoreKit

struct SubscriptionView: View {
    @State private var selectedPlan: SubscriptionPlan?
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var subscriptionManager = SubscriptionManager.shared
    @State private var isProcessing = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    private let accentGradient = LinearGradient(
        colors: [.blue, .purple, .pink],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - Subscription Plan
extension SubscriptionView {
    enum SubscriptionPlan: String, CaseIterable {
        case monthly = "Monthly"
        case yearly = "Yearly"
        
        var price: String {
            switch self {
            case .monthly: return "$9.99/month"
            case .yearly: return "$99.99/year"
            }
        }
        
        var savings: String? {
            switch self {
            case .yearly: return "Save 17%"
            default: return nil
            }
        }
        
        var features: [String] {
            [
                "Unlimited AI Interview Sessions",
                "Real-time Feedback & Analysis",
                "Performance Analytics Dashboard",
                "Interview Recording & Playback",
                "Custom Interview Questions",
                "Export Interview Reports"
            ]
        }
    }
}

// MARK: - Main View
extension SubscriptionView {
    var body: some View {
        NavigationView {
            ZStack {
                backgroundView
                ScrollView {
                    VStack(spacing: 32) {
                        headerView
                        subscriptionPlansView
                        featuresListView
                        actionButton
                        termsView
                    }
                }
            }
            .navigationBarItems(trailing: skipButton)
        }
    }
    
    private var backgroundView: some View {
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
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            Text("Unlock Premium Features")
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(accentGradient)
                .multilineTextAlignment(.center)
            
            Text("Start with a 3-day free trial")
                .font(.title3)
                .foregroundColor(.secondary)
        }
        .padding(.top, 40)
    }
    
    private var subscriptionPlansView: some View {
        VStack(spacing: 16) {
            ForEach(SubscriptionPlan.allCases, id: \.self) { plan in
                PlanCard(
                    plan: plan,
                    isSelected: selectedPlan == plan,
                    accentGradient: accentGradient
                ) {
                    withAnimation(.spring(duration: 0.3)) {
                        selectedPlan = plan
                    }
                }
            }
        }
        .padding(.horizontal)
    }
    
    private var featuresListView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Premium Features")
                .font(.title3.bold())
                .padding(.bottom, 5)
            
            ForEach(SubscriptionPlan.allCases.first?.features ?? [], id: \.self) { feature in
                HStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(accentGradient)
                    Text(feature)
                        .font(.subheadline)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
        .padding(.horizontal)
    }
    
    private var actionButton: some View {
        Button(action: handleSubscription) {
            Group {
                if isProcessing {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Start Free Trial")
                }
            }
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(accentGradient)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 3)
        }
        .disabled(isProcessing)
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .padding(.horizontal)
    }
    
    private var termsView: some View {
        VStack(spacing: 8) {
            Text("Cancel anytime during trial")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("Subscription auto-renews after trial")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.bottom)
    }
    
    private var skipButton: some View {
        Button("Skip") {
            dismiss()
        }
    }
    
    private func handleSubscription() {
        guard let plan = selectedPlan else {
            errorMessage = "Please select a plan"
            showError = true
            return
        }
        
        Task {
            isProcessing = true
            do {
                if let product = subscriptionManager.subscriptions.first(where: { $0.id.contains(plan.rawValue.lowercased()) }) {
                    if let transaction = try await subscriptionManager.purchase(product) {
                        dismiss()
                    }
                }
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
            isProcessing = false
        }
    }
}

// MARK: - Plan Card View
struct PlanCard: View {
    let plan: SubscriptionView.SubscriptionPlan
    let isSelected: Bool
    let accentGradient: LinearGradient
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                if let savings = plan.savings {
                    Text(savings)
                        .font(.caption.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(accentGradient)
                        .clipShape(Capsule())
                }
                
                Text(plan.rawValue)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(plan.price)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(accentGradient)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        isSelected ? AnyShapeStyle(accentGradient) : AnyShapeStyle(Color.clear),
                        lineWidth: 2
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
} 
