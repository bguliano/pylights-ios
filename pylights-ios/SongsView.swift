//
//  SongsView.swift
//  pylights-ios
//
//  Created by Braden Guliano on 12/13/24.
//

import SwiftUI

struct SongsView: View {
    @ObservedObject var pylightsViewModel: PylightsViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                Color(UIColor.systemGroupedBackground) // Mimic standard light gray background
                    .ignoresSafeArea() // Extend the background to fill the entire screen

                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), alignment: .top), // Align grid items to the top
                        GridItem(.flexible(), alignment: .top)
                    ], spacing: 20) {
                        ForEach(pylightsViewModel.songs, id: \.title) { song in
                            VStack {
                                SongButton(
                                    songName: song.title,
                                    artistName: song.artist,
                                    albumArtBase64: song.albumArt
                                ) {
                                    pylightsViewModel.playSong(song.title)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .top) // Ensure each cell is aligned to the top
                        }
                    }
                    .padding()
                    .padding(.bottom, 150)
                }
            }
            .navigationTitle("Songs")
        }
    }
}

#Preview {
    SongsView(pylightsViewModel: PylightsViewModel())
}
