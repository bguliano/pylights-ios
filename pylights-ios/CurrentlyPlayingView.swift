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
            HStack(spacing: 20) {
                AlbumArtView(albumArtBase64: pylightsViewModel.currentSong?.albumArt ?? "")
                
                Text(pylightsViewModel.currentSong?.title ?? "Not playing")
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
            
            Slider(value: $pylightsViewModel.volume, in: 0...100)
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
