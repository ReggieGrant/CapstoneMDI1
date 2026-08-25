//
//  UserAccount.swift
//  CapstoneMDI1
//
//  Created by Reginald Grant on 8/19/26.
//


import Foundation
import SwiftData

@Model
final class UserAccount {
    @Attribute(.unique) var username: String
    var email: String
    var passwordHash: String       // never store plaintext passwords, even locally
    var createdAt: Date
    
    // Relationship: one user can have many saved locations.
    // Equivalent to a Django ForeignKey pointing back to a User.
    @Relationship(deleteRule: .cascade, inverse: \SavedLocationRecord.owner)
    var savedLocations: [SavedLocationRecord] = []
    
    init(username: String, email: String, passwordHash: String) {
        self.username = username
        self.email = email
        self.passwordHash = passwordHash
        self.createdAt = Date()
    }
}
