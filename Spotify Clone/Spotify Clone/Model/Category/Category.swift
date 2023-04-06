//
//  Category.swift
//  Spotify Clone
//
//  Created by Jackson Matheus on 04/04/23.
//

import Foundation

struct Categories: Codable {
    let items: [Category]
}
struct Category: Codable {
    let name: String
    let id: String
    let icons: [ApiImage]
}
