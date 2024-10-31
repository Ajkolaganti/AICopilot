import SwiftUI

struct InterviewModeCard: View {
    let mode: InterviewMode
    let description: String
    let icon: String
    let gradient: LinearGradient
    @Binding var selectedMode: InterviewMode?
    @Binding var showInterview: Bool
    
    var body: some View {
        Button(action: {
            selectedMode = mode
            showInterview = true
        }) {
            VStack(alignment: .leading, spacing: 12) {
                ZStack {
                    Circle()
                        .fill(gradient)
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(.white)
                }
                
                Text(mode.rawValue)
                    .font(.headline)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(width: 200)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
            )
        }
    }
} 