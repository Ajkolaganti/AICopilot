import Foundation
import SwiftUI

class UserManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var userStats: UserStats?
    
    static let shared = UserManager()
    private let userDefaults = UserDefaults.standard
    private let userKey = "currentUser"
    private let statsKey = "userStats"
    
    struct User: Codable {
        let id: String
        let email: String
        var subscriptionStatus: SubscriptionStatus
        var subscriptionExpiryDate: Date?
        let joinDate: Date
        
        init(id: String, email: String, subscriptionStatus: SubscriptionStatus, subscriptionExpiryDate: Date? = nil) {
            self.id = id
            self.email = email
            self.subscriptionStatus = subscriptionStatus
            self.subscriptionExpiryDate = subscriptionExpiryDate
            self.joinDate = Date()
        }
    }
    
    enum SubscriptionStatus: String, Codable {
        case none
        case trial
        case subscribed
    }
    
    private init() {
        loadUser()
        loadUserStats()
    }
    
    func loadUser() {
        if let userData = userDefaults.data(forKey: userKey),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            self.currentUser = user
            self.isAuthenticated = true
        }
    }
    
    func loadUserStats() {
        if let statsData = userDefaults.data(forKey: statsKey),
           let stats = try? JSONDecoder().decode(UserStats.self, from: statsData) {
            self.userStats = stats
        } else {
            self.userStats = UserStats.empty
        }
    }
    
    func saveUser(_ user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
            userDefaults.set(encoded, forKey: userKey)
            self.currentUser = user
            self.isAuthenticated = true
        }
    }
    
    func saveUserStats(_ stats: UserStats) {
        if let encoded = try? JSONEncoder().encode(stats) {
            userDefaults.set(encoded, forKey: statsKey)
            self.userStats = stats
        }
    }
    
    func updateInterviewStats(duration: TimeInterval, score: Int) {
        var stats = userStats ?? UserStats.empty
        stats.totalInterviews += 1
        stats.totalHours += duration / 3600 // Convert seconds to hours
        
        // Update average score
        let totalScore = (stats.averageScore * (stats.totalInterviews - 1) + score)
        stats.averageScore = totalScore / stats.totalInterviews
        
        saveUserStats(stats)
    }
    
    func signOut() {
        userDefaults.removeObject(forKey: userKey)
        userDefaults.removeObject(forKey: statsKey)
        self.currentUser = nil
        self.userStats = nil
        self.isAuthenticated = false
    }
    
    func restorePurchases() async {
        // Implement restore purchases using StoreKit
        await SubscriptionManager.shared.updateSubscriptionStatus()
    }
} 