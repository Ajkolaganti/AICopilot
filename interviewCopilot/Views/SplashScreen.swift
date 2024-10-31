import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false
    @State private var logoScale: CGFloat = 0.3
    @State private var opacity = 0.0
    
    private let accentGradient = LinearGradient(
        colors: [.blue, .purple, .pink],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    var body: some View {
        if isActive {
            AuthenticationView()
        } else {
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
                
                VStack(spacing: 24) {
                    // Logo
                    ZStack {
                        Circle()
                            .fill(accentGradient)
                            .frame(width: 120, height: 120)
                            .blur(radius: 20)
                        
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 60))
                            .foregroundColor(.white)
                    }
                    .scaleEffect(logoScale)
                    
                    VStack(spacing: 16) {
                        Text("Interview Copilot")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundStyle(accentGradient)
                        
                        Text("Your AI Interview Assistant")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    .opacity(opacity)
                }
            }
            .onAppear {
                withAnimation(.spring(duration: 1.0)) {
                    logoScale = 1.0
                }
                withAnimation(.easeIn(duration: 0.6).delay(0.4)) {
                    opacity = 1.0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        self.isActive = true
                    }
                }
            }
        }
    }
} 