import SwiftUI
import LocalAuthentication

struct SecuritySettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("useBiometrics") private var useBiometrics = false
    @AppStorage("requirePasscode") private var requirePasscode = false
    @State private var showingPasscodeSheet = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Toggle("Use Face ID / Touch ID", isOn: $useBiometrics)
                    Toggle("Require Passcode", isOn: $requirePasscode)
                        .onChange(of: requirePasscode) { newValue in
                            if newValue {
                                showingPasscodeSheet = true
                            }
                        }
                } header: {
                    Text("Security Options")
                } footer: {
                    Text("Enable additional security measures to protect your data")
                }
                
                Section {
                    Button("Change Password") {
                        // Implement password change
                    }
                    
                    Button("Two-Factor Authentication") {
                        // Implement 2FA setup
                    }
                }
            }
            .navigationTitle("Security")
            .navigationBarItems(trailing: Button("Done") { dismiss() })
            .sheet(isPresented: $showingPasscodeSheet) {
                PasscodeSetupView()
            }
        }
    }
}

struct PasscodeSetupView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var passcode = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Enter a 6-digit passcode")
                    .font(.headline)
                
                SecureField("Passcode", text: $passcode)
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                    .multilineTextAlignment(.center)
                    .frame(width: 200)
                
                Button("Save") {
                    // Save passcode
                    dismiss()
                }
                .disabled(passcode.count != 6)
            }
            .navigationBarItems(trailing: Button("Cancel") { dismiss() })
        }
    }
} 