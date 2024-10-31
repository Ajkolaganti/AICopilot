//
//  interviewCopilotApp.swift
//  interviewCopilot
//
//  Created by ajay  kolaganti on 10/31/24.
//

import SwiftUI

@main
struct interviewCopilotApp: App {
    @StateObject private var userManager = UserManager.shared
    @StateObject private var subscriptionManager = SubscriptionManager.shared
    
    var body: some Scene {
        WindowGroup {
            if userManager.isAuthenticated {
                if userManager.currentUser?.subscriptionStatus == .none {
                    SubscriptionView()
                } else {
                    ContentView()
                }
            } else {
                SplashScreen()
            }
        }
    }
}
