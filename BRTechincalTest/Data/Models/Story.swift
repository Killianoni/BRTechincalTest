//
//  Story.swift
//  BRTechincalTest
//
//  Created by KILLIAN ADONAI on 09/06/2025.
//

import SwiftData
import Foundation

@Model
final class Story: Identifiable {
    @Attribute(.unique) var storyID: String
    var isLiked: Bool = false
    var isSeen: Bool = false
    var imageURL: [String]
    var username: String = ""
    var storyCreationDate: Date
    var profilePictureURL: String = ""

    var id: String { storyID }

    init(
        storyID: String,
        isLiked: Bool = false,
        isSeen: Bool = false,
        storyCreationDate: Date,
        username: String = "",
        imageURL: [String] = [],
        profilePictureURL: String = ""
    ) {
        self.storyID = storyID
        self.isLiked = isLiked
        self.isSeen = isSeen
        self.imageURL = imageURL
        self.username = username
        self.storyCreationDate = storyCreationDate
        self.profilePictureURL = profilePictureURL
    }
}

extension Story {
    static func mock(
        id: String = "mock",
        username: String = "Test User",
        isLiked: Bool = false,
        isSeen: Bool = false,
        imageCount: Int = 1
    ) -> Story {
        let images = (1...imageCount).map {
            "https://picsum.photos/1100/2500?random=\(abs((id + "\($0)").hashValue))"
        }

        return Story(
            storyID: id,
            isLiked: isLiked,
            isSeen: isSeen,
            storyCreationDate: Date().addingTimeInterval(-Double.random(in: 0...86400)),
            username: username,
            imageURL: images,
            profilePictureURL: "https://i.pravatar.cc/300?u=\(abs(id.hashValue % 100))"
        )
    }

    static var allMockStories: [Story] {
        let users = [
            (1, "Neo"), (2, "Trinity"), (3, "Morpheus"), (4, "Smith"), (5, "Oracle"),
            (6, "Cypher"), (7, "Niobe"), (8, "Dozer"), (9, "Switch"), (10, "Tank"),
            (11, "Seraph"), (12, "Sati"), (13, "Merovingian"), (14, "Persephone"), (15, "Ghost"),
            (16, "Lock"), (17, "Rama"), (18, "Bane"), (19, "The Keymaker"), (20, "Commander Thadeus"),
            (21, "Kid"), (22, "Zee"), (23, "Mifune"), (24, "Roland"), (25, "Cas"),
            (26, "Colt"), (27, "Vector"), (28, "Sequoia"), (29, "Sentinel"), (30, "Turing")
        ]

        return users.enumerated().map { index, user in
            Story(
                storyID: "\(user.0)",
                isLiked: index % 3 == 0,
                isSeen: index % 4 == 0,
                storyCreationDate: Date().addingTimeInterval(-Double(index * 1800)),
                username: user.1,
                imageURL: (1...Int.random(in: 1...4)).map { "https://picsum.photos/1100/2500?random=\(user.0 * 100 + $0)" },
                profilePictureURL: "https://i.pravatar.cc/300?u=\(user.0)"
            )
        }
    }
}
