//
//  SongButton.swift
//  pylights-ios
//
//  Created by Braden Guliano on 12/12/24.
//

import SwiftUI

struct SongButton: View {
    let songDescriptor: SongDescriptor
    let action: () -> Void
    
    @State private var isPressed = false // State variable for the pulse effect
    
    var body: some View {
        VStack {
            AlbumArtView(albumArtBase64: songDescriptor.albumArt)
                .overlay(
                    Text(songDescriptor.lengthMs.toMinutesAndSecondsString())
                        .font(.caption)
                        .padding(5)
                        .background(Color(uiColor: .systemBackground).opacity(0.7))
                        .clipShape(Capsule())
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                        .padding(5)
                )
            
            Text(songDescriptor.title)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(songDescriptor.artist)
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .opacity(isPressed ? 0.8 : 1.0) // Apply the opacity pulse
        .onTapGesture(perform: onClick)
    }
    
    private func onClick() {
        let pulseDuration = 0.3
        withAnimation(.easeInOut(duration: pulseDuration / 2)) {
            isPressed = true // Start the pulse effect
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + pulseDuration / 2) {
            withAnimation(.easeInOut(duration: pulseDuration / 2)) {
                isPressed = false // Reset the pulse effect
            }
        }
        action() // Perform the button's action
    }
}

#Preview {
    VStack(spacing: 20) {
        HStack {
            SongButton(songDescriptor: .init(title: "Wizards in Winter", artist: "The Orchestra", albumArt: "", lengthMs: 154_000)) {}
            SongButton(songDescriptor: .init(title: "Wizards in Winter", artist: "The Orchestra", albumArt: "", lengthMs: 154_000)) {}
        }
        .padding(.horizontal)
        HStack {
            SongButton(songDescriptor: .init(title: "Wizards in Winter", artist: "The Orchestra", albumArt: "", lengthMs: 154_000)) {}
            SongButton(songDescriptor: .init(title: "Wizards in Winter", artist: "The Orchestra", albumArt: "", lengthMs: 154_000)) {}
        }
        .padding(.horizontal)
    }
}
