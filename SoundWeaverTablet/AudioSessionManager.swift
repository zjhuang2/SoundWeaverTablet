//
//  A manager class for audio sessions.
//
//  Created by Jeremy Huang on 7/21/24.
//

import AVFoundation

class AudioSessionManager {
    static let shared = AudioSessionManager()
    private let audioSession = AVAudioSession.sharedInstance()

    private init() {
        configureAudioSession()
    }

    private func configureAudioSession() {
        do {
            try audioSession.setCategory(.record, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    
    private func stopAudioSession() {
        autoreleasepool {
            let audioSession = AVAudioSession.sharedInstance()
            try? audioSession.setActive(false)
        }
    }
}
