//
//  StoryDetailsView.swift
//  BRTechincalTest
//
//  Created by KILLIAN ADONAI on 09/06/2025.
//

import SwiftUI
import SwiftData

struct StoryDetailView: View {
    //MARK: Private properties
    @Environment(\.dismiss) private var dismiss
    @State private var currentStory: Story
    @State private var currentImageIndex = 0
    @State private var timer: Timer?
    @State private var showLikeAnimation = false
    private var currentStoryIndex: Int { allStories.firstIndex(where: { $0.storyID == currentStory.storyID }) ?? 0 }

    //MARK: Exposed properties
    let allStories: [Story]
    let onMarkSeen: (String) -> Void
    let onToggleLike: (String) -> Void

    init(story: Story, allStories: [Story], onMarkSeen: @escaping (String) -> Void, onToggleLike: @escaping (String) -> Void) {
        self._currentStory = State(initialValue: story)
        self.allStories = allStories
        self.onMarkSeen = onMarkSeen
        self.onToggleLike = onToggleLike
    }

    //MARK: body
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 0) {
                HStack {
                    AsyncImage(url: URL(string: currentStory.profilePictureURL)) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Circle().fill(.gray)
                    }
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())

                    Text(currentStory.username).foregroundColor(.white).font(.system(size: 16, weight: .semibold))
                    Text(timeAgo(currentStory.storyCreationDate)).foregroundColor(.gray).font(.system(size: 14))
                    Spacer()
                    Button("✕") { dismiss() }.foregroundColor(.white).font(.system(size: 18, weight: .bold))
                }
                .padding(.horizontal, 16).padding(.vertical, 8)

                HStack(spacing: 4) {
                    ForEach(0..<currentStory.imageURL.count, id: \.self) { index in
                        Rectangle()
                            .fill(index <= currentImageIndex ? .white : .white.opacity(0.3))
                            .frame(height: 2)
                    }
                }
                .padding(.horizontal, 16)

                TabView(selection: $currentImageIndex) {
                    ForEach(Array(currentStory.imageURL.enumerated()), id: \.offset) { index, urlString in
                        CachedAsyncImage(url: URL(string: urlString))
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .overlay(
                    HStack(spacing: 0) {
                        Rectangle().fill(.white.opacity(0.001))
                            .onTapGesture { handleTap(isLeft: true) }
                        Rectangle().fill(.white.opacity(0.001))
                            .onTapGesture(count: 2) { toggleLike() }
                        Rectangle().fill(.white.opacity(0.001))
                            .onTapGesture { handleTap(isLeft: false) }
                    }
                )

                HStack {
                    Button(action: toggleLike) {
                        Image(systemName: currentStory.isLiked ? "heart.fill" : "heart")
                            .font(.system(size: 24))
                            .foregroundColor(currentStory.isLiked ? .pink : .white)
                    }
                    Spacer()
                    Text("\(currentImageIndex + 1) / \(allStories.count)").foregroundColor(.white.opacity(0.7)).font(.system(size: 14))
                }
                .padding(.horizontal, 20).padding(.bottom, 30)
            }
        }
        .onAppear {
            onMarkSeen(currentStory.storyID)
            currentStory.isSeen = true
            startTimer()
        }
        .onDisappear { stopTimer() }
        .onChange(of: currentImageIndex) {
            startTimer()
            prefetchAdjacentImages()
        }
        .onChange(of: currentStory.id) {
            currentImageIndex = 0
        }
    }

    //MARK: Private methods
    private func prefetchAdjacentImages() {
        let urls = currentStory.imageURL

        let nextIndex = currentImageIndex + 1
        if nextIndex < urls.count, let nextUrl = URL(string: urls[nextIndex]) {
            Task {
                _ = await ImageLoader.shared.loadImage(from: nextUrl)
            }
        }

        let prevIndex = currentImageIndex - 1
        if prevIndex >= 0, let prevUrl = URL(string: urls[prevIndex]) {
            Task { _ = await ImageLoader.shared.loadImage(from: prevUrl) }
        }
    }

    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
            nextImage()
        }
    }

    private func stopTimer() { timer?.invalidate(); timer = nil }

    private func handleTap(isLeft: Bool) {
        if isLeft {
            previousImage()
        } else {
            nextImage()
        }
    }

    private func nextImage() {
        if currentImageIndex < currentStory.imageURL.count - 1 {
            currentImageIndex += 1
        } else {
            nextStory()
        }
    }

    private func previousImage() {
        if currentImageIndex > 0 {
            currentImageIndex -= 1
        } else {
            previousStory()
        }
    }

    private func nextStory() {
        if currentStoryIndex < allStories.count - 1 {
            currentStory = allStories[currentStoryIndex + 1]
        } else {
            dismiss()
        }
    }

    private func previousStory() {
        if currentStoryIndex > 0 {
            currentStory = allStories[currentStoryIndex - 1]
            currentImageIndex = currentStory.imageURL.count - 1
        }
    }

    private func toggleLike() {
        onToggleLike(currentStory.storyID)
        currentStory.isLiked.toggle()
        showLikeAnimation = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { showLikeAnimation = false }
    }

    private func timeAgo(_ date: Date) -> String {
        let hours = Int(Date().timeIntervalSince(date)) / 3600
        return hours > 0 ? "\(hours)h" : "now"
    }
}
