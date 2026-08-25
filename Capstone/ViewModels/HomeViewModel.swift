//
//  HomeViewModel.swift
//  CapstoneMDI1
//
//  Created by Reginald Grant on 8/5/26.
//



import Foundation
internal import Combine

@MainActor
class HomeViewModel: ObservableObject {
    @Published var weather: WeatherModel?
    @Published var forecast: [ForecastDay] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchQuery: String = ""
    
    private let weatherService = WeatherService.shared
    
    func loadWeather(city: String = "Temecula", country: String = "US") async {
        guard !isLoading else {
            print("Already loading — ignoring duplicate refresh call")
            return
        }
        isLoading = true
        errorMessage = nil
        
        async let weatherResult = Self.fetchCurrentWeather(city: city, country: country)
        async let forecastResult = Self.fetchForecast(city: city, country: country)
        
        let (weatherOutcome, forecastOutcome) = await (weatherResult, forecastResult)
        
        switch weatherOutcome {
        case .success(let result):
            weather = result
            errorMessage = nil
            print("✓ WEATHER succeeded: \(result.temp)°F")
        case .failure(let error):
            if let networkError = error as? NetworkError {
                errorMessage = networkError.errorDescription
            } else {
                errorMessage = "Unable to fetch weather data. Please try again."
            }
            print("✗ WEATHER failed specifically: \(error)")
        }
        
        switch forecastOutcome {
        case .success(let result):
            forecast = result
            print("✓ FORECAST succeeded: \(result.count) days")
        case .failure(let error):
            print("✗ FORECAST failed specifically: \(error)")
        }
        
        isLoading = false
    }
    
    private nonisolated static func fetchCurrentWeather(city: String, country: String) async -> Result<WeatherModel, Error> {
        do {
            let result = try await WeatherService.shared.fetchCurrentWeather(city: city, country: country)
            return .success(result)
        } catch {
            return .failure(error)
        }
    }
    
    private nonisolated static func fetchForecast(city: String, country: String) async -> Result<[ForecastDay], Error> {
        do {
            let result = try await WeatherService.shared.fetchForecast(city: city, country: country)
            return .success(result)
        } catch {
            return .failure(error)
        }
    }
    
    func searchLocation() async {
        guard !searchQuery.isEmpty else { return }
        await loadWeather(city: searchQuery)
    }
}
