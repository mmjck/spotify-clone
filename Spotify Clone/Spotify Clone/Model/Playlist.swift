//
//  Playlist.swift
//  Spotify Clone
//
//  Created by Jackson Matheus on 28/03/23.
//

import Foundation



struct Playlist: Codable{
    let description: String
    let external_urls: [String:String]

    let id: String
    let images: [ApiImage]
    
    let name: String
    let owner: User

}
