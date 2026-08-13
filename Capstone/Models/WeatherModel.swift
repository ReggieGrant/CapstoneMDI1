//
//  WeatherModel.swift
//  CapstoneMDI1
//
//  Created by Reginald Grant on 8/5/26.
//

import Foundation

struct WeatherModel: Decodable, Identifiable {
    let id = UUID()
    let city: String
    let country: String
    let temp: Int
    let feelsLike: Int
    let condition: String
    let icon: String
    let humidity: Int
    let windSpeed: Int
    let visibility: Int
    let updated: String
    
    init(
        city: String,
        country: String,
        temp: Int,
        feelsLike: Int,
        condition: String,
        icon: String,
        humidity: Int,
        windSpeed: Int,
        visibility: Int,
        updated: String
    ) {
        self.city = city
        self.country = country
        self.temp = temp
        self.feelsLike = feelsLike
        self.condition = condition
        self.icon = icon
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.visibility = visibility
        self.updated = updated
    }
    
    // Maps OpenWeatherMap API response to our model
    
    enum CodingKeys: String, CodingKey {
        case city = "name"
        case sys, main, weather, wind, visibility, dt
    }
    
    // Custom decoder to match OpenWeatherMap's nested JSON structure
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.city = try container.decode(String.self, forKey: .city)
        
        let sysContainer = try container.nestedContainer(keyedBy: SysKeys.self, forKey: .sys)
        self.country = try sysContainer.decode(String.self, forKey: .country)
        
        let mainContainer = try container.nestedContainer(keyedBy: MainKeys.self, forKey: .main)
        self.temp = Int(try mainContainer.decode(Double.self, forKey: .temp).rounded())
        self.feelsLike = Int(try mainContainer.decode(Double.self, forKey: .feelsLike).rounded())
        self.humidity = try mainContainer.decode(Int.self, forKey: .humidity)
        
        var weatherArray = try container.nestedUnkeyedContainer(forKey: .weather)
        let weatherContainer = try weatherArray.nestedContainer(keyedBy: WeatherKeys.self)
        self.condition = try weatherContainer.decode(String.self, forKey: .description).capitalized
        let iconCode = try weatherContainer.decode(String.self, forKey: .icon)
        self.icon = WeatherModel.iconMapping(for: iconCode)
        
        let windContainer = try container.nestedContainer(keyedBy: WindKeys.self, forKey: .wind)
        self.windSpeed = Int(try windContainer.decode(Double.self, forKey: .speed).rounded())
        
        let visibilityMeters = try container.decodeIfPresent(Int.self, forKey: .visibility) ?? 10000
        self.visibility = Int(Double(visibilityMeters) / 1609.34)
        
        let timestamp = try container.decode(Int.self, forKey: .dt)
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        self.updated = formatter.string(from: date)
    }
    
    private enum SysKeys: String, CodingKey { case country }
    private enum MainKeys: String, CodingKey { case temp, feelsLike = "feels_like", humidity }
    private enum WeatherKeys: String, CodingKey { case description, icon }
    private enum WindKeys: String, CodingKey { case speed }
    
    // Same icon mapping logic as your Django get_weather_icon() function
    static func iconMapping(for code: String) -> String {
        let prefix = String(code.prefix(2))
        let mapping: [String: String] = [
            "01": "sun.max.fill",
            "02": "cloud.sun.fill",
            "03": "cloud.fill",
            "04": "cloud.fill",
            "09": "cloud.heavyrain.fill",
            "10": "cloud.rain.fill",
            "11": "cloud.bolt.fill",
            "13": "snowflake",
            "50": "cloud.fog.fill"
        ]
        return mapping[prefix] ?? "cloud.fill"
    }
}

