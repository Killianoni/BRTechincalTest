//
//  StoryView.swift
//  BRTechincalTest
//
//  Created by KILLIAN ADONAI on 09/06/2025.
//

import SwiftUI

struct StoryView: View {
    //MARK: Private properties
    @State private var isPressed = false

    //MARK: Exposed properties
    let story: Story
    let onTap: () -> Void

    //MARK: Body
    var body: some View {
        VStack(spacing: 8) {
            AsyncImage(url: URL(string: story.profilePictureURL)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Circle()
                    .fill(.gray.opacity(0.3))
            }
            .frame(width: 60, height: 60)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .strokeBorder(
                        story.isSeen ? .gray.opacity(0.5) : .pink,
                        lineWidth: story.isSeen ? 2 : 4
                    )
            )
            .scaleEffect(isPressed ? 0.8 : 1.0)
            .animation(.spring(response: 0.3), value: isPressed)
            .onTapGesture {
                isPressed = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isPressed = false
                    onTap()
                }
            }
            VStack(spacing: 2) {
                Text(story.username)
                    .font(.caption)
                    .fontWeight(.medium)
                    .lineLimit(1)
            }
        }
        .frame(width: 70)
    }
}
