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
    // These @Published properties replace your Django context dict:
    // context = {'weather': None, 'forecast': [], 'error': None}
    @Published var weather: WeatherModel?
    @Published var forecast: [ForecastDay] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchQuery: String = ""
    
    private let weatherService = WeatherService.shared
    
    // Equivalent to your home() view function logic
    func loadWeather(city: String = "Temecula", country: String = "US") async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Same as: current_response = requests.get(current_weather_url, ...)
            async let weatherResult = weatherService.fetchCurrentWeather(city: city, country: country)
            async let forecastResult = weatherService.fetchForecast(city: city, country: country)
            
            let (fetchedWeather, fetchedForecast) = try await (weatherResult, forecastResult)
            
            self.weather = fetchedWeather
            self.forecast = fetchedForecast
            
        } catch {
            // Same as your except requests.exceptions.RequestException block
            self.errorMessage = "Unable to fetch weather data. Please try again."
            print("Weather Error: \(error)")
        }
        
        isLoading = false
    }
    
    func searchLocation() async {
        guard !searchQuery.isEmpty else { return }
        await loadWeather(city: searchQuery)
    }
}
