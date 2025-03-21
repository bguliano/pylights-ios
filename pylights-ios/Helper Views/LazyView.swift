//
//  LazyView.swift
//  pylights-ios
//
//  Created by Braden Guliano on 12/15/24.
//

import SwiftUI

struct LazyView<Content: View>: View {
    let build: () -> Content
    
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    
    var body: Content {
        build()
    }
}
