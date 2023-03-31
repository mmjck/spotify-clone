//
//  SettingsModel.swift
//  Spotify Clone
//
//  Created by Jackson Matheus on 28/03/23.
//

import Foundation


struct Section {
    let title: String
    let option: [Option]
    
}


struct Option {
    let title: String
    let handle: () -> Void
}
