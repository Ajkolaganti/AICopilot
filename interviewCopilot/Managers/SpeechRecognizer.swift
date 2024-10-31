import Foundation
import Speech

class SpeechRecognizer: ObservableObject {
    private var audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    
    init() {
        requestAuthorization()
    }
    
    private func requestAuthorization() {
        SFSpeechRecognizer.requestAuthorization { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    break
                case .denied:
                    print("Speech recognition authorization denied")
                case .restricted:
                    print("Speech recognition not available on this device")
                case .notDetermined:
                    print("Speech recognition not yet authorized")
                @unknown default:
                    print("Unknown authorization status")
                }
            }
        }
    }
    
    func startRecording(completion: @escaping (Result<String, Error>) -> Void) {
        // Cancel any existing recognition task
        recognitionTask?.cancel()
        recognitionTask = nil
        
        // Configure audio session
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            completion(.failure(error))
            return
        }
        
        // Create and configure the speech recognition request
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
            return
        }
        recognitionRequest.shouldReportPartialResults = true
        
        // Create a recognition task
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let result = result {
                completion(.success(result.bestTranscription.formattedString))
            }
        }
        
        // Configure the audio engine
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
        }
        
        // Start the audio engine
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            completion(.failure(error))
        }
    }
    
    func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionTask = nil
    }
} 