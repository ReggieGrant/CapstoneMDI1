//
//  MomentModel.swift
//  CapstoneMDI1
//
//  Created by Reginald Grant on 8/5/26.
//

import SwiftUI

struct MomentModel: Identifiable, Codable {
    let id = UUID()
    let username: String
    let avatarURL: String
    let imageURL: String
    let location: String
    let temperature: Int
    let weatherType: WeatherType
    let caption: String
    let postedAt: String
    var likes: Int
    var comments: Int
    var isLiked: Bool = false
    var isBookmarked: Bool = false

    enum CodingKeys: String, CodingKey {
        case username
        case avatarURL
        case imageURL
        case location
        case temperature
        case weatherType
        case caption
        case postedAt
        case likes
        case comments
        case isLiked
        case isBookmarked
    }
}

enum WeatherType: String, Codable, CaseIterable {
    case sunny, rainy, cloudy, snowy, stormy, foggy, windy
    
    var icon: String {
        switch self {
        case .sunny: return "sun.max.fill"
        case .rainy: return "cloud.rain.fill"
        case .cloudy: return "cloud.fill"
        case .snowy: return "snowflake"
        case .stormy: return "cloud.bolt.fill"
        case .foggy: return "cloud.fog.fill"
        case .windy: return "wind"
        }
    }
    
    var gradientColors: [Color] {
        switch self {
        case .sunny: return [Color(hex: "f093fb"), Color(hex: "f5576c"), Color(hex: "ffd140")]
        case .rainy: return [Color(hex: "4facfe"), Color(hex: "00f2fe"), Color(hex: "667eea")]
        case .snowy: return [Color(hex: "a1c4fd"), Color(hex: "c2e9fb"), Color(hex: "e0f7fa")]
        case .stormy: return [Color(hex: "434343"), Color(hex: "000000"), Color(hex: "667eea")]
        case .foggy: return [Color(hex: "a8edea"), Color(hex: "fed6e3"), Color(hex: "d299c2")]
        case .cloudy: return [Color(hex: "e0e0e0"), Color(hex: "bdbdbd"), Color(hex: "9e9e9e")]
        case .windy: return [Color(hex: "16a085"), Color(hex: "f4d03f"), Color(hex: "1abc9c")]
        }
    }
}

