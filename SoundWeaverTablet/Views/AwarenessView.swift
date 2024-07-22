//
//  AwarenessView.swift
//  SoundWeaverTablet
//
//  Created by Jeremy Huang on 7/14/24.
//

import SwiftUI
import Combine
import SoundAnalysis
import Firebase
import FirebaseCore
import FirebaseDatabase

@Observable class AwarenessModeState {
    /// A cancellable object for the lifetime of the sound classification.
    ///
    /// While the app retains this cancellable object, a sound classification task continues to run until it
    /// terminates due to an error.
    private var detectionCancellable: AnyCancellable? = nil
    
    // The config that governs sound classification
    private var modeConfig = AwarenessModeConfiguration()
    
    /// A list of mappings between sounds and current detection states.
    ///
    /// The app sorts this list to reflect the order in which the app displays them.
    var detectionStates: [(SoundIdentifier, DetectionState)] = []
    
    /// Indicates whether a sound classification is active.
    ///
    /// When `false,` the sound classification has ended for some reason. This could be due to an error
    /// emitted from Sound Analysis, or due to an interruption in the recorded audio. The app needs to prompt
    /// the user to restart classification when `false.`
    var soundDetectionIsRunning: Bool = false
    
    /// Begins detecting sounds according to the configuration you specify.
    ///
    /// If the sound classification is running when calling this method, it stops before starting again.
    ///
    /// - Parameter config: A configuration that provides information for performing sound detection.
    func restartDetection(config: AwarenessModeConfiguration) {
        AudioClassifier.singleton.stopSoundClassification()
        
        let classificationSubject = PassthroughSubject<SNClassificationResult, Error>()
        
        detectionCancellable = classificationSubject
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in self.soundDetectionIsRunning = false },
                  receiveValue: { self.detectionStates = AwarenessModeState.advanceDetectionStates(self.detectionStates, givenClassificationResult: $0)}
            )
        
        self.detectionStates = [SoundIdentifier](config.monitoredSounds)
            .sorted(by: { $0.displayName < $1.displayName })
            .map { ($0, DetectionState(presenceThreshold: 0.8,
                                       absenceThreshold: 0.3,
                                       presenceMeasurementsToStartDetection: 3,
                                       absenceMeasurementsToEndDetection: 10))
            }
        
        soundDetectionIsRunning = true
        modeConfig = config
        AudioClassifier.singleton.startSoundClassification(subject: classificationSubject,
                                                           inferenceWindowSize: config.inferenceWindowSize,
                                                           overlapFactor: config.overlapFactor)
    }
    
    /// Updates the detection states according to the latest classification result.
    ///
    /// - Parameters:
    ///   - oldStates: The previous detection states to update with a new observation from an ongoing
    ///   sound classification.
    ///   - result: The latest observation the app emits from an ongoing sound classification.
    ///
    /// - Returns: A new array of sounds with their updated detection states.
    static func advanceDetectionStates( _ oldStates: [(SoundIdentifier, DetectionState)],
                                        givenClassificationResult result: SNClassificationResult) -> [(SoundIdentifier, DetectionState)] {
        let confidenceLabel = { (sound: SoundIdentifier) -> Double in
            let confidence: Double
            let label = sound.labelName
            if let classification = result.classification(forIdentifier: label) {
                confidence = classification.confidence
            } else {
                confidence = 0
            }
            return confidence
        }
        return oldStates.map {(key, value) in
            (key, DetectionState(advancedFrom: value, currentConfidence: confidenceLabel(key)))
        }
    }
}

/// Contains customizable settings that control app behavior.
struct AwarenessModeConfiguration {
    /// Indicates the amount of audio, in seconds, that informs a prediction.
    var inferenceWindowSize = Double(1.5)

    /// The amount of overlap between consecutive analysis windows.
    ///
    /// The system performs sound classification on a window-by-window basis. The system divides an
    /// audio stream into windows, and assigns labels and confidence values. This value determines how
    /// much two consecutive windows overlap. For example, 0.9 means that each window shares 90% of
    /// the audio that the previous window uses.
    var overlapFactor = Double(0.9)

    /// A list of sounds to identify from system audio input.
    var monitoredSounds = try! listAllValidSoundIdentifiers()

    /// Retrieves a list of the sounds the system can identify.
    ///
    /// - Returns: A set of identifiable sounds, including the associated labels that sound
    ///   classification emits, and names suitable for displaying to the user.
    static func listAllValidSoundIdentifiers() throws -> Set<SoundIdentifier> {
        let labels = try AudioClassifier.getAllPossibleLabels()
        return Set<SoundIdentifier>(labels.map {
            SoundIdentifier(labelName: $0)
        })
    }
}

struct AwarenessView: View {
    
    @State var modeConfig = AwarenessModeConfiguration()
    var modeState = AwarenessModeState()
    
    func switchContext() {
        // Switch a context and change restart the sound classification with a new set of sounds to monitor
    }
    
    var body: some View {
        VStack {
            Text("Awareness Mode").font(.title).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            Button(action: {modeState.restartDetection(config: modeConfig)}) {
                Text(modeState.soundDetectionIsRunning ? "Stop Awareness Session" : "Start Awareness Session").font(.title3)
            }
            .frame(width: 300, height: 40)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            Divider()
            VStack {
                Text("Direction").font(.title)
                AwarenessDirectionView()
            }
            Spacer()
            AwarenessSoundDetectionView(modeState: modeState, modeConfig: modeConfig)
        }
    }
}

#Preview {
    AwarenessView()
}
