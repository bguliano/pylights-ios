//
//  ContentViewModel.swift
//  pylights-ios
//
//  Created by Braden Guliano on 12/13/24.
//

import Foundation

class PylightsViewModel: ObservableObject {
    @Published var currentlyPlaying: Bool = false
    @Published var volume: Double = 50.0
    
    @Published var songs: [SongDescriptor] = []
    @Published var lights: [LightDescriptor] = []
    @Published var presets: [PresetDescriptor] = []
    
    @Published var currentSong: SongDescriptor?
    
    private let api = try! PylightsAPIClient(baseURL: "http://127.0.0.1:5000")
    
    init() {
        api.info(completion: updateDescriptors)
    }
    
    private func updateDescriptors<T: PylightsAPIDescriptor>(_ completion: Result<T, Error>) {
        switch completion {
        case .success(let descriptor):
            func updateSongs(_ songsDescriptor: SongsDescriptor) {
                songs = songsDescriptor.songs
                currentSong = songsDescriptor.playing
            }

            func updateLights(_ lightsDescriptor: LightsDescriptor) {
                lights = lightsDescriptor.lights
            }

            func updatePresets(_ presetsDescriptor: PresetsDescriptor) {
                presets = presetsDescriptor.presets
            }

            DispatchQueue.main.async {
                if let infoDescriptor = descriptor as? InfoDescriptor {
                    updateSongs(infoDescriptor.songs)
                    updateLights(infoDescriptor.lights)
                    updatePresets(infoDescriptor.presets)
                } else if let songsDescriptor = descriptor as? SongsDescriptor {
                    updateSongs(songsDescriptor)
                } else if let lightsDescriptor = descriptor as? LightsDescriptor {
                    updateLights(lightsDescriptor)
                } else if let presetsDescriptor = descriptor as? PresetsDescriptor {
                    updatePresets(presetsDescriptor)
                }
            }
            
        case .failure(let error):
            print("Error updating descriptors: \(error.localizedDescription)")
        }
    }
    
    // publically exposed api endpoints
    
    func playSong(_ name: String) {
        api.songs.play(name: name, completion: updateDescriptors)
    }
    
    func toggleLight(_ name: String) {
        api.lights.toggle(name: name, completion: updateDescriptors)
    }
    
    func allOn() {
        api.lights.allOn(completion: updateDescriptors)
    }
    
    func allOff() {
        api.lights.allOff(completion: updateDescriptors)
    }
    
    func activatePreset(_ name: String) {
        api.presets.activate(name: name, completion: updateDescriptors)
    }
}
