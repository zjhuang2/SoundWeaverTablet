//
//  SetupMonitoredSoundsView.swift
//  SoundWeaverTablet
//
//  Created by Jeremy Huang on 7/24/24.
//

import SwiftUI

struct ContextConfiguration: View {
    
    /// A closure that queries the list of recognized sounds.
    ///
    /// The app uses the results of this closure to populate the `soundOptions` state variable. This
    /// closure may throw an error so the user can select an option to run it again.
    let querySoundOptions: () throws -> Set<SoundIdentifier>
    
    /// A message to display when `querySoundOptions` throws an error.
    @State var querySoundsErrorMessage: String?

    /// A list of possible sounds that a user selects in the app.
    @State var soundOptions: Set<SoundIdentifier>
    
    /// A search string the app uses to filter the available sound options. The app displays all the sound
    /// options when empty.
    @State var soundSearchString = ""
    
    /// A binding to the set of sounds the app monitors when starting sound classification.
    @Binding var selectedSounds: Set<SoundIdentifier>
    
    /// An action the app executes upon completing the setup.
    ///
    /// The app hides this view upon completion, so this action needs to perform any changes necessary to
    /// operate the app.
    var doneAction: () -> Void
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ContextConfiguration()
}
