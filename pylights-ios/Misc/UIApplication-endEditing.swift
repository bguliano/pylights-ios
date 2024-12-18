//
//  UIApplication-endEditing.swift
//  pylights-ios
//
//  Created by Braden Guliano on 12/18/24.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
