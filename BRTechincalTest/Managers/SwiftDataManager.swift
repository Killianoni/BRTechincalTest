//
//  SwiftDataManager.swift
//  BRTechincalTest
//
//  Created by KILLIAN ADONAI on 09/06/2025.
//

import Foundation
import SwiftData

@MainActor
final class SwiftDataManager {
    // MARK: - Exposed Properties
    static let shared = SwiftDataManager()

    // MARK: - Private Properties
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext

    private init() {
        self.modelContainer = try! ModelContainer(
            for: Story.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: false)
        )
        self.modelContext = modelContainer.mainContext
    }

    // MARK: - Exposed Methods

    func deleteAllObjects() {
        do {
            try modelContext.delete(model: Story.self)
        } catch {
            print("Failed to clear all SwiftData objects.")
        }
    }
}
