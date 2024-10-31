import SwiftUI
import AuthenticationServices

struct AuthenticationView: View {
    @State private var isSignIn = true
    @State private var email = ""
    @State private var password = ""
    @State private var showSubscription = false
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var userManager = UserManager.shared
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    
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
                    VStack(spacing: 32) {
                        // App Icon
                        ZStack {
                            Circle()
                                .fill(accentGradient)
                                .frame(width: 80, height: 80)
                                .blur(radius: 10)
                            
                            Image(systemName: "brain.head.profile")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                        }
                        .padding(.top, 40)
                        
                        // Auth Mode Selector
                        Picker("Mode", selection: $isSignIn) {
                            Text("Sign In").tag(true)
                            Text("Sign Up").tag(false)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)
                        
                        // Input Fields
                        VStack(spacing: 20) {
                            // Email Field
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(.secondary)
                                TextField("Email", text: $email)
                                    .textContentType(.emailAddress)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.ultraThinMaterial)
                            )
                            
                            // Password Field
                            HStack {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(.secondary)
                                SecureField("Password", text: $password)
                                    .textContentType(isSignIn ? .password : .newPassword)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.ultraThinMaterial)
                            )
                        }
                        .padding(.horizontal)
                        
                        // Primary Action Button
                        Button(action: {
                            handleAuthentication()
                        }) {
                            ZStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                                } else {
                                    Text(isSignIn ? "Sign In" : "Sign Up")
                                        .font(.headline)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .foregroundColor(Color.white)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(accentGradient)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 3)
                        }
                        .padding(.horizontal)
                        .disabled(isLoading)
                        
                        // Divider
                        HStack {
                            Rectangle()
                                .fill(Color.secondary.opacity(0.2))
                                .frame(height: 1)
                            Text("or")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Rectangle()
                                .fill(Color.secondary.opacity(0.2))
                                .frame(height: 1)
                        }
                        .padding(.horizontal)
                        
                        // Sign in with Apple
                        SignInWithAppleButton { request in
                            request.requestedScopes = [.email, .fullName]
                        } onCompletion: { result in
                            showSubscription = true
                        }
                        .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
                        .frame(height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .padding(.horizontal)
                    }
                }
            }
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $showSubscription) {
                SubscriptionView()
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func handleAuthentication() {
        guard !email.isEmpty && !password.isEmpty else {
            errorMessage = "Please fill in all fields"
            showError = true
            return
        }
        
        isLoading = true
        
        // Simulate authentication - Replace with your actual authentication logic
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let user = UserManager.User(
                id: UUID().uuidString,
                email: email,
                subscriptionStatus: .none,
                subscriptionExpiryDate: nil
            )
            
            UserManager.shared.saveUser(user)
            showSubscription = true
            isLoading = false
        }
    }
} 