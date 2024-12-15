//
//  ContentViewModel.swift
//  pylights-ios
//
//  Created by Braden Guliano on 12/13/24.
//

import Foundation
import Combine

class PylightsViewModel: ObservableObject {
    @Published var volume: Int = 50
    
    @Published var songs: [SongDescriptor] = []
    @Published var lights: [LightDescriptor] = []
    @Published var presets: [PresetDescriptor] = []
    
    @Published var currentSong: SongDescriptor?
    @Published var isPaused: Bool = false
    @Published var currentMs: Double = 0
    @Published var totalMS: Double = 0
    
    @Published var isLoading: Bool = false
    
    private var msTimer: Timer?
    private var cancellables: Set<AnyCancellable> = []
    
    private let api = try! PylightsAPIClient(baseURL: "http://127.0.0.1:5000")
    
    init() {
        setupBindings()
        api.info(completion: updateDescriptors)
    }
    
    private func setupBindings() {
        api.$isLoading
            .receive(on: RunLoop.main)
            .sink { [weak self] newValue in
                self?.isLoading = newValue
            }
            .store(in: &cancellables)
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
    
    private func updateDescriptors<T: PylightsAPIDescriptor>(_ completion: Result<T, Error>) {
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
    
    func pauseSong() {
        api.songs.pause(completion: updateDescriptors)
    }
    
    func resumeSong() {
        api.songs.resume(completion: updateDescriptors)
    }
    
    func stopSong() {
        api.songs.stop(completion: updateDescriptors)
    }
    
    func setVolume() {
        api.songs.volume(value: volume, completion: updateDescriptors)
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
