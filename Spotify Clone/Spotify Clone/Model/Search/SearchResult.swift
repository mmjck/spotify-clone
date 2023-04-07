//
//  SearchResult.swift
//  Spotify Clone
//
//  Created by Jackson Matheus on 06/04/23.
//

import Foundation
enum SearchResult {
    case artists(model: Artist)
    case album(model: Album)
    case track(model: AudioTrack)
    case playlists(model: Playlist)
}
