//
//  SavedLocationRecord.swift
//  CapstoneMDI1
//
//  Created by Reginald Grant on 8/19/26.
//

import Foundation
import SwiftData

@Model
final class SavedLocationRecord {
    var name: String
    var icon: String
    var temperature: Int
    var condition: String
    var createdAt: Date
    var owner: UserAccount?
    
    init(
        name: String,
        icon: String = "cloud.fill",
        temperature: Int = 0,
        condition: String = "Loading...",
        owner: UserAccount? = nil
    ) {
        self.name = name
        self.icon = icon
        self.temperature = temperature
        self.condition = condition
        self.createdAt = Date()
        self.owner = owner
    }
}
