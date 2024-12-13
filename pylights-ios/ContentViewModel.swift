//
//  ContentViewModel.swift
//  pylights-ios
//
//  Created by Braden Guliano on 12/13/24.
//

import Foundation

class ContentViewModel: ObservableObject {
    @Published var currentlyPlaying: Bool = false
    @Published var volume: Double = 50.0
    
    private var apiClient = APIClient(baseURL: "http://127.0.0.1:5001")
    
    init() {
        // first step, get all information
    }
}
