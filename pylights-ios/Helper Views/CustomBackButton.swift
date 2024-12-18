//
//  CustomBackButton.swift
//  pylights-ios
//
//  Created by Braden Guliano on 12/18/24.
//

import SwiftUI

struct CustomBackButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "chevron.left")
                Text("Cancel")
            }
        }
    }
}
