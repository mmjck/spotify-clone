//
//  AudioTracker.swift
//  Spotify Clone
//
//  Created by Jackson Matheus on 28/03/23.
//

import Foundation

struct AudioTrack : Codable {
    let album: Album?
    let artists: [Artist]
    let available_markets: [String]
    let disc_number: Int
    let duration_ms: Int
    let explicit: Bool
    let external_urls: [String: String]
    let id: String
    let name: String
    let popularity: Int?
}
