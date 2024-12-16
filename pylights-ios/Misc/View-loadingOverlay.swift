//
//  View-loadingOverlay.swift
//  pylights-ios
//
//  Created by Braden Guliano on 12/15/24.
//

import SwiftUI

extension View {
    func loadingOverlay(isLoading: Bool) -> some View {
        ZStack {
            self
            LoadingView(condition: isLoading)
        }
    }
}
