//
//  SettingsView.swift
//  SoundWeaverTablet
//
//  Created by Jeremy Huang on 7/24/24.
//

import SwiftUI

struct SettingsView: View {
    
    @Binding var isPresented: Bool
    @Binding var classificationConfig: AudioClassificationConfiguration
    @State var classificationState: AudioClassificationState
    
    @Binding var homeSounds: Set<SoundIdentifier>
    @Binding var workSounds: Set<SoundIdentifier>
    @Binding var mtgSounds: Set<SoundIdentifier>
    
    @Binding var isSensing: Bool
    
    var body: some View {
//        Text("\(homeSounds)")
        NavigationStack {
            List {
                Section(header: Text("Contexts")) {
                    NavigationLink(destination: ContextConfiguration(
                        targetContext: "Home",
                        querySoundOptions: {return try AudioClassificationConfiguration.listAllValidSoundIdentifiers()},
                        selectedSounds: $homeSounds,
                        doneAction: {
                            isPresented = false
                            AudioClassifier.singleton.stopSoundClassification()
                            stopTranscribing()
                            isSensing = false
                        })
                    ) {
                        Label("Home", systemImage: "house.fill")
                    }
                    
                    NavigationLink(destination: ContextConfiguration(
                        targetContext: "Work",
                        querySoundOptions: {return try AudioClassificationConfiguration.listAllValidSoundIdentifiers()},
                        selectedSounds: $workSounds,
                        doneAction: {
                            isPresented = false
                            AudioClassifier.singleton.stopSoundClassification()
                            stopTranscribing()
                            isSensing = false
                        })
                    ) {
                        Label("At Work", systemImage: "stethoscope")
                    }
                    
                    NavigationLink(destination: ContextConfiguration(
                        targetContext: "Magic: The Gathering",
                        querySoundOptions: {return try AudioClassificationConfiguration.listAllValidSoundIdentifiers()},
                        selectedSounds: $mtgSounds,
                        doneAction: {
                            isPresented = false
                            AudioClassifier.singleton.stopSoundClassification()
                            stopTranscribing()
                            isSensing = false
                        })
                    ) {
                        Label("Magic: The Gathering", systemImage: "gamecontroller.fill")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
    
    private func stopTranscribing() {
        SpeechRecognizer.shared.stopTranscribing()
    }
}

//#Preview {
//    SettingsView()
//}
