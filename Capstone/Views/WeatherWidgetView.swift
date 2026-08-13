//
//  WeatherWidgetView.swift
//  CapstoneMDI1
//
//  Created by Reginald Grant on 8/5/26.
//

import SwiftUI

struct WeatherWidgetView: View {
    let weather: WeatherModel
    @State private var isPlaying = false
    
    var body: some View {
        VStack(spacing: 24) {
            
            // ---- Main weather display ----
            HStack(spacing: 20) {
                Image(systemName: weather.icon)
                    .font(.system(size: 70))
                    .foregroundColor(Color(hex: "667eea"))
                
                VStack(alignment: .leading, spacing: 4) {
                    Label("\(weather.city), \(weather.country)", systemImage: "mappin.and.ellipse")
                        .font(.headline)
                        .foregroundColor(Color(hex: "2c3e50"))
                    
                    Text("\(weather.temp)°F")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(Color(hex: "2c3e50"))
                    
                    Text(weather.condition)
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    Label("Updated \(weather.updated)", systemImage: "clock")
                        .font(.caption)
                        .foregroundColor(Color(hex: "95a5a6"))
                }
                
                Spacer()
            }
            
            // ---- Weather details grid (equivalent to .weather-details-grid) ----
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                WeatherDetailItem(icon: "wind", label: "Wind", value: "\(weather.windSpeed) mph")
                WeatherDetailItem(icon: "humidity", label: "Humidity", value: "\(weather.humidity)%")
                WeatherDetailItem(icon: "eye", label: "Visibility", value: "\(weather.visibility) mi")
                WeatherDetailItem(icon: "thermometer", label: "Feels Like", value: "\(weather.feelsLike)°F")
            }
            
            Divider()
            
            // ---- Music player bar (equivalent to .music-player) ----
            HStack {
                Label("\(weather.condition) Ambience", systemImage: "music.note")
                    .font(.subheadline)
                    .foregroundColor(Color(hex: "2c3e50"))
                
                Spacer()
                
                HStack(spacing: 16) {
                    Button(action: {}) {
                        Image(systemName: "backward.fill")
                    }
                    Button(action: { isPlaying.toggle() }) {
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            .padding(10)
                            .background(
                                LinearGradient(colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                                               startPoint: .leading, endPoint: .trailing)
                            )
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    Button(action: {}) {
                        Image(systemName: "forward.fill")
                    }
                }
                .foregroundColor(Color(hex: "667eea"))
            }
        }
        .padding(24)
        .background(Color.white)
        .cornerRadius(25)
        .shadow(color: .black.opacity(0.08), radius: 20, y: 10)
    }
}

struct WeatherDetailItem: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(Color(hex: "667eea"))
            Text(label.uppercased())
                .font(.caption2)
                .foregroundColor(.secondary)
            Text(value)
                .font(.title3.bold())
                .foregroundColor(Color(hex: "2c3e50"))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(hex: "f8f9fa"))
        .cornerRadius(15)
    }
}

#Preview {
    WeatherWidgetView(
        weather: WeatherModel(
            city: "Temecula",
            country: "US",
            temp: 78,
            feelsLike: 80,
            condition: "Sunny",
            icon: "sun.max.fill",
            humidity: 42,
            windSpeed: 8,
            visibility: 10,
            updated: "2:30 PM"
        )
    )
}
