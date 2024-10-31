import Foundation

class AssemblyAIService {
    private let apiKey = "YOUR_ASSEMBLY_AI_API_KEY"
    private let baseURL = "https://api.assemblyai.com/v2"
    
    func transcribeAudio(fileURL: URL) async throws -> String {
        // First, upload the audio file
        let uploadURL = try await uploadAudio(fileURL: fileURL)
        
        // Then, submit transcription request
        let transcriptID = try await submitTranscriptionRequest(audioURL: uploadURL)
        
        // Finally, poll for results
        return try await pollForTranscriptionResults(transcriptID: transcriptID)
    }
    
    private func uploadAudio(fileURL: URL) async throws -> String {
        let uploadEndpoint = "\(baseURL)/upload"
        var request = URLRequest(url: URL(string: uploadEndpoint)!)
        request.httpMethod = "POST"
        request.setValue(apiKey, forHTTPHeaderField: "authorization")
        
        let audioData = try Data(contentsOf: fileURL)
        
        let (data, response) = try await URLSession.shared.upload(for: request, from: audioData)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NSError(domain: "AssemblyAI", code: -1, userInfo: [NSLocalizedDescriptionKey: "Upload failed"])
        }
        
        guard let uploadURL = String(data: data, encoding: .utf8) else {
            throw NSError(domain: "AssemblyAI", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid upload response"])
        }
        
        return uploadURL
    }
    
    private func submitTranscriptionRequest(audioURL: String) async throws -> String {
        let transcribeEndpoint = "\(baseURL)/transcript"
        var request = URLRequest(url: URL(string: transcribeEndpoint)!)
        request.httpMethod = "POST"
        request.setValue(apiKey, forHTTPHeaderField: "authorization")
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        
        let requestBody = ["audio_url": audioURL]
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NSError(domain: "AssemblyAI", code: -1, userInfo: [NSLocalizedDescriptionKey: "Transcription request failed"])
        }
        
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let transcriptID = json["id"] as? String else {
            throw NSError(domain: "AssemblyAI", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid transcription response"])
        }
        
        return transcriptID
    }
    
    private func pollForTranscriptionResults(transcriptID: String) async throws -> String {
        let pollingEndpoint = "\(baseURL)/transcript/\(transcriptID)"
        var request = URLRequest(url: URL(string: pollingEndpoint)!)
        request.setValue(apiKey, forHTTPHeaderField: "authorization")
        
        while true {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw NSError(domain: "AssemblyAI", code: -1, userInfo: [NSLocalizedDescriptionKey: "Polling failed"])
            }
            
            guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let status = json["status"] as? String else {
                throw NSError(domain: "AssemblyAI", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid polling response"])
            }
            
            if status == "completed" {
                guard let text = json["text"] as? String else {
                    throw NSError(domain: "AssemblyAI", code: -1, userInfo: [NSLocalizedDescriptionKey: "No transcription text found"])
                }
                return text
            } else if status == "error" {
                throw NSError(domain: "AssemblyAI", code: -1, userInfo: [NSLocalizedDescriptionKey: "Transcription failed"])
            }
            
            // Wait for 2 seconds before polling again
            try await Task.sleep(nanoseconds: 2_000_000_000)
        }
    }
} 