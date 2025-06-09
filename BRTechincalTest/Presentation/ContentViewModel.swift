//
//  ContentViewModel.swift
//  BRTechincalTest
//
//  Created by KILLIAN ADONAI on 09/06/2025.
//

import Foundation
import SwiftUI
import SwiftData

@MainActor
final class ContentViewModel: ObservableObject {
    //MARK: Private properties
    private let useCase: StoryUseCase

    //MARK: Public properties
    @Published var stories: [Story] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    var sortedStories: [Story] { useCase.sortStories(stories) }
    var unseenCount: Int { useCase.getUnseenCount(stories) }
    var likedCount: Int { useCase.getLikedCount(stories) }

    init(useCase: StoryUseCase) {
        self.useCase = useCase
    }

    //MARK: Exposed methods
    func loadStories() {
        isLoading = true
        let loadedStories = useCase.loadStories()
        self.stories = loadedStories
        self.isLoading = false
    }

    func refreshStories() {
        isLoading = true
        let refreshedStories = useCase.refreshStories()
        self.stories = refreshedStories
        self.isLoading = false
    }

    func markStoryAsSeen(_ storyID: String) {
        useCase.markStoryAsSeen(storyID)
        if let index = stories.firstIndex(where: { $0.storyID == storyID }) {
            stories[index].isSeen = true
        }
    }

    func toggleStoryLike(_ storyID: String) {
        useCase.toggleStoryLike(storyID)
        if let index = stories.firstIndex(where: { $0.storyID == storyID }) {
            stories[index].isLiked.toggle()
        }
    }
}
