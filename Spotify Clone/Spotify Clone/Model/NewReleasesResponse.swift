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


