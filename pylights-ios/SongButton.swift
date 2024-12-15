//
//  SongButton.swift
//  pylights-ios
//
//  Created by Braden Guliano on 12/12/24.
//

import SwiftUI

struct SongButton: View {
    let songName: String
    let artistName: String
    let albumArtBase64: String
    let action: () -> Void
    
    var body: some View {
        VStack {
            AlbumArtView(albumArtBase64: albumArtBase64)
            
            Text(songName)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(artistName)
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .onTapGesture(perform: action)
    }
}

#Preview {
    VStack(spacing: 20) {
        HStack {
            SongButton(songName: "Wizards in Winter", artistName: "The Orhcestra", albumArtBase64: "") {}
            SongButton(songName: "Wizards in Winter", artistName: "The Orhcestra", albumArtBase64: "") {}
        }
        .padding(.horizontal)
        HStack {
            SongButton(songName: "Wizards in Winter", artistName: "The Orhcestra", albumArtBase64: "") {}
            SongButton(songName: "Wizards in Winter", artistName: "The Orhcestra", albumArtBase64: "") {}
        }
        .padding(.horizontal)
    }
}
