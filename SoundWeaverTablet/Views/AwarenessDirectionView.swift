//
//  AwarenessDirectionView.swift
//  SoundWeaverTablet
//
//  Created by Jeremy Huang on 7/16/24.
//

import SwiftUI
import FirebaseDatabase
import Firebase

struct AwarenessDirectionView: View {
    @State private var directionLabel: String = "NA"
    
    var databaseRef: DatabaseReference!
    
    var body: some View {
        VStack {
            if self.directionLabel != "NA" {
                Text(self.directionLabel)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue)
                        .shadow(color: .gray, radius: 10))
                    .foregroundColor(.white)
            }
        }
        .onAppear(perform: loadDirection)
    }
    
    func loadDirection() {
        let databaseRef = Database.database().reference().child("direction").child("direction")
        
        databaseRef.observe(DataEventType.value) { snapshot in
            if let value = snapshot.value as? String {
                switch value {
                case "Left Side":
                    self.directionLabel = "LeftSide"
                case "Right Side":
                    self.directionLabel = "RightSide"
                case "Front":
                    self.directionLabel = "Front"
                case "Back":
                    self.directionLabel = "Back"
                default:
                    self.directionLabel = "NA"
                }
            }
        }
    }
}

#Preview {
    AwarenessDirectionView()
}
