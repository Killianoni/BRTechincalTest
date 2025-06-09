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

                GeometryReader { geometry in
                    if currentImageIndex < currentStory.imageURL.count {
                        AsyncImage(url: URL(string: currentStory.imageURL[currentImageIndex])) { image in
                            image.resizable().scaledToFill().frame(maxWidth: .infinity, maxHeight: .infinity).clipped().onAppear { startTimer() }
                        } placeholder: {
                            ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white)).frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                }
                .overlay(
                    Group {
                        if showLikeAnimation {
                            Image(systemName: "heart.fill").font(.system(size: 80)).foregroundColor(.white).scaleEffect(showLikeAnimation ? 1.2 : 0.5).animation(.spring(), value: showLikeAnimation)
                        }
                    }
                )
                .onTapGesture(count: 2) { toggleLike() }
                .onTapGesture(count: 1) { location in handleTap(at: location, in: UIScreen.main.bounds.width) }

                HStack {
                    Button(action: toggleLike) {
                        Image(systemName: currentStory.isLiked ? "heart.fill" : "heart")
                            .font(.system(size: 24))
                            .foregroundColor(currentStory.isLiked ? .pink : .white)
                    }
                    Spacer()
                }
                .padding(.horizontal, 20).padding(.bottom, 30)
            }
        }
        .onAppear { onMarkSeen(currentStory.storyID) }
        .onDisappear { stopTimer() }
    }

    //MARK: Private methods
    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in nextImage() }
    }

    private func stopTimer() { timer?.invalidate(); timer = nil }

    private func nextImage() {
        if currentImageIndex < currentStory.imageURL.count - 1 {
            currentImageIndex += 1
        } else {
            nextStory()
        }
    }

    private func nextStory() {
        if currentStoryIndex < allStories.count - 1 {
            currentStory = allStories[currentStoryIndex + 1]
            currentImageIndex = 0
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

    private func handleTap(at location: CGPoint, in screenWidth: CGFloat) {
        if location.x < screenWidth / 3 {
            if currentImageIndex > 0 { currentImageIndex -= 1 } else { previousStory() }
        } else if location.x > screenWidth * 2/3 {
            nextImage()
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
