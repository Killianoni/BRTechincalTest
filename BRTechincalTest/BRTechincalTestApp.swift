//
//  BRTechincalTestApp.swift
//  BRTechincalTest
//
//  Created by KILLIAN ADONAI on 09/06/2025.
//

import SwiftUI
import SwiftData

@main
struct BRTechincalTestApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Story.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
