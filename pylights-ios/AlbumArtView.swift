//
//  SwiftUIView.swift
//  pylights-ios
//
//  Created by Braden Guliano on 12/13/24.
//

import SwiftUI

struct AlbumArtView: View {
    let albumArtName: String?
    
    var body: some View {
        VStack {
            if let albumArtName {
                Image(albumArtName)
                    .resizable()
                    .scaledToFit()
            } else {
                RoundedRectangle(cornerRadius: 15)
                    .strokeBorder(Color.primary, lineWidth: 1)
                    .overlay {
                        GeometryReader { geometry in
                            Image(systemName: "music.note")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width * 0.3, height: geometry.size.height * 0.3)
                                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        }
                    }
                    .aspectRatio(1.0, contentMode: .fit)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

#Preview {
    AlbumArtView(albumArtName: nil)
}
