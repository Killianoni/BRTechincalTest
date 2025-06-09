//
//  StoryUseCase.swift
//  BRTechincalTest
//
//  Created by KILLIAN ADONAI on 09/06/2025.
//


import Foundation

final class StoryUseCase {
    //MARK: Private properties
    private let repository: StoryRepository

    init(repository: StoryRepository) {
        self.repository = repository
    }

    //MARK: Exposed methods
    func loadStories() -> [Story] {
        let stories = repository.getAllStories()
        return stories.isEmpty ? repository.createStoriesFromUsers() : stories
    }

    func refreshStories() -> [Story] {
        repository.deleteAllStories()
        return repository.createStoriesFromUsers()
    }

    func markStoryAsSeen(_ storyID: String) {
        repository.markAsSeen(storyID)
    }

    func toggleStoryLike(_ storyID: String) {
        repository.toggleLike(storyID)
    }

    func sortStories(_ stories: [Story]) -> [Story] {
        return stories.sorted { story1, story2 in
            if story1.isSeen != story2.isSeen {
                return !story1.isSeen
            }
            return story1.storyCreationDate > story2.storyCreationDate
        }
    }

    func getUnseenCount(_ stories: [Story]) -> Int {
        return stories.filter { !$0.isSeen }.count
    }

    func getLikedCount(_ stories: [Story]) -> Int {
        return stories.filter { $0.isLiked }.count
    }
}
