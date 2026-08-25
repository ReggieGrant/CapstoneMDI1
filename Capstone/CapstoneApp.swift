//
//  CapstoneApp.swift
//  Capstone
//
//  Created by Reginald Grant on 8/5/26.
//

import SwiftUI
import SwiftData

@main
struct CapstoneApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                LoginView()
            }
        }
        // Registers all three @Model types so SwiftData knows
        // what tables to create in its local SQLite store
        .modelContainer(for: [UserAccount.self, SavedLocationRecord.self, MomentRecord.self])
    }
}
