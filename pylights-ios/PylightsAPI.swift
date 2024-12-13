//
//  PylightsAPI.swift
//  pylights-ios
//
//  Created by Braden Guliano on 12/13/24.
//

import Foundation

enum PylightsAPIEndpoint {
    case songs
    case lights
    case presets
    case remap
    case developer
    
    var stringValue: String {
        switch self {
        case .songs: return "songs"
        case .lights: return "lights"
        case .presets: return "presets"
        case .remap: return "remap"
        case .developer: return "developer"
        }
    }
}

class PylightsAPI: APIClient {
    func getInfo(endpoint: PylightsAPIEndpoint) async -> [String: String]? {
        do {
            let data = try await self.get(endpoint: "\(endpoint.stringValue)/info")
            return try JSONDecoder().decode([String: String].self, from: data)
        } catch {
            print("Error getting info: \(error)")
            return nil
        }
    }
}
