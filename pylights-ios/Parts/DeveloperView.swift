//
//  DeveloperView.swift
//  pylights-ios
//
//  Created by Braden Guliano on 12/13/24.
//

import SwiftUI

struct DeveloperView: View {
    @ObservedObject var pylightsViewModel: PylightsViewModel
    
    var body: some View {
        VStack {
            List {
//                Section {
//
//                } header: {
//                    Text("Actions")
//                }
                
                Section {
                    InfoRow(title: "Version", value: pylightsViewModel.developer?.version)
                    InfoRow(title: "IP Address", value: pylightsViewModel.developer?.ipAddress)
                    InfoRow(title: "CPU Usage", value: pylightsViewModel.developer?.cpuUsage)
                    InfoRow(title: "Serial Port", value: pylightsViewModel.developer?.serialPort)
                } header: {
                    Text("Information")
                }
            }
        }
        .navigationTitle("Developer")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .onAppear(perform: pylightsViewModel.developerInfo)
        .onDisappear {
            pylightsViewModel.developer = nil
        }
    }
}

fileprivate struct ButtonRow: View {
    let title: String
    let action: () -> Void
    @State private var showConfirmation: Bool = false
    
    var body: some View {
        Button(title) {
            showConfirmation = true
        }
        .confirmationDialog("Are you sure you want to \(title.lowercased())?", isPresented: $showConfirmation, titleVisibility: .visible) {
            Button("Yes") { action() }
            Button("No", role: .cancel) {}
        }
    }
}

fileprivate struct InfoRow: View {
    let title: String
    let value: Any?
    
    var body: some View {
        if let value {
            HStack {
                Text(title)
                Spacer()
                Text(String(describing: value))
                    .foregroundStyle(.gray)
            }
        } else {
            ProgressView()
        }
    }
}

#Preview {
    NavigationStack {
        DeveloperView(pylightsViewModel: PylightsViewModel())
    }
}
