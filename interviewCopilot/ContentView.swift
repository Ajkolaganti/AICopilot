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
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MainView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            SpeechToTextView()
                .tabItem {
                    Image(systemName: "waveform")
                    Text("Speech")
                }
                .tag(1)
            
            AccountView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Account")
                }
                .tag(2)
        }
    }
}
