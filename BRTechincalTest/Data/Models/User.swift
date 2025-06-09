//
//  User.swift
//  BRTechincalTest
//
//  Created by KILLIAN ADONAI on 09/06/2025.
//

import Foundation

struct UsersData: Codable {
    let pages: [Page]
}

struct Page: Codable {
    let users: [User]
}

struct User: Codable, Identifiable {
    let id: Int
    let name: String
    let profilePictureUrl: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case profilePictureUrl = "profile_picture_url"
    }
}
