//
//  SearchResultModel.swift
//  Spotify Clone
//
//  Created by Jackson Matheus on 06/04/23.
//

import Foundation
struct SearchResultResponse: Codable {
    let albums: SearchAlbumResponse
    let artists: SearchArtistResponse
    let tracks: SearchTracksResponse
    let playlists: SearchPlaylistResponse


}

struct SearchTracksResponse: Codable {
    let items: [AudioTrack]
}


struct SearchPlaylistResponse: Codable {
    let items: [Playlist]
}

struct SearchArtistResponse: Codable {
    let items: [Artist]
}

struct SearchAlbumResponse: Codable {
    let items: [Album]
}
