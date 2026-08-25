//
//  WeatherService.swift
//  CapstoneMDI1
//
//  Created by Reginald Grant on 8/5/26.
//
import Foundation

class WeatherService {
    static let shared = WeatherService()
    private let apiKey = "f9a8376a705d65d39f8dbec39facf65f"
    private let baseURL = "https://api.openweathermap.org/data/2.5"
    
    private init() {}
    
    func fetchCurrentWeather(city: String, country: String = "US") async throws -> WeatherModel {
        let data = try await NetworkManager.shared.fetchRawData(
            from: "\(baseURL)/weather",
            queryItems: [
                URLQueryItem(name: "q", value: "\(city),\(country)"),
                URLQueryItem(name: "appid", value: apiKey),
                URLQueryItem(name: "units", value: "imperial")
            ]
        )
        
        do {
            return try JSONDecoder().decode(WeatherModel.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }
    
    func fetchForecast(city: String, country: String = "US") async throws -> [ForecastDay] {
        let response = try await NetworkManager.shared.fetch(
            ForecastResponse.self,
            from: "\(baseURL)/forecast",
            queryItems: [
                URLQueryItem(name: "q", value: "\(city),\(country)"),
                URLQueryItem(name: "appid", value: apiKey),
                URLQueryItem(name: "units", value: "imperial"),
                URLQueryItem(name: "cnt", value: "40")
            ]
        )
        
        return WeatherService.parseDailyForecasts(from: response.list)
    }
    
    // Same grouping logic as before — unchanged
    private static func parseDailyForecasts(from items: [ForecastItem]) -> [ForecastDay] {
        var dailyMap: [String: ForecastDay] = [:]
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        
        for item in items {
            let date = Date(timeIntervalSince1970: TimeInterval(item.dt))
            let dayKey = calendar.startOfDay(for: date).description
            let hour = calendar.component(.hour, from: date)
            let isToday = calendar.isDateInToday(date)
            let dayLabel = isToday ? "Today" : formatter.string(from: date)
            
            if let existing = dailyMap[dayKey] {
                let existingHour = calendar.component(.hour, from: existing.date)
                if abs(hour - 12) < abs(existingHour - 12) {
                    dailyMap[dayKey] = ForecastDay(
                        day: dayLabel, temp: Int(item.main.temp.rounded()),
                        condition: item.weather.first?.main ?? "",
                        icon: WeatherModel.iconMapping(for: item.weather.first?.icon ?? ""),
                        date: date
                    )
                }
            } else {
                dailyMap[dayKey] = ForecastDay(
                    day: dayLabel, temp: Int(item.main.temp.rounded()),
                    condition: item.weather.first?.main ?? "",
                    icon: WeatherModel.iconMapping(for: item.weather.first?.icon ?? ""),
                    date: date
                )
            }
        }
        
        return dailyMap.values.sorted { $0.date < $1.date }.prefix(7).map { $0 }
    }
}

struct ForecastResponse: Codable {
    let list: [ForecastItem]
}

struct ForecastItem: Codable {
    let dt: Int
    let main: MainInfo
    let weather: [WeatherInfo]
    
    struct MainInfo: Codable { let temp: Double }
    struct WeatherInfo: Codable { let main: String; let icon: String }
}
