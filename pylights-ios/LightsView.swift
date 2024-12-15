//
//  LightsView.swift
//  pylights-ios
//
//  Created by Braden Guliano on 12/13/24.
//

import SwiftUI

struct LightsView: View {
    @ObservedObject var pylightsViewModel: PylightsViewModel

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button {
                        pylightsViewModel.allOn()
                    } label: {
                        Label("All on", systemImage: "lightbulb.fill")
                    }
                    Button {
                        pylightsViewModel.allOff()
                    } label: {
                        Label("All off", systemImage: "lightbulb")
                    }
                } header: {
                    Text("Full control")
                }
                
                Section {
                    ForEach(pylightsViewModel.lights, id: \.name) { light in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(light.name)
                                    .font(.headline)
                                Text("GPIO: \(light.gpio)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Toggle("", isOn: Binding(
                                get: { light.value },
                                set: { _, _ in
                                    pylightsViewModel.toggleLight(light.name)
                                }
                            ))
                            .labelsHidden()
                        }
                    }
                } header: {
                    Text("Individual control")
                }
            }
            .navigationTitle("Lights")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink(destination: RemapView()) {
                        Image(systemName: "rectangle.connected.to.line.below")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: DeveloperView()) {
                        Image(systemName: "wrench")
                    }
                }
            }
        }
    }
}

#Preview {
    LightsView(pylightsViewModel: PylightsViewModel())
}
