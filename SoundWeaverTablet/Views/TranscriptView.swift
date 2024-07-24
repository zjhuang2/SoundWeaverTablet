//
//  SocialView.swift
//  SoundWeaverTablet
//
//  Created by Jeremy Huang on 7/14/24.
//

import SwiftUI
import Speech

struct TranscriptView: View {
    var transcriptText: String
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                Text(transcriptText)
            }
            
        }
    }
}
