//
//  SocialView.swift
//  SoundWeaverTablet
//
//  Created by Jeremy Huang on 7/14/24.
//

import SwiftUI
import Speech

struct SocialView: View {
    
    @State var isRecording = false
    @State var transcriptText: String = "Go ahead, I am listening."
    
    var body: some View {
        VStack {
            Text("Social Mode").font(.title).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            Divider()
            Button(action: {
                isRecording.toggle()
                if isRecording {
                    startTranscribing()
                } else {
                    stopTranscribing()
                }
            }) {
                Text(isRecording ? "Stop Transcribing" : "Start Transcribing")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Spacer()
            
            VStack {
                Text(transcriptText)
            }
            
        }
    }
    
    private func startTranscribing() {
        SpeechRecognizer.shared.startTranscribing { text in
            DispatchQueue.main.async {
                self.transcriptText = text
            }
        }
    }
    
    private func stopTranscribing() {
        SpeechRecognizer.shared.stopTranscribing()
    }
}

#Preview {
    SocialView()
}
