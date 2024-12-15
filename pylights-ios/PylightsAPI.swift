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

class PylightsAPIClient {
    private let baseURL: URL
    private let baseEndpoint = "/pylights-api"
    
    lazy var songs = SongsModule(client: self)
    lazy var lights = LightsModule(client: self)
    lazy var presets = PresetsModule(client: self)
    lazy var remap = RemapModule(client: self)
    lazy var developer = DeveloperModule(client: self)
    
    init(baseURL: String) throws {
        guard let url = URL(string: baseURL) else {
            throw PylightsAPIError.invalidURL
        }
        self.baseURL = url
    }
    
    func makeRequest<T: Codable>(endpoint: String, queryParams: [String: String]? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        var urlComponents = URLComponents(url: baseURL.appendingPathComponent(baseEndpoint + endpoint), resolvingAgainstBaseURL: false)!
        if let queryParams {
            urlComponents.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        let request = URLRequest(url: urlComponents.url!)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            guard let data else {
                completion(.failure(NSError(domain: "PylightsAPIClient", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
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
        
        func play(name: String, completion: @escaping (Result<SongDescriptor, Error>) -> Void) {
            client.makeRequest(endpoint: "/songs/play", queryParams: ["name": name], completion: completion)
        }
        
        func pause(completion: @escaping (Result<SongDescriptor, Error>) -> Void) {
            client.makeRequest(endpoint: "/songs/pause", completion: completion)
        }
        
        func resume(completion: @escaping (Result<SongDescriptor, Error>) -> Void) {
            client.makeRequest(endpoint: "/songs/resume", completion: completion)
        }
        
        func stop(completion: @escaping (Result<SongDescriptor, Error>) -> Void) {
            client.makeRequest(endpoint: "/songs/stop", completion: completion)
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
