//
//  GitUser.swift
//  GitHubProfile
//
//  Created by Ricardo on 26/11/23.
//

import Foundation

struct GitUser: Decodable {
    let login: String
    let avatarUrl: String
    let bio: String
    let name: String
    let publicRepos: Int
    let followers: Int
}
