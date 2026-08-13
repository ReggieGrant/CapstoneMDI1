//
//  ForecastView.swift
//  CapstoneMDI1
//
//  Created by Reginald Grant on 8/5/26.
//

import SwiftUI

struct ForecastView: View {
    let forecast: [ForecastDay]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("7-Day Forecast")
                .font(.title2.bold())
                .foregroundColor(Color(hex: "2c3e50"))
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(forecast) { day in
                        VStack(spacing: 12) {
                            Text(day.day)
                                .font(.subheadline.bold())
                                .foregroundColor(Color(hex: "2c3e50"))
                            
                            Image(systemName: day.icon)
                                .font(.system(size: 28))
                                .foregroundColor(Color(hex: "667eea"))
                            
                            Text("\(day.temp)°")
                                .font(.title3.bold())
                                .foregroundColor(Color(hex: "2c3e50"))
                            
                            Text(day.condition)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .frame(width: 100)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.06), radius: 10, y: 5)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    ForecastView(forecast: [
        ForecastDay(day: "Mon", temp: 72, condition: "Sunny", icon: "sun.max.fill", date: Date()),
        ForecastDay(day: "Tue", temp: 68, condition: "Cloudy", icon: "cloud.fill", date: Date()),
        ForecastDay(day: "Wed", temp: 65, condition: "Rain", icon: "cloud.rain.fill", date: Date())
    ])
}
