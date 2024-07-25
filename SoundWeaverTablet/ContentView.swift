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
    
    @State private var isSettingsPresented = false
    
    @State var isSensing = false
    @State var currentMode: String = "Awareness"
    
    var classificationState = AudioClassificationState()
    @State var classificationConfig = AudioClassificationConfiguration()
     
    @State var transcriptText: String = "Go ahead, I am listening."
    
    @State var contextDict: [String: Set<SoundIdentifier>] = [:]
    
    /// A collection of contexts with selected sounds.
    @State var homeSounds: Set<SoundIdentifier> = [SoundIdentifier(labelName: "door"), SoundIdentifier(labelName: "knock")]
    @State var workSounds: Set<SoundIdentifier> = [SoundIdentifier(labelName: "door"), SoundIdentifier(labelName: "knock")]
    @State var mtgSounds: Set<SoundIdentifier> = [SoundIdentifier(labelName: "door"), SoundIdentifier(labelName: "knock")]
    
    var body: some View {
//        VStack {
//            Text("\(homeSounds)")
//        }
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
                
                Button {
                    isSettingsPresented.toggle()
                } label: {
                    Image(systemName: "gearshape.fill").imageScale(.large)
                }
                .frame(width: 100)
            }

            TabView {
                AwarenessView(classificationState: classificationState,
                              classificationConfig: $classificationConfig,
                              homeSounds: homeSounds,
                              workSounds: workSounds,
                              mtgSounds: mtgSounds,
                              isSensing: $isSensing)
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
        .sheet(isPresented: $isSettingsPresented) {
            SettingsView(isPresented: $isSettingsPresented,
                         classificationConfig: $classificationConfig,
                         classificationState: classificationState,
                         homeSounds: $homeSounds,
                         workSounds: $workSounds,
                         mtgSounds: $mtgSounds,
                         isSensing: $isSensing)
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
