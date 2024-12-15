//
//  Double-toMinutesAndSecondsString.swift
//  pylights-ios
//
//  Created by Braden Guliano on 12/15/24.
//

import Foundation

extension Double {
    /// Converts a Double representing milliseconds into a string in "minutes:seconds" format.
    func toMinutesAndSecondsString() -> String {
        // Convert milliseconds to total seconds
        let totalSeconds = Int(self / 1000)
        
        // Calculate minutes and seconds
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        
        // Format and return the string
        return String(format: "%d:%02d", minutes, seconds)
    }
}
