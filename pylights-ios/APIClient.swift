//
//  APIClient.swift
//  pylights-ios
//
//  Created by Braden Guliano on 12/13/24.
//


import Foundation

class APIClient {
    private let baseURL: URL
    
    init(baseURL: String) {
        guard let url = URL(string: baseURL) else {
            fatalError("Invalid base URL")
        }
        self.baseURL = url
    }
    
    // Generic HTTP GET Request
    func get(endpoint: String, queryParameters: [String: String]? = nil) async throws -> Data {
        var url = baseURL.appendingPathComponent(endpoint)
        
        if let queryParameters = queryParameters {
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
            urlComponents?.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
            url = urlComponents?.url ?? url
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return try await executeRequest(request: request)
    }
    
    // Generic HTTP POST Request
    func post(endpoint: String, body: [String: Any]) async throws -> Data {
        let url = baseURL.appendingPathComponent(endpoint)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        return try await executeRequest(request: request)
    }
    
    // Execute HTTP Request
    private func executeRequest(request: URLRequest) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            throw APIError.invalidResponse(statusCode: httpResponse.statusCode)
        }
        
        return data
    }
}

// API Errors
enum APIError: Error {
    case invalidResponse(statusCode: Int)
    case invalidData
}
