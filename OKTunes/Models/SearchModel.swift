//
//  SearchModel.swift
//  OKTunes
//
//  Created by Önder Koşar on 14.09.2020.
//  Copyright © 2020 Önder Koşar. All rights reserved.
//

import Foundation

struct SearchModel: Codable, Hashable {
    let resultCount: Int
    let results: [SearchResults]
}

struct SearchResults: Codable, Hashable {
    let artistId, trackId: Int?
    let artistName, trackName: String?
}
