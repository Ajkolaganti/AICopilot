//
//  ContentView.swift
//  interviewCopilot
//
//  Created by ajay  kolaganti on 10/31/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedTab = 0
    private let accentGradient = LinearGradient(
        colors: [.blue, .purple, .pink],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Main Interview View
            MainView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            // Account View
            AccountView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Account")
                }
                .tag(1)
        }
    }
}

// Main Interview View
struct MainView: View {
    @State private var showNewInterview = false
    @State private var selectedMode: InterviewMode?
    
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
                        // New Interview Button
                        Button(action: { showNewInterview = true }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                                Text("New Interview")
                                    .font(.headline)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(accentGradient)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        
                        // Interview Modes Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Interview Modes")
                                .font(.title2.bold())
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    InterviewModeCard(
                                        mode: .technical,
                                        description: "Practice coding and system design interviews",
                                        icon: "laptopcomputer",
                                        gradient: LinearGradient(colors: [.blue, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing),
                                        selectedMode: $selectedMode,
                                        showInterview: $showNewInterview
                                    )
                                    
                                    InterviewModeCard(
                                        mode: .behavioral,
                                        description: "Master common behavioral questions",
                                        icon: "person.2.fill",
                                        gradient: LinearGradient(colors: [.purple, .pink], startPoint: .topLeading, endPoint: .bottomTrailing),
                                        selectedMode: $selectedMode,
                                        showInterview: $showNewInterview
                                    )
                                    
                                    InterviewModeCard(
                                        mode: .custom,
                                        description: "Create your own interview scenarios",
                                        icon: "slider.horizontal.3",
                                        gradient: LinearGradient(colors: [.orange, .red], startPoint: .topLeading, endPoint: .bottomTrailing),
                                        selectedMode: $selectedMode,
                                        showInterview: $showNewInterview
                                    )
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        // Recent Interviews Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Recent Interviews")
                                .font(.title2.bold())
                                .padding(.horizontal)
                            
                            if true { // Replace with actual condition for recent interviews
                                Text("No recent interviews")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            }
                        }
                        
                        // Practice Topics Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Practice Topics")
                                .font(.title2.bold())
                                .padding(.horizontal)
                            
                            VStack(spacing: 12) {
                                FeatureCard(
                                    title: "Data Structures",
                                    description: "Arrays, LinkedLists, Trees, and more",
                                    icon: "square.stack.3d.up.fill",
                                    gradient: LinearGradient(colors: [.blue, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                                
                                FeatureCard(
                                    title: "Algorithms",
                                    description: "Sorting, Searching, Dynamic Programming",
                                    icon: "function",
                                    gradient: LinearGradient(colors: [.purple, .pink], startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                                
                                FeatureCard(
                                    title: "System Design",
                                    description: "Scalability, Database Design, Architecture",
                                    icon: "network",
                                    gradient: LinearGradient(colors: [.orange, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom)
                }
            }
            .navigationTitle("Interview Copilot")
            .sheet(isPresented: $showNewInterview) {
                if let mode = selectedMode {
                    TechnicalCopilotView(interviewMode: mode)
                }
            }
        }
    }
}

// Interview Mode Card Component
//struct InterviewModeCard: View {
//    let mode: InterviewMode
//    let description: String
//    let icon: String
//    let gradient: LinearGradient
//    @Binding var selectedMode: InterviewMode?
//    @Binding var showInterview: Bool
//    
//    var body: some View {
//        Button(action: {
//            selectedMode = mode
//            showInterview = true
//        }) {
//            VStack(alignment: .leading, spacing: 12) {
//                ZStack {
//                    Circle()
//                        .fill(gradient)
//                        .frame(width: 56, height: 56)
//                    
//                    Image(systemName: icon)
//                        .font(.system(size: 24, weight: .medium))
//                        .foregroundColor(.white)
//                }
//                
//                Text(mode.rawValue)
//                    .font(.headline)
//                
//                Text(description)
//                    .font(.subheadline)
//                    .foregroundColor(.secondary)
//                    .lineLimit(2)
//                    .fixedSize(horizontal: false, vertical: true)
//            }
//            .frame(width: 200)
//            .padding()
//            .background(
//                RoundedRectangle(cornerRadius: 16)
//                    .fill(.ultraThinMaterial)
//            )
//        }
//    }
//}

// Feature Card Component
struct FeatureCard: View {
    let title: String
    let description: String
    let icon: String
    let gradient: LinearGradient
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 20) {
            // Icon
            ZStack {
                Circle()
                    .fill(gradient)
                    .frame(width: 56, height: 56)
                
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.white)
            }
            
            // Text Content
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
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
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// Technology Badge Component
struct TechnologyBadge: View {
    let text: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12))
            Text(text)
                .font(.caption.weight(.medium))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
        )
        .foregroundColor(.secondary)
    }
}

// Preview
#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
