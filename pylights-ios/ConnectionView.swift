//
//  ConnectionView.swift
//  pylights-ios
//
//  Created by Braden Guliano on 12/15/24.
//

import SwiftUI

fileprivate enum ConnectionType: String, CaseIterable, Identifiable {
    case hostname = "Hostname"
    case ipAddress = "IP Address"
    
    var id: Self { self }
}

fileprivate enum ConnectionStage {
    case disconnected
    case connecting
    case connected
}

fileprivate enum AlertType: String {
    case invalidPort = "Invalid port"
    case invalidHostname = "Invalid hostname"
    case connectionFailed = "Could not connect"
}

struct ConnectionView: View {
    @StateObject var pylightsViewModel = PylightsViewModel(debugMode: false)
    
    @State private var connectionType: ConnectionType = .hostname
    @State private var hostname: String = "pylights.local"
    @State private var ipAddress: String = ""
    @State private var port: String = "5001"
    
    @State private var connectionStage: ConnectionStage = .disconnected
    @State private var selectedAlert: AlertType?
    
    private var connectionInputBinding: Binding<String> {
        connectionType == .hostname ? $hostname : $ipAddress
    }
    
    var body: some View {
        VStack {
            if connectionStage == .connected {
                LazyView(ContentView(pylightsViewModel: pylightsViewModel))
            } else {
                Form {
                    VStack {
                        if let appIconName = AppIconProvider.appIconName(), let uiImage = UIImage(named: appIconName) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .frame(width: 200, height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 60))
                        }
                        Text("Welcome to Pylights!")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    Section {
                        Picker("Connection type", selection: $connectionType) {
                            ForEach(ConnectionType.allCases) { ct in
                                Text(ct.rawValue)
                            }
                        }
                        .pickerStyle(.segmented)
                        
                        TextField(connectionType.rawValue, text: connectionInputBinding)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .keyboardType(connectionType == .hostname ? .asciiCapable : .decimalPad)
                        TextField("Port", text: $port)
                            .keyboardType(.numberPad)
                    }
                    
                    Button("Connect") {
                        connectClicked()
                    }
                }
                .loadingOverlay(isLoading: connectionStage == .connecting)
            }
        }
        .alert(selectedAlert?.rawValue ?? "", isPresented: Binding<Bool>(
            get: { selectedAlert != nil },
            set: { if !$0 { selectedAlert = nil } }
        )) {
            Button("OK", role: .cancel) {}
        }
    }
    
    func connectClicked() {
        connectionStage = .connecting
        if connectionType == .hostname {
            validateHostnameAndConnect()
        } else {
            validatePortAndConnect()
        }
    }
    
    func validateHostnameAndConnect() {
        resolveHostname(hostname) { ipAddress in
            DispatchQueue.main.async {
                if let ipAddress {
                    self.ipAddress = ipAddress
                    self.validatePortAndConnect()
                } else {
                    selectedAlert = .invalidHostname
                    connectionStage = .disconnected
                }
            }
        }
    }
    
    func validatePortAndConnect() {
        guard Int(port) != nil else {
            selectedAlert = .invalidPort
            connectionStage = .disconnected
            return
        }
        connectToPylights()
    }
    
    func connectToPylights() {
        Task {
            let success = await pylightsViewModel.connect(ipAddress: ipAddress, port: Int(port)!)
            DispatchQueue.main.async {
                if success {
                    connectionStage = .connected
                } else {
                    selectedAlert = .connectionFailed
                    connectionStage = .disconnected
                }
            }
        }
    }
}

#Preview {
    ConnectionView()
}

#Preview {
    ConnectionView()
        .preferredColorScheme(.dark)
}
