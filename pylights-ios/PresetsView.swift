//
//  PresetsView.swift
//  pylights-ios
//
//  Created by Braden Guliano on 12/13/24.
//

import SwiftUI

struct PresetsView: View {
    @ObservedObject var pylightsViewModel: PylightsViewModel

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(pylightsViewModel.presets, id: \.name) { preset in
                        Button(preset.name) {
                            pylightsViewModel.activatePreset(preset.name)
                        }
                        .foregroundStyle(.primary)
                    }
                } footer: {
                    Text("Click a preset above to apply it")
                }
                
                Section {
                    Button("Add Preset") {
                        
                    }
                } footer: {
                    Text("Or add a new one")
                }
            }
            .navigationTitle("Presets")
        }
    }
}

#Preview {
    PresetsView(pylightsViewModel: PylightsViewModel())
}
