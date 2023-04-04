//
//  PlaylistDetailsResponse.swift
//  Spotify Clone
//
//  Created by Jackson Matheus on 02/04/23.
//

import Foundation


struct  PlaylistDetailsResponse: Codable {
    let description: String
    let external_urls: [String: String]
    let id: String
    let images: [ApiImage]
    let name: String
    let tracks: PlaylistTracksResponse
}


struct PlaylistTracksResponse: Codable {
    let items: [PlaylistItem]
}


struct PlaylistItem: Codable {
    let track : AudioTrack
    
}
