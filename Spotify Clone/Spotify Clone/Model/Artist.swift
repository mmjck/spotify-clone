//
//  Artists.swift
//  Spotify Clone
//
//  Created by Jackson Matheus on 28/03/23.
//

import Foundation


 struct Artist: Codable{
    let id: String
    let name: String
    let type: String
    let external_urls: [String: String]
    let images: [ApiImage]?
}
