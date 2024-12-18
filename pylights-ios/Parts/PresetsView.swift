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
                    NavigationLink("Add preset", destination: AddPresetView(pylightsViewModel: pylightsViewModel))
                        .foregroundStyle(.blue)
                } footer: {
                    Text("Or add a new one")
                }
            }
            .navigationTitle("Presets")
        }
    }
}

fileprivate struct AddPresetView: View {
    @ObservedObject var pylightsViewModel: PylightsViewModel

    @State private var selectedItems = Set<String>()

    var body: some View {
        List {
            Section(header: Text("Lights")) {
                ForEach(pylightsViewModel.presets, id: \.name) { preset in
                    HStack {
                        Text(preset.name)
                        Spacer()
                        if selectedItems.contains(preset.name) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                    .contentShape(Rectangle()) // Makes the entire row tappable
                    .onTapGesture {
                        toggleSelection(for: preset.name)
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle()) // Optional: Adds a modern grouped style
    }

    private func toggleSelection(for item: String) {
        if selectedItems.contains(item) {
            selectedItems.remove(item)
        } else {
            selectedItems.insert(item)
        }
    }
}



#Preview {
    let vm = PylightsViewModel()
    vm.setupPreview()
    return PresetsView(pylightsViewModel: vm)
}
