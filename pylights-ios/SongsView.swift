//
//  SongsView.swift
//  pylights-ios
//
//  Created by Braden Guliano on 12/13/24.
//

import SwiftUI

struct SongsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                HStack {
                    SongButton(songName: "Wizards in Winter", artistName: "The Orhcestra", albumArtName: nil)
                    SongButton(songName: "Wizards in Winter", artistName: "The Orhcestra", albumArtName: "wiw")
                }
                .padding(.horizontal)
                HStack {
                    SongButton(songName: "Wizards in Winter", artistName: "The Orhcestra", albumArtName: "wiw")
                    SongButton(songName: "Wizards in Winter", artistName: "The Orhcestra", albumArtName: nil)
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    SongsView()
}
