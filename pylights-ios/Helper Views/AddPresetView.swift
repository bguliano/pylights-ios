//
//  AddPresetView.swift
//  pylights-ios
//
//  Created by Braden Guliano on 12/18/24.
//

import SwiftUI

fileprivate enum AlertType: String {
    case success = "Preset added successfully"
    case invalidName = "Invalid name"
    case noLightsSelected = "No lights selected"
}

struct AddPresetView: View {
    @ObservedObject var pylightsViewModel: PylightsViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var selectedLights = Set<String>()
    
    @State private var selectedAlert: AlertType?
    
    var body: some View {
        List {
            TextField("Name", text: $name)
            
            Section {
                ForEach(pylightsViewModel.lights, id: \.name) { light in
                    HStack {
                        Button {
                            toggleSelection(for: light.name)
                            UIApplication.shared.endEditing()
                        } label: {
                            HStack {
                                Text(light.name)
                                Spacer()
                                if selectedLights.contains(light.name) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        .foregroundStyle(.primary)
                    }
                }
            } header: {
                Text("Light selection")
            } footer: {
                Text("Click as many of the above lights as you would like to include in your preset")
            }
            
            Button("Submit") {
                submitPreset()
            }
        }
        .navigationTitle("Add Preset")
        .navigationBarTitleDisplayMode(.inline)
        .alert(selectedAlert?.rawValue ?? "", isPresented: Binding<Bool>(
            get: { selectedAlert != nil },
            set: { if !$0 { selectedAlert = nil } }
        )) {
            Button("OK", role: .cancel) {
                if selectedAlert == .success { dismiss() }
            }
        }
    }
    
    private func toggleSelection(for item: String) {
        if selectedLights.contains(item) {
            selectedLights.remove(item)
        } else {
            selectedLights.insert(item)
        }
    }
    
    private func submitPreset() {
        if name.isEmpty {
            selectedAlert = .invalidName
        } else if selectedLights.isEmpty {
            selectedAlert = .noLightsSelected
        } else {
            pylightsViewModel.addPreset(name, Array(selectedLights))
            selectedAlert = .success
        }
    }
}

#Preview {
    NavigationStack {
        AddPresetView(pylightsViewModel: PylightsViewModel())
    }
}
