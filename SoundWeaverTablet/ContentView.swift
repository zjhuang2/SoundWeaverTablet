//
//  ContentView.swift
//  SoundWeaverTablet
//
//  Created by Jeremy Huang on 7/14/24.
//

import SwiftUI
import Combine
import SoundAnalysis

struct ContentView: View {
    
    @State var isSensing = false
    
    @State var currentMode: String = "Awareness"
    
    var classificationState = AudioClassificationState()
    @State var classificationConfig = AudioClassificationConfiguration()
    
    @State var transcriptText: String = "Go ahead, I am listening."
    
    var body: some View {
        VStack {
            HStack {
                Text("Current Mode: \(currentMode)")
                    .font(.title)
                    .bold()
                Spacer()
                Button(action: {
                    if !isSensing {
                        // Start audio classification and speech recognition
                        classificationState.restartDetection(config: classificationConfig)
                        startTranscribing()
                        isSensing.toggle()
                    } else {
                        // stop audio classification and speech recognition
                        AudioClassifier.singleton.stopSoundClassification()
                        stopTranscribing()
                        isSensing.toggle()
                    }
                }) {
                    Text(isSensing ? "Stop Sensing" : "Start Sensing")
                }
                .frame(width: 150, height: 40)
                .background(Color.blue)
                .foregroundColor(Color.white)
                .cornerRadius(10)
            }

            TabView {
                AwarenessView(classificationState: classificationState,
                              classificationConfig: classificationConfig)
                    .tabItem {
                        Label("Awareness", systemImage: "eye")
                    }
                    .onAppear {currentMode = "Awareness"}

                ActionView()
                    .tabItem {
                        Label("Action", systemImage: "bolt")
                    }
                    .onAppear {currentMode = "Action"}

                TranscriptView(transcriptText: transcriptText)
                    .tabItem {
                        Label("Social", systemImage: "person.2")
                    }
                    .onAppear {currentMode = "Social"}
            }
        }
        .padding()
        .onAppear {
            AudioSessionManager.shared
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
    ContentView()
}
