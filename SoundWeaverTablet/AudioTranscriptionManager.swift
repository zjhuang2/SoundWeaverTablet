//
//  AudioTranscriptionManager.swift
//  SoundWeaverTablet
//
//  Created by Jeremy Huang on 7/17/24.
//

import Foundation
import AVFoundation
import Speech

class AudioTranscriptionManager: NSObject, SFSpeechRecognizerDelegate, AVAudioRecorderDelegate {
    static let shared = AudioTranscriptionManager()
    
    private let audioEngine = AVAudioEngine()
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    func startTranscribing(completion: @escaping (String) -> Void) {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            switch authStatus {
            case .authorized:
                self.startRecording(completion: completion)
            case .denied, .restricted, .notDetermined:
                completion("Speech recognition authorization was denied.")
            @unknown default:
                fatalError()
            }
        }
    }
    
    private func startRecording(completion: @escaping (String) -> Void) {
            do {
                let audioSession = AVAudioSession.sharedInstance()
                try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
                try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
                let inputNode = audioEngine.inputNode
                
                request = SFSpeechAudioBufferRecognitionRequest()
                guard let recognitionRequest = request else {
                    fatalError("Unable to create recognition request.")
                }
                recognitionRequest.shouldReportPartialResults = true
                
                recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
                    if let result = result {
                        completion(result.bestTranscription.formattedString)
                    } else if let error = error {
                        completion("Recognition error: \(error.localizedDescription)")
                    }
                }
                
                let recordingFormat = inputNode.outputFormat(forBus: 0)
                inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
                    recognitionRequest.append(buffer)
                }
                
                audioEngine.prepare()
                try audioEngine.start()
            } catch {
                completion("Audio engine couldn't start: \(error.localizedDescription)")
            }
        }
        
        func stopTranscribing() {
            audioEngine.stop()
            request?.endAudio()
            recognitionTask?.cancel()
        }
}
