//
//  CurrentlyPlayingView.swift
//  pylights-ios
//
//  Created by Braden Guliano on 12/13/24.
//

import SwiftUI

struct CurrentlyPlayingView: View {
    @ObservedObject var pylightsViewModel: PylightsViewModel
    
    var body: some View {
        VStack {
            HStack(spacing: 15) {
                AlbumArtView(albumArtBase64: pylightsViewModel.currentSong?.albumArt ?? "")
                
                VStack(alignment: .leading) {
                    Text(pylightsViewModel.currentSong?.title ?? "Not playing")
                        .bold()
                        .lineLimit(1)
                        .truncationMode(.tail)
                    if pylightsViewModel.currentSong != nil {
                        Text("\(pylightsViewModel.currentMs.toMinutesAndSecondsString())/\(pylightsViewModel.totalMS.toMinutesAndSecondsString())")
                            .font(.caption)
                    }
                }
                
                Spacer()
                
                HStack(spacing: 15) {
                    Button {
                        if pylightsViewModel.isPaused {
                            pylightsViewModel.resumeSong()
                        } else {
                            pylightsViewModel.pauseSong()
                        }
                    } label: {
                        Image(systemName: pylightsViewModel.isPaused ? "play.fill" : "pause.fill")
                            .font(.system(size: 24))
                    }
                    
                    Button {
                        pylightsViewModel.stopSong()
                    } label: {
                        Image(systemName: "stop.fill")
                            .font(.system(size: 24))
                    }
                }
                .disabled(pylightsViewModel.currentSong == nil)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Slider(value: Binding(
                get: { Double(pylightsViewModel.volume) },
                set: { pylightsViewModel.volume = Int($0) }
            ), in: 0...100) { isEditing in
                if !isEditing { pylightsViewModel.setVolume() }
            }
        }
        .frame(height: 100)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.thinMaterial)
        )
    }
}

#Preview {
    CurrentlyPlayingView(pylightsViewModel: PylightsViewModel())
}
