import SwiftUI
import AVFoundation

struct SpeechToTextView: View {
    @StateObject private var audioRecorder = AudioRecorder()
    @State private var transcribedText: String = ""
    @State private var isRecording = false
    @State private var isProcessing = false
    @Environment(\.colorScheme) var colorScheme
    
    private let accentGradient = LinearGradient(
        colors: [.blue, .cyan],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Transcript Card
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "text.quote.fill")
                            .font(.title2)
                            .foregroundStyle(accentGradient)
                        Text("Live Transcript")
                            .font(.title2.bold())
                    }
                    
                    if transcribedText.isEmpty && !isProcessing {
                        VStack(spacing: 12) {
                            Image(systemName: "text.word.spacing")
                                .font(.system(size: 40))
                                .foregroundStyle(accentGradient)
                            Text("Start recording to see transcript")
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
                            Text(transcribedText)
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
                
                // Record Button
                Button(action: {
                    withAnimation {
                        if isRecording {
                            audioRecorder.stopRecording()
                            isRecording = false
                            isProcessing = false
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
                        isRecording ? "Stop Recording" : "Start Recording",
                        systemImage: isRecording ? "stop.circle.fill" : "mic.circle.fill"
                    )
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(isRecording ? AnyShapeStyle(Color.red) : AnyShapeStyle(accentGradient))
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .foregroundColor(.white)
                }
            }
            .padding()
        }
        .navigationTitle("Speech to Text")
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
} 
