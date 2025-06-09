//
//  StoryService.swift
//  BRTechincalTest
//
//  Created by KILLIAN ADONAI on 09/06/2025.
//

import Foundation

final class StoryService {
    //MARK: Public properties
    static let shared = StoryService()

    //MARK: Private properties
    private init() {}

    //MARK: Exposed methods
    func loadUsers() -> [User] {
        let jsonData = """
        {
          "pages": [
            {
              "users": [
                { "id": 1, "name": "Neo", "profile_picture_url": "https://i.pravatar.cc/300?u=1" },
                { "id": 2, "name": "Trinity", "profile_picture_url": "https://i.pravatar.cc/300?u=2" },
                { "id": 3, "name": "Morpheus", "profile_picture_url": "https://i.pravatar.cc/300?u=3" },
                { "id": 4, "name": "Smith", "profile_picture_url": "https://i.pravatar.cc/300?u=4" },
                { "id": 5, "name": "Oracle", "profile_picture_url": "https://i.pravatar.cc/300?u=5" },
                { "id": 6, "name": "Cypher", "profile_picture_url": "https://i.pravatar.cc/300?u=6" },
                { "id": 7, "name": "Niobe", "profile_picture_url": "https://i.pravatar.cc/300?u=7" },
                { "id": 8, "name": "Dozer", "profile_picture_url": "https://i.pravatar.cc/300?u=8" },
                { "id": 9, "name": "Switch", "profile_picture_url": "https://i.pravatar.cc/300?u=9" },
                { "id": 10, "name": "Tank", "profile_picture_url": "https://i.pravatar.cc/300?u=10" }
              ]
            },
            {
              "users": [
                { "id": 11, "name": "Seraph", "profile_picture_url": "https://i.pravatar.cc/300?u=11" },
                { "id": 12, "name": "Sati", "profile_picture_url": "https://i.pravatar.cc/300?u=12" },
                { "id": 13, "name": "Merovingian", "profile_picture_url": "https://i.pravatar.cc/300?u=13" },
                { "id": 14, "name": "Persephone", "profile_picture_url": "https://i.pravatar.cc/300?u=14" },
                { "id": 15, "name": "Ghost", "profile_picture_url": "https://i.pravatar.cc/300?u=15" },
                { "id": 16, "name": "Lock", "profile_picture_url": "https://i.pravatar.cc/300?u=16" },
                { "id": 17, "name": "Rama", "profile_picture_url": "https://i.pravatar.cc/300?u=17" },
                { "id": 18, "name": "Bane", "profile_picture_url": "https://i.pravatar.cc/300?u=18" },
                { "id": 19, "name": "The Keymaker", "profile_picture_url": "https://i.pravatar.cc/300?u=19" },
                { "id": 20, "name": "Commander Thadeus", "profile_picture_url": "https://i.pravatar.cc/300?u=20" }
              ]
            },
            {
              "users": [
                { "id": 21, "name": "Kid", "profile_picture_url": "https://i.pravatar.cc/300?u=21" },
                { "id": 22, "name": "Zee", "profile_picture_url": "https://i.pravatar.cc/300?u=22" },
                { "id": 23, "name": "Mifune", "profile_picture_url": "https://i.pravatar.cc/300?u=23" },
                { "id": 24, "name": "Roland", "profile_picture_url": "https://i.pravatar.cc/300?u=24" },
                { "id": 25, "name": "Cas", "profile_picture_url": "https://i.pravatar.cc/300?u=25" },
                { "id": 26, "name": "Colt", "profile_picture_url": "https://i.pravatar.cc/300?u=26" },
                { "id": 27, "name": "Vector", "profile_picture_url": "https://i.pravatar.cc/300?u=27" },
                { "id": 28, "name": "Sequoia", "profile_picture_url": "https://i.pravatar.cc/300?u=28" },
                { "id": 29, "name": "Sentinel", "profile_picture_url": "https://i.pravatar.cc/300?u=29" },
                { "id": 30, "name": "Turing", "profile_picture_url": "https://i.pravatar.cc/300?u=30" }
              ]
            }
          ]
        }
        """.data(using: .utf8)!

        do {
            let usersData = try JSONDecoder().decode(UsersData.self, from: jsonData)
            return usersData.pages.flatMap { $0.users }
        } catch {
            print("Error loading users: \(error)")
            return []
        }
    }

    func generateStoryImages(for userID: Int) -> [String] {
        let count = Int.random(in: 1...4)
        return (0..<count).map { index in
            "https://picsum.photos/1100/2500?random=\(userID * 100 + index)"
        }
    }
}
