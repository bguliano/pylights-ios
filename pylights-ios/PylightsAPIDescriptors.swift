//
//  SongDescriptor.swift
//  pylights-ios
//
//  Created by Braden Guliano on 12/13/24.
//

import Foundation

protocol PylightsAPIDescriptor: Codable, Equatable {}

struct SongDescriptor: PylightsAPIDescriptor {
    let title: String
    let artist: String
    let albumArt: String
    let lengthMs: Double
}

struct SongsDescriptor: PylightsAPIDescriptor {
    let songs: [SongDescriptor]
    let playing: SongDescriptor?
    let paused: Bool
    let currentTimeMs: Double
    let volume: Int
}

struct LightDescriptor: PylightsAPIDescriptor {
    let name: String
    let gpio: Int
    let value: Bool
}

struct LightsDescriptor: PylightsAPIDescriptor {
    let lights: [LightDescriptor]
}

struct PresetDescriptor: PylightsAPIDescriptor {
    let name: String
    let lights: [String]
}

struct PresetsDescriptor: PylightsAPIDescriptor {
    let presets: [PresetDescriptor]
}

struct RemapDescriptor: PylightsAPIDescriptor {
    let remaining: [String]?
}

struct DeveloperDescriptor: PylightsAPIDescriptor {
    let version: String
    let ipAddress: String
    let cpuUsage: Double
    let ledServerIpAddress: String
    let ledServerStatus: Bool
}

struct InfoDescriptor: PylightsAPIDescriptor {
    let songs: SongsDescriptor
    let lights: LightsDescriptor
    let presets: PresetsDescriptor
}
