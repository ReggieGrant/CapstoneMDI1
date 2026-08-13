//
//  NetworkManager.swift
//  CapstoneMDI1
//
//  Created by Reginald Grant on 8/5/26.
//

import Foundation

// MARK: - Error Types
// Equivalent to your Python except blocks:
// requests.exceptions.RequestException / KeyError / generic Exception
enum NetworkError: LocalizedError {
    case invalidURL
    case noConnection
    case badStatus(code: Int)
    case decodingFailed(Error)
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The request URL was invalid."
        case .noConnection:
            return "Unable to fetch weather data. Please check your internet connection."
        case .badStatus(let code):
            return "Server returned an error (status \(code))."
        case .decodingFailed:
            return "Error parsing weather data from API."
        case .unknown:
            return "An unexpected error occurred."
        }
    }
}

// MARK: - HTTP Method
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

// MARK: - NetworkManager
// A singleton, like WeatherService.shared — one instance reused
// across the whole app instead of creating new URLSessions everywhere.
final class NetworkManager {
    static let shared = NetworkManager()
    
    private let session: URLSession
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 5 // same as your Python `timeout=5`
        self.session = URLSession(configuration: config)
    }
    
    /// Generic fetch-and-decode function.
    /// Equivalent to your Python pattern:
    ///     response = requests.get(url, params=params, timeout=5)
    ///     response.raise_for_status()
    ///     data = response.json()
    func fetch<T: Decodable>(
        _ type: T.Type,
        from urlString: String,
        method: HTTPMethod = .get,
        queryItems: [URLQueryItem] = []
    ) async throws -> T {
        
        guard var components = URLComponents(string: urlString) else {
            throw NetworkError.invalidURL
        }
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        print("Making API request to: \(url)") // same as your print() debug statements
        
        let data: Data
        let response: URLResponse
        
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            print("REQUEST ERROR: \(error.localizedDescription)")
            throw NetworkError.noConnection
        }
        
        // Equivalent to: if current_response.status_code != 200: raise ...
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown(URLError(.badServerResponse))
        }
        
        print("API Response Status: \(httpResponse.statusCode)")
        
        guard (200...299).contains(httpResponse.statusCode) else {
            if let body = String(data: data, encoding: .utf8) {
                print("API Error Response: \(body)")
            }
            throw NetworkError.badStatus(code: httpResponse.statusCode)
        }
        
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            print("SUCCESS: Data decoded")
            return decoded
        } catch {
            print("PARSE ERROR: \(error)")
            throw NetworkError.decodingFailed(error)
        }
    }
    
    /// Raw data fetch, for endpoints you'll parse manually
    /// (useful for the OpenWeatherMap responses with nested JSON,
    /// like your WeatherModel's custom decoder)
    func fetchRawData(
        from urlString: String,
        queryItems: [URLQueryItem] = []
    ) async throws -> Data {
        guard var components = URLComponents(string: urlString) else {
            throw NetworkError.invalidURL
        }
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        print("Making API request to: \(url)")
        
        let data: Data
        let response: URLResponse
        
        do {
            (data, response) = try await session.data(from: url)
        } catch {
            print("REQUEST ERROR: \(error.localizedDescription)")
            throw NetworkError.noConnection
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown(URLError(.badServerResponse))
        }
        
        print("API Response Status: \(httpResponse.statusCode)")
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.badStatus(code: httpResponse.statusCode)
        }
        
        return data
    }
}
