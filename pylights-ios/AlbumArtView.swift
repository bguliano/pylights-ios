//
//  SwiftUIView.swift
//  pylights-ios
//
//  Created by Braden Guliano on 12/13/24.
//

import SwiftUI

struct AlbumArtView: View {
    let albumArtBase64: String
    
    var body: some View {
        VStack {
            if let uiImage = decodeBase64ToUIImage(albumArtBase64) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            } else {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(UIColor.systemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .strokeBorder(Color.primary, lineWidth: 1) // Keep the border
                    )
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
    
    func decodeBase64ToUIImage(_ base64String: String) -> UIImage? {
        guard let imageData = Data(base64Encoded: base64String) else {
            return nil
        }
        return UIImage(data: imageData)
    }
}

#Preview {
    AlbumArtView(albumArtBase64: "")
}
