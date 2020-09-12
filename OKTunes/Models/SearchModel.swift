//
//  Musics.swift
//  OKTunes
//
//  Created by Önder Koşar on 11.09.2020.
//  Copyright © 2020 Önder Koşar. All rights reserved.
//

import Foundation

struct SearchModel: Codable, Hashable {
    let resultCount: Int
    let results: [Results]
}

struct Results: Codable, Hashable {
    let artistId, collectionId, trackId: Int?
    let artistName, collectionName, trackName: String?
    let previewUrl: String?
    let artworkUrl100: String
    let releaseDate: String
    let primaryGenreName: String
    let longDescription: String?
    
    var date: String {
        return releaseDate.convertToDisplayFormat()
    }
}
