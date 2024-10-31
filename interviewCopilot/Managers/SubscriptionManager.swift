import StoreKit
import SwiftUI

@MainActor
class SubscriptionManager: ObservableObject {
    static let shared = SubscriptionManager()
    
    @Published private(set) var subscriptions: [Product] = []
    @Published private(set) var purchasedSubscriptions: [Product] = []
    
    private let productIds = ["com.interviewcopilot.monthly", "com.interviewcopilot.yearly"]
    
    init() {
        Task {
            await loadProducts()
        }
    }
    
    func loadProducts() async {
        do {
            subscriptions = try await Product.products(for: productIds)
        } catch {
            print("Failed to load products:", error)
        }
    }
    
    func purchase(_ product: Product) async throws -> StoreKit.Transaction? {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await transaction.finish()
            await updateSubscriptionStatus()
            return transaction
            
        case .userCancelled:
            return nil
            
        case .pending:
            return nil
            
        @unknown default:
            return nil
        }
    }
    
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
    
    func updateSubscriptionStatus() async {
        for await result in StoreKit.Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                
                if let subscription = subscriptions.first(where: { $0.id == transaction.productID }) {
                    purchasedSubscriptions.append(subscription)
                    
                    // Update user subscription status
                    if let user = UserManager.shared.currentUser {
                        var updatedUser = user
                        updatedUser.subscriptionStatus = .subscribed
                        updatedUser.subscriptionExpiryDate = transaction.expirationDate
                        UserManager.shared.saveUser(updatedUser)
                    }
                }
            } catch {
                print("Failed to verify transaction:", error)
            }
        }
    }
}

enum StoreError: Error {
    case failedVerification
} 