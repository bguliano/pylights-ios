//
//  ContentView.swift
//  pylights-ios
//
//  Created by Braden Guliano on 12/12/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: ContentViewTab = .songs
    @StateObject var pylightsViewModel = PylightsViewModel()
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                SongsView(pylightsViewModel: pylightsViewModel)
                    .tabItem {
                        Label("Songs", systemImage: "music.note")
                    }
                    .tag(ContentViewTab.songs)
                
                LightsView(pylightsViewModel: pylightsViewModel)
                    .tabItem {
                        Label("Lights", systemImage: "lightbulb")
                    }
                    .tag(ContentViewTab.lights)
                
                PresetsView(pylightsViewModel: pylightsViewModel)
                    .tabItem {
                        Label("Presets", systemImage: "rectangle.stack")
                    }
                    .tag(ContentViewTab.presets)
            }
            
            VStack {
                Spacer()
                CurrentlyPlayingView(pylightsViewModel: pylightsViewModel)
                    .padding(.horizontal)
                    .padding(.bottom, 65)
            }
            .offset(y: selectedTab == .songs ? 0 : 400)
            .scaleEffect(selectedTab == .songs ? 1 : 0.8)
            .animation(.spring, value: selectedTab)
            
            Rectangle()
                .fill(Color(uiColor: .systemBackground).opacity(0.6))
                .ignoresSafeArea()
                .overlay(
                    ProgressView()
                        .scaleEffect(3.0)
                )
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
