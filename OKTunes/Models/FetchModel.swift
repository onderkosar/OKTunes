//
//  Musics.swift
//  OKTunes
//
//  Created by Önder Koşar on 11.09.2020.
//  Copyright © 2020 Önder Koşar. All rights reserved.
//

import Foundation

struct FetchModel: Codable, Hashable {
    let resultCount: Int
    let results: [AllResults]
}

struct AllResults: Codable, Hashable {
    let artistId, trackId: Int?
    let artistName, collectionName, trackName: String?
    let previewUrl, trackViewUrl: String?
    let artworkUrl100: String?
    let releaseDate: String?
    let primaryGenreName: String?
    let longDescription: String?
    
    var date: String {
        return (releaseDate?.convertToDisplayFormat())!
    }
}
