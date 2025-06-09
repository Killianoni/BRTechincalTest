//
//  StoryRepository.swift
//  BRTechincalTest
//
//  Created by KILLIAN ADONAI on 09/06/2025.
//

import Foundation
import SwiftData

final class StoryRepository {
    //MARK: Private properties
    private let modelContext: ModelContext
    private let storyService: StoryService

    init(modelContext: ModelContext, storyService: StoryService = .shared) {
        self.modelContext = modelContext
        self.storyService = storyService
    }

    //MARK: Exposed methods
    func getAllStories() -> [Story] {
        do {
            let descriptor = FetchDescriptor<Story>(
                sortBy: [SortDescriptor(\.storyCreationDate, order: .reverse)]
            )
            return try modelContext.fetch(descriptor)
        } catch {
            print("Error fetching stories: \(error)")
            return []
        }
    }

    func createStoriesFromUsers() -> [Story] {
        let users = storyService.loadUsers()
        let stories = users.map { user in
            Story(
                storyID: "\(user.id)",
                storyCreationDate: Date().addingTimeInterval(-Double.random(in: 0...86400)),
                username: user.name,
                imageURL: storyService.generateStoryImages(for: user.id),
                profilePictureURL: user.profilePictureUrl
            )
        }

        stories.forEach { modelContext.insert($0) }
        saveContext()
        return stories
    }

    func markAsSeen(_ storyID: String) {
        if let story = getStory(by: storyID) {
            story.isSeen = true
            saveContext()
        }
    }

    func toggleLike(_ storyID: String) {
        if let story = getStory(by: storyID) {
            story.isLiked.toggle()
            saveContext()
        }
    }

    func deleteAllStories() {
        do {
            try modelContext.delete(model: Story.self)
            saveContext()
        } catch {
            print("Error deleting stories: \(error)")
        }
    }

    //MARK: Private methods
    private func getStory(by id: String) -> Story? {
        let descriptor = FetchDescriptor<Story>(predicate: #Predicate { $0.storyID == id })
        return try? modelContext.fetch(descriptor).first
    }

    private func saveContext() {
        do {
            try modelContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
