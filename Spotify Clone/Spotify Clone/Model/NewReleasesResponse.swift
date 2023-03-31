//
//  NewReleasesResponse.swift
//  Spotify Clone
//
//  Created by Jackson Matheus on 30/03/23.
//

import Foundation


struct NewReleasesResponse: Codable{
    let albums: AlbumsResponse
    
}


struct AlbumsResponse: Codable{
    let items: [Album]
}

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

