//
//  FeaturedPlaylistsResponse.swift
//  Spotify Clone
//
//  Created by Jackson Matheus on 30/03/23.
//

import Foundation

struct FeaturedPlaylistsResponse: Codable{
    let playlists: PlaylistResponse
    
}


struct PlaylistResponse: Codable{
    let items: [Playlist]
    
}

struct User: Codable{
    let display_name: String
    let external_urls: [String:String]
    let id: String

}
