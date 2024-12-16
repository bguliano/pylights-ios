//
//  ContentViewModel.swift
//  pylights-ios
//
//  Created by Braden Guliano on 12/13/24.
//

import Foundation

class PylightsViewModel: ObservableObject {
    @Published var volume: Int = 50
    
    @Published var songs: [SongDescriptor] = []
    @Published var lights: [LightDescriptor] = []
    @Published var presets: [PresetDescriptor] = []
    
    @Published var currentSong: SongDescriptor?
    @Published var isPaused: Bool = false
    @Published var currentMs: Double = 0
    @Published var totalMS: Double = 0
    
    @Published var remapRemaining: [String]?
    
    @Published var developer: DeveloperDescriptor?
    
    @Published var isLoading: Bool = false
    
    private var msTimer: Timer?
    
    private let api = try! PylightsAPIClient(baseURL: "http://127.0.0.1:5000")
    
    init() {
        setupBindings()
        reloadInfo()
    }
    
    private func setupBindings() {
        api.$isLoading
            .debounce(for: .milliseconds(200), scheduler: RunLoop.main)
            .receive(on: RunLoop.main)
            .assign(to: &$isLoading)
    }
    
    private func startMsTimer() {
        stopMsTimer()
        msTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            if self?.isPaused == false { self?.currentMs += 1000 }
        }
        RunLoop.current.add(msTimer!, forMode: .common)
    }
    
    private func stopMsTimer() {
        msTimer?.invalidate()
        msTimer = nil
    }
    
    private func updateFromDescriptors<T: PylightsAPIDescriptor>(_ completion: Result<T, Error>) {
        switch completion {
        case .success(let descriptor):
            func updateSongs(_ songsDescriptor: SongsDescriptor) {
                songs = songsDescriptor.songs
                currentSong = songsDescriptor.playing
                isPaused = songsDescriptor.paused
                volume = songsDescriptor.volume
                currentMs = songsDescriptor.currentTimeMs
                totalMS = currentSong?.lengthMs ?? 0
                if currentSong == nil {
                    stopMsTimer()
                } else {
                    startMsTimer()
                }
            }
            
            func updateLights(_ lightsDescriptor: LightsDescriptor) {
                lights = lightsDescriptor.lights
            }
            
            func updatePresets(_ presetsDescriptor: PresetsDescriptor) {
                presets = presetsDescriptor.presets
            }
            
            DispatchQueue.main.async { [self] in
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
                } else if let remapDescriptor = descriptor as? RemapDescriptor {
                    remapRemaining = remapDescriptor.remaining
                } else if let developerDescriptor = descriptor as? DeveloperDescriptor {
                    developer = developerDescriptor
                }
            }
            
        case .failure(let error):
            print("Error updating descriptors: \(error.localizedDescription)")
        }
    }
    
    // publically exposed api endpoints
    
    func reloadInfo() {
        print("reloadInfo")
        api.info(completion: updateFromDescriptors)
    }
    
    func playSong(_ name: String) {
        api.songs.play(name: name, completion: updateFromDescriptors)
    }
    
    func pauseSong() {
        api.songs.pause(completion: updateFromDescriptors)
    }
    
    func resumeSong() {
        api.songs.resume(completion: updateFromDescriptors)
    }
    
    func stopSong() {
        api.songs.stop(completion: updateFromDescriptors)
    }
    
    func setVolume() {
        api.songs.volume(value: volume, completion: updateFromDescriptors)
    }
    
    func toggleLight(_ name: String) {
        api.lights.toggle(name: name, completion: updateFromDescriptors)
    }
    
    func allOn() {
        api.lights.allOn(completion: updateFromDescriptors)
    }
    
    func allOff() {
        api.lights.allOff(completion: updateFromDescriptors)
    }
    
    func activatePreset(_ name: String) {
        api.presets.activate(name: name, completion: updateFromDescriptors)
    }
    
    func startRemap() {
        api.remap.start(completion: updateFromDescriptors)
    }
    
    func nextRemap(name: String) {
        api.remap.next(name: name, completion: updateFromDescriptors)
    }
    
    func cancelRemap() {
        api.remap.cancel(completion: updateFromDescriptors)
    }
    
    func recompileShows() {
        api.developer.recompileShows(completion: updateFromDescriptors)
    }
    
    func developerInfo() {
        api.developer.info(completion: updateFromDescriptors)
    }
}
