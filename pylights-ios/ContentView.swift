//
//  ContentView.swift
//  pylights-ios
//
//  Created by Braden Guliano on 12/12/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: ContentViewTab = .songs
    @ObservedObject var contentViewModel = ContentViewModel()
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                SongsView()
                    .tabItem {
                        Label("Songs", systemImage: "music.note")
                    }
                    .tag(ContentViewTab.songs)
                LightsView()
                    .tabItem {
                        Label("Lights", systemImage: "lightbulb")
                    }
                    .tag(ContentViewTab.lights)
                PresetsView()
                    .tabItem {
                        Label("Presets", systemImage: "rectangle.stack")
                    }
                    .tag(ContentViewTab.presets)
            }
            .overlay(
                VStack {
                    Spacer()
                    CurrentlyPlayingView(songName: nil, albumArtName: nil, volume: $contentViewModel.volume)
                        .padding(.horizontal)
                        .padding(.bottom, 65)
                }
                    .offset(y: selectedTab == .songs ? 0 : 400)
                    .scaleEffect(selectedTab == .songs ? 1 : 0.8)
                    .animation(.spring, value: selectedTab)
            )
            .navigationTitle(selectedTab.title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: DeveloperView()) {
                        Image(systemName: "wrench")
                    }
                }
            }
        }
    }
}

enum ContentViewTab {
    case songs
    case lights
    case presets
    
    var title: String {
        switch self {
        case .songs: return "Songs"
        case .lights: return "Lights"
        case .presets: return "Presets"
        }
    }
}

#Preview {
    ContentView()
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
