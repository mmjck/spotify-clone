//
//  File.swift
//  Spotify Clone
//
//  Created by Jackson Matheus on 02/04/23.
//

import Foundation


struct AlbumDetailsResponse: Codable {
    let name: String
    let label: String
    let images: [ApiImage]
    let id: String
    let available_markets: [String]
    let external_urls: [String: String]
    let artists: [Artist]
    let album_type: String
    let tracks: TracksResponse
}


struct TracksResponse: Codable {
    let items: [AudioTrack]
    
}
