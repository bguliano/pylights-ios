//
//  AppIconProvider.swift
//  pylights-ios
//
//  Created by Braden Guliano on 12/15/24.
//

import Foundation

enum AppIconProvider {
    static func appIconName() -> String? {
        guard
            let infoDict = Bundle.main.infoDictionary,
            let iconsDict = infoDict["CFBundleIcons"] as? [String: Any],
            let primaryIconDict = iconsDict["CFBundlePrimaryIcon"] as? [String: Any],
            let iconFiles = primaryIconDict["CFBundleIconFiles"] as? [String],
            let lastIcon = iconFiles.last
        else {
            return nil
        }
        return lastIcon
    }
}
