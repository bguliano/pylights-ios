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

fileprivate struct AlertMessage: Identifiable {
    let id = UUID()
    let message: String
}

struct ConnectionView: View {
    @StateObject var pylightsViewModel = PylightsViewModel()
    
    @State private var connectionType: ConnectionType = .hostname
    @State private var hostname: String = "pylights.local"
    @State private var ipAddress: String = ""
    @State private var port: String = "5001"
    
    @State private var connectionStage: ConnectionStage = .disconnected
    @State private var alertMessage: AlertMessage? = nil
    
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
                            .keyboardType(connectionType == .hostname ? .default : .decimalPad)
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
        .alert(item: $alertMessage) { alertMessage in
            Alert(title: Text(alertMessage.message))
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
                    showAlert(message: "Invalid hostname")
                    connectionStage = .disconnected
                }
            }
        }
    }
    
    func validatePortAndConnect() {
        guard Int(port) != nil else {
            showAlert(message: "Invalid port")
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
                    showAlert(message: "Could not connect")
                    connectionStage = .disconnected
                }
            }
        }
    }
    
    func showAlert(message: String) {
        alertMessage = AlertMessage(message: message)
    }
}

#Preview {
    ConnectionView()
}

#Preview {
    ConnectionView()
        .preferredColorScheme(.dark)
}
