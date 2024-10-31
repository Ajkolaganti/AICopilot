// Rename the existing ContentView implementation to CopilotView
// and update the preview provider
import SwiftUI
import AVFoundation

struct TechnicalCopilotView: View {
    let interviewMode: InterviewMode
    @StateObject private var viewModel = CopilotViewModel()
    @StateObject private var audioRecorder = AudioRecorder()
    @State private var transcribedText: String = ""
    @State private var isRecording = false
    @State private var isProcessing = false
    @State private var aiResponse: String = ""
    @Environment(\.colorScheme) var colorScheme
    
    private let accentGradient = LinearGradient(
        colors: [.purple, .pink],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // AI Analysis Card
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "brain.head.profile")
                            .font(.title2)
                            .foregroundStyle(accentGradient)
                        Text("AI Analysis")
                            .font(.title2.bold())
                    }
                    
                    if aiResponse.isEmpty && !isProcessing {
                        VStack(spacing: 12) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 40))
                                .foregroundStyle(accentGradient)
                            Text("AI insights will appear here")
                                .multilineTextAlignment(.center)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if isProcessing {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.5)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ScrollView {
                            Text(aiResponse)
                                .padding()
                        }
                    }
                }
                .frame(maxHeight: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Material.regular)
                )
                
                // Transcript Card
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "text.quote")
                            .font(.title3)
                            .foregroundStyle(accentGradient)
                        Text("Live Transcript")
                            .font(.title3.bold())
                    }
                    
                    ScrollView {
                        Text(transcribedText.isEmpty ? "Start recording to see transcript" : transcribedText)
                            .foregroundColor(transcribedText.isEmpty ? .secondary : .primary)
                            .padding()
                    }
                }
                .frame(maxHeight: 200)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Material.regular)
                )
                
                // Action Buttons
                HStack(spacing: 16) {
                    // Record Button
                    Button(action: {
                        withAnimation {
                            if isRecording {
                                audioRecorder.stopRecording()
                                isRecording = false
                            } else {
                                do {
                                    try audioRecorder.startRecording()
                                    isRecording = true
                                    Task {
                                        await startContinuousTranscription()
                                    }
                                } catch {
                                    print("Failed to start recording: \(error)")
                                }
                            }
                        }
                    }) {
                        Label(
                            isRecording ? "Stop" : "Record",
                            systemImage: isRecording ? "stop.circle.fill" : "mic.circle.fill"
                        )
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(isRecording ? AnyShapeStyle(Color.red) : AnyShapeStyle(accentGradient))
                        )
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    
                    // Analyze Button
                    Button(action: {
                        Task {
                            await getAIResponse()
                        }
                    }) {
                        Label("Analyze", systemImage: "sparkles")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(transcribedText.isEmpty ? AnyShapeStyle(Color.gray.opacity(0.3)) : AnyShapeStyle(accentGradient))
                            )
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .disabled(transcribedText.isEmpty)
                }
            }
            .padding()
        }
        .navigationTitle("AI Copilot")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func startContinuousTranscription() async {
        while isRecording {
            guard let audioURL = audioRecorder.getRecordingURL() else { continue }
            
            do {
                let assemblyAI = AssemblyAIService()
                let newTranscript = try await assemblyAI.transcribeAudio(fileURL: audioURL)
                transcribedText = newTranscript
            } catch {
                print("Transcription failed: \(error)")
            }
            
            try? await Task.sleep(nanoseconds: 5_000_000_000)
        }
    }
    
    private func getAIResponse() async {
        isProcessing = true
        do {
            let openAI = OpenAIService()
            aiResponse = try await openAI.getResponse(for: transcribedText)
        } catch {
            print("AI Response failed: \(error)")
            aiResponse = "Failed to get AI response: \(error.localizedDescription)"
        }
        isProcessing = false
    }
}

class CopilotViewModel: ObservableObject {
    // ... existing code ...
    
    func setupInterview(with systemPrompt: String) {
        // Initialize OpenAI chat with the system prompt
        // This will set the context for the type of interview
        // Implement your OpenAI integration here
    }
}
