//
//  ContentView.swift
//  SoundWeaverTablet
//
//  Created by Jeremy Huang on 7/14/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            TabView {
                AwarenessView()
                    .tabItem {
                        Label("Awareness", systemImage: "eye")
                    }

                ActionView()
                    .tabItem {
                        Label("Action", systemImage: "bolt")
                    }

                SocialView()
                    .tabItem {
                        Label("Social", systemImage: "person.2")
                    }
            }
        }
        .padding()
        .onAppear {
            AudioSessionManager.shared
        }
    }
}

#Preview {
    ContentView()
}
