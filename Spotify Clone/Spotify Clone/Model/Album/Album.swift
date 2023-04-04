//
//  File.swift
//  Spotify Clone
//
//  Created by Jackson Matheus on 02/04/23.
//

import Foundation

struct Album: Codable {
    let album_type: String
    let available_markets: [String]
    let id: String
    let name: String
    let release_date: String
    let total_tracks: Int
    let images: [ApiImage]
    let artists: [Artist]
}
