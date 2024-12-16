//
//  PylightsAPI.swift
//  pylights-ios
//
//  Created by Braden Guliano on 12/13/24.
//

import Foundation


enum PylightsAPIError: Error {
    case invalidURL
}

class PylightsAPIClient: ObservableObject {
    private var baseURL: URL?
    private let baseEndpoint = "/pylights-api"
    
    lazy var songs = SongsModule(client: self)
    lazy var lights = LightsModule(client: self)
    lazy var presets = PresetsModule(client: self)
    lazy var remap = RemapModule(client: self)
    lazy var developer = DeveloperModule(client: self)
    
    @Published var isLoading: Bool = false
    
    func connect(baseURL: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(PylightsAPIError.invalidURL))
            return
        }
        
        // Set the baseURL temporarily for validation
        self.baseURL = url
        
        // Use the `info` method to validate the connection
        self.info { result in
            switch result {
            case .success:
                print("Successfully connected to \(baseURL)")
                completion(.success(())) // Connection successful
            case .failure(let error):
                print("Connection validation failed: \(error.localizedDescription)")
                self.baseURL = nil // Reset baseURL as the connection is invalid
                completion(.failure(error)) // Pass the error back to the caller
            }
        }
    }
    
    func makeRequest<T: Codable>(endpoint: String, queryParams: [String: String]? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        guard let baseURL else { fatalError("PylightsAPIClient must be connected before making requests") }
        
        isLoading = true
        
        var urlComponents = URLComponents(url: baseURL.appendingPathComponent(baseEndpoint + endpoint), resolvingAgainstBaseURL: false)!
        if let queryParams {
            urlComponents.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        let request = URLRequest(url: urlComponents.url!)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            defer { self.isLoading = false }
            
            if let error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "PylightsAPIClient", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }
            
            guard let data else {
                completion(.failure(NSError(domain: "PylightsAPIClient", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            if httpResponse.statusCode != 200 {
                do {
                    // Attempt to decode the error message from the JSON response
                    if let errorResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String],
                       let errorMessage = errorResponse["error"] {
                        completion(.failure(NSError(domain: "PylightsAPIClient", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                    } else {
                        // Fallback to a generic error message if JSON decoding fails
                        let genericError = "HTTP \(httpResponse.statusCode): Unknown error"
                        completion(.failure(NSError(domain: "PylightsAPIClient", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: genericError])))
                    }
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
//                print(String(data: data, encoding: .utf8))
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func info(completion: @escaping (Result<InfoDescriptor, Error>) -> Void) {
        makeRequest(endpoint: "/info", completion: completion)
    }
    
    class SongsModule {
        private let client: PylightsAPIClient
        
        init(client: PylightsAPIClient) {
            self.client = client
        }
        
        func play(name: String, completion: @escaping (Result<SongsDescriptor, Error>) -> Void) {
            client.makeRequest(endpoint: "/songs/play", queryParams: ["name": name], completion: completion)
        }
        
        func pause(completion: @escaping (Result<SongsDescriptor, Error>) -> Void) {
            client.makeRequest(endpoint: "/songs/pause", completion: completion)
        }
        
        func resume(completion: @escaping (Result<SongsDescriptor, Error>) -> Void) {
            client.makeRequest(endpoint: "/songs/resume", completion: completion)
        }
        
        func stop(completion: @escaping (Result<SongsDescriptor, Error>) -> Void) {
            client.makeRequest(endpoint: "/songs/stop", completion: completion)
        }
        
        func volume(value: Int, completion: @escaping (Result<SongsDescriptor, Error>) -> Void) {
            client.makeRequest(endpoint: "/songs/volume", queryParams: ["value": String(value)], completion: completion)
        }
    }
    
    class LightsModule {
        private let client: PylightsAPIClient
        
        init(client: PylightsAPIClient) {
            self.client = client
        }
        
        func allOn(completion: @escaping (Result<LightsDescriptor, Error>) -> Void) {
            client.makeRequest(endpoint: "/lights/all-on", completion: completion)
        }
        
        func allOff(completion: @escaping (Result<LightsDescriptor, Error>) -> Void) {
            client.makeRequest(endpoint: "/lights/all-off", completion: completion)
        }
        
        func turnOn(name: String, completion: @escaping (Result<LightsDescriptor, Error>) -> Void) {
            client.makeRequest(endpoint: "/lights/turn-on", queryParams: ["name": name], completion: completion)
        }
        
        func turnOff(name: String, completion: @escaping (Result<LightsDescriptor, Error>) -> Void) {
            client.makeRequest(endpoint: "/lights/turn-off", queryParams: ["name": name], completion: completion)
        }
        
        func toggle(name: String, completion: @escaping (Result<LightsDescriptor, Error>) -> Void) {
            client.makeRequest(endpoint: "/lights/toggle", queryParams: ["name": name], completion: completion)
        }
    }
    
    class PresetsModule {
        private let client: PylightsAPIClient
        
        init(client: PylightsAPIClient) {
            self.client = client
        }
        
        func activate(name: String, completion: @escaping (Result<PresetsDescriptor, Error>) -> Void) {
            client.makeRequest(endpoint: "/presets/activate", queryParams: ["name": name], completion: completion)
        }
        
        func add(name: String, lights: [String], completion: @escaping (Result<PresetsDescriptor, Error>) -> Void) {
            client.makeRequest(endpoint: "/presets/add", queryParams: ["name": name, "lights": lights.joined(separator: ",")], completion: completion)
        }
    }
    
    class RemapModule {
        private let client: PylightsAPIClient
        
        init(client: PylightsAPIClient) {
            self.client = client
        }
        
        func start(completion: @escaping (Result<RemapDescriptor, Error>) -> Void) {
            client.makeRequest(endpoint: "/remap/start", completion: completion)
        }
        
        func next(name: String, completion: @escaping (Result<RemapDescriptor, Error>) -> Void) {
            client.makeRequest(endpoint: "/remap/next", queryParams: ["name": name], completion: completion)
        }
        
        func cancel(completion: @escaping (Result<RemapDescriptor, Error>) -> Void) {
            client.makeRequest(endpoint: "/remap/cancel", completion: completion)
        }
    }
    
    class DeveloperModule {
        private let client: PylightsAPIClient
        
        init(client: PylightsAPIClient) {
            self.client = client
        }
        
        func recompileShows(completion: @escaping (Result<DeveloperDescriptor, Error>) -> Void) {
            client.makeRequest(endpoint: "/developer/recompile-shows", completion: completion)
        }
        
        func info(completion: @escaping (Result<DeveloperDescriptor, Error>) -> Void) {
            client.makeRequest(endpoint: "/developer/info", completion: completion)
        }
    }
}
