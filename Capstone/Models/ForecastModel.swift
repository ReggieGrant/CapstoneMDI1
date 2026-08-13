//
//  ForecastModel.swift
//  CapstoneMDI1
//
//  Created by Reginald Grant on 8/5/26.
//

import Foundation

struct ForecastDay: Codable, Identifiable {
    let id = UUID()
    let day: String
    let temp: Int
    let condition: String
    let icon: String
    let date: Date

    enum CodingKeys: String, CodingKey {
        case day, temp, condition, icon, date
    }
}
