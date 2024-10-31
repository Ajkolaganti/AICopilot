import SwiftUI
import Speech

struct TgeSpeechToTextView: View {
    @StateObject private var speechRecognizer = SpeechRecognizer()
    @State private var transcribedText = ""
    @State private var isRecording = false
    @State private var isProcessing = false
    @Environment(\.colorScheme) var colorScheme
    
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
                
                VStack(spacing: 24) {
                    // Visualization Card
                    VStack {
                        HStack {
                            Image(systemName: "waveform")
                                .font(.title2)
                                .foregroundStyle(accentGradient)
                            Text("Audio Visualization")
                                .font(.title2.bold())
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        AudioVisualizerView(isRecording: isRecording)
                            .frame(height: 100)
                            .padding()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(.ultraThinMaterial)
                    )
                    
                    // Transcript Card
                    VStack {
                        HStack {
                            Image(systemName: "text.quote")
                                .font(.title2)
                                .foregroundStyle(accentGradient)
                            Text("Live Transcript")
                                .font(.title2.bold())
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        if transcribedText.isEmpty && !isRecording {
                            VStack(spacing: 16) {
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
                            .fill(.ultraThinMaterial)
                    )
                    
                    // Action Button
                    Button(action: toggleRecording) {
                        HStack(spacing: 16) {
                            Image(systemName: isRecording ? "stop.circle.fill" : "mic.circle.fill")
                                .font(.system(size: 24))
                            Text(isRecording ? "Stop Recording" : "Start Recording")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(isRecording ? AnyShapeStyle(Color.red) : AnyShapeStyle(
                                    LinearGradient(
                                        colors: [.blue, .purple, .pink],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                ))
                        )
                        .foregroundColor(.white)
                        .shadow(color: isRecording ? Color.red.opacity(0.3) : Color.blue.opacity(0.3), 
                               radius: 5, x: 0, y: 3)
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
            .navigationTitle("Speech to Text")
        }
    }
    
    private func toggleRecording() {
        if isRecording {
            speechRecognizer.stopRecording()
            isRecording = false
        } else {
            speechRecognizer.startRecording { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let text):
                        transcribedText = text
                    case .failure(let error):
                        print("Recognition error: \(error)")
                    }
                }
            }
            isRecording = true
        }
    }
}

// Audio Visualizer View
struct AudioVisualizerView: View {
    let isRecording: Bool
    @State private var amplitude: CGFloat = 0
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<30) { index in
                RoundedRectangle(cornerRadius: 2)
                    .fill(LinearGradient(
                        colors: [.blue, .purple, .pink],
                        startPoint: .bottom,
                        endPoint: .top
                    ))
                    .frame(width: 4)
                    .frame(height: isRecording ? randomHeight() : 10)
                    .animation(
                        .easeInOut(duration: 0.2)
                        .repeatForever()
                        .delay(Double(index) * 0.05),
                        value: amplitude
                    )
            }
        }
        .onAppear {
            if isRecording {
                withAnimation(.linear(duration: 0.5).repeatForever()) {
                    amplitude = 1
                }
            }
        }
    }
    
    private func randomHeight() -> CGFloat {
        return CGFloat.random(in: 10...100)
    }
} 
