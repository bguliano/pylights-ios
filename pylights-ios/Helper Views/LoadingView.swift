//
//  LoadingView.swift
//  pylights-ios
//
//  Created by Braden Guliano on 12/15/24.
//

import SwiftUI

struct LoadingView: View {
    let condition: Bool
    
    var body: some View {
        VStack {
            if condition {
                ZStack {
                    Color(uiColor: .systemBackground).opacity(0.6)
                        .ignoresSafeArea()
                    ProgressView()
                        .controlSize(.large)
                }
            }
        }
        .animation(.easeInOut(duration: 0.2), value: condition)
    }
}

#Preview {
    LoadingView(condition: true)
}
