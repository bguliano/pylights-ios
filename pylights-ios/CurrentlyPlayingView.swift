//
//  CurrentlyPlayingView.swift
//  pylights-ios
//
//  Created by Braden Guliano on 12/13/24.
//

import SwiftUI

struct CurrentlyPlayingView: View {
    let songName: String?
    let albumArtName: String?
    @Binding var volume: Double
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                AlbumArtView(albumArtName: albumArtName)
                
                Text(songName ?? "Not playing")
                    .bold()
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "play.fill")
                        .font(.system(size: 24))
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "stop.fill")
                        .font(.system(size: 24))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Slider(value: $volume, in: 0...100)
        }
        .frame(height: 100)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.thinMaterial) // Replace with `.regularMaterial` or `.ultraThinMaterial` for different effects
        )
    }
}

#Preview {
    @Previewable @State var volume = 50.0

    CurrentlyPlayingView(songName: "Wizards in Winter", albumArtName: "wiw", volume: $volume)
}
