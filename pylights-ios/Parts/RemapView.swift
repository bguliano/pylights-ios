//
//  RemapView.swift
//  pylights-ios
//
//  Created by Braden Guliano on 12/13/24.
//

import SwiftUI

struct RemapView: View {
    @ObservedObject var pylightsViewModel: PylightsViewModel
    
    @Environment(\.dismiss) private var dismiss
    @State private var showSuccessAlert: Bool = false
    @State private var showCancelConfirmationDialog: Bool = false
    
    var body: some View {
        VStack {
            if let remapRemaining = pylightsViewModel.remapRemaining {
                List(remapRemaining, id: \.self) { lightName in
                    Button(lightName) {
                        // if this is the last remap, then clicking this button should indicate success
                        if remapRemaining.count == 1 {
                            showSuccessAlert = true
                        }
                        pylightsViewModel.nextRemap(name: lightName)
                    }
                }
            } else {
                Color(uiColor: UIColor.systemGroupedBackground)
                    .ignoresSafeArea()
            }
        }
        .navigationTitle("Remap")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                CustomBackButton {
                    showCancelConfirmationDialog = true
                }
            }
        }
        .onAppear(perform: pylightsViewModel.startRemap)
        // when successful and view dismisses, update the state of toggles in LightsView
        .onDisappear(perform: pylightsViewModel.reloadInfo)
        .alert("Remap Successful", isPresented: $showSuccessAlert) {
            Button("OK", role: .cancel) {
                dismiss()
            }
        }
        .confirmationDialog("Are you sure?", isPresented: $showCancelConfirmationDialog, titleVisibility: .visible) {
            Button("Yes") {
                pylightsViewModel.cancelRemap()
                dismiss()
            }
            Button("No", role: .cancel) {}
        }
    }
}

#Preview {
    let vm = PylightsViewModel()
    vm.setupPreview()
    return NavigationStack {
        RemapView(pylightsViewModel: vm)
    }
}
