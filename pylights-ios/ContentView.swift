//
//  ContentView.swift
//  pylights-ios
//
//  Created by Braden Guliano on 12/12/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var pylightsViewModel: PylightsViewModel
    @State private var selectedTab: ContentViewTab = .songs
    @State private var isShowingVolume: Bool = false
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                SongsView(pylightsViewModel: pylightsViewModel, isShowingVolume: $isShowingVolume)
                    .tabItem {
                        Label("Songs", systemImage: "music.note")
                    }
                    .tag(ContentViewTab.songs)
                    .onAppear(perform: pylightsViewModel.reloadInfo)
                
                LightsView(pylightsViewModel: pylightsViewModel)
                    .tabItem {
                        Label("Lights", systemImage: "lightbulb")
                    }
                    .tag(ContentViewTab.lights)
                    .onAppear(perform: pylightsViewModel.reloadInfo)
                
                PresetsView(pylightsViewModel: pylightsViewModel)
                    .tabItem {
                        Label("Presets", systemImage: "rectangle.stack")
                    }
                    .tag(ContentViewTab.presets)
                    .onAppear(perform: pylightsViewModel.reloadInfo)
            }
            
            VStack {
                Spacer()
                CurrentlyPlayingView(pylightsViewModel: pylightsViewModel, isShowingVolume: $isShowingVolume)
                    .padding(.horizontal)
                    .padding(.bottom, 65)
            }
            .offset(y: selectedTab == .songs ? 0 : 400)
            .scaleEffect(selectedTab == .songs ? 1 : 0.8)
            .animation(.spring, value: selectedTab)
            
            LoadingView(condition: pylightsViewModel.isLoading)
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
    ContentView(pylightsViewModel: PylightsViewModel())
}

#Preview {
    ContentView(pylightsViewModel: PylightsViewModel())
        .preferredColorScheme(.dark)
}
