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
    let albumArtName: String?
    
    var body: some View {
        VStack {
            AlbumArtView(albumArtName: albumArtName)
            
            Text(songName)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(artistName)
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        HStack {
            SongButton(songName: "Wizards in Winter", artistName: "The Orhcestra", albumArtName: nil)
            SongButton(songName: "Wizards in Winter", artistName: "The Orhcestra", albumArtName: "wiw")
        }
        .padding(.horizontal)
        HStack {
            SongButton(songName: "Wizards in Winter", artistName: "The Orhcestra", albumArtName: "wiw")
            SongButton(songName: "Wizards in Winter", artistName: "The Orhcestra", albumArtName: "wiw")
        }
        .padding(.horizontal)
    }
}
