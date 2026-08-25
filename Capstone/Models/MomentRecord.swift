//
//  MomentRecord.swift
//  CapstoneMDI1
//
//  Created by Reginald Grant on 8/19/26.
//
import Foundation
import SwiftData

@Model
final class MomentRecord {
    var username: String
    var locationName: String
    var temperature: Int
    var weatherTypeRaw: String   
    var captionText: String
    var postedAt: Date
    var likeCount: Int
    var isLikedByCurrentUser: Bool
    var isBookmarked: Bool
    
    var weatherType: WeatherType {
        WeatherType(rawValue: weatherTypeRaw) ?? .cloudy
    }
    
    init(username: String, locationName: String, temperature: Int, weatherType: WeatherType, captionText: String) {
        self.username = username
        self.locationName = locationName
        self.temperature = temperature
        self.weatherTypeRaw = weatherType.rawValue
        self.captionText = captionText
        self.postedAt = Date()
        self.likeCount = 0
        self.isLikedByCurrentUser = false
        self.isBookmarked = false
    }
}
