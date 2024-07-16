//
//  AwarenessSoundDetectionView.swift
//  SoundWeaverTablet
//
//  Created by Jeremy Huang on 7/14/24.
//

import SwiftUI

struct AwarenessSoundDetectionView: View {
    
    /// The runtime state that contains information about the strength of the detected sounds.
    var modeState: AwarenessModeState
    
    /// The configuration that dictates the aspect of sound classification in Awareness Mode
    var modeConfig: AwarenessModeConfiguration
    
    
    // Display a grid of sound labels.
    static func displaySoundLabelsGrid(_ detections: [(SoundIdentifier, DetectionState)]) -> some View {
        return HStack {
            ForEach(detections, id: \.0.labelName) {
                if $1.isDetected == true {
                    generateSoundLabel(label: $0.displayName)
                }

            }
        }
    }
    
    /// Generate individual sound label.
    static func generateSoundLabel(label: String) -> some View {
        return VStack {
            Text("\(label)")
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                .padding()
                .frame(height: 50)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 3))
        }
    }
    
    var body: some View {
        VStack {
            Text("Detecting sounds").font(.title).padding()
            AwarenessSoundDetectionView.displaySoundLabelsGrid(modeState.detectionStates)
        }
//        .blur(radius: modeState.soundDetectionIsRunning ? 0.0 : 10.0)
//        .disabled(!modeState.soundDetectionIsRunning)
    }
}

//#Preview {
//    AwarenessSoundDetectionView()
//}
