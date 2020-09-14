//
//  Constants.swift
//  OKTunes
//
//  Created by Önder Koşar on 11.09.2020.
//  Copyright © 2020 Önder Koşar. All rights reserved.
//

import UIKit

enum SFSymbols {
    static let music    = UIImage(named: "music.note")
    static let movie    = UIImage(named: "film")
    static let podcast  = UIImage(named: "radiowaves")
    static let search   = UIImage(named: "magnifyingglass")
}

enum URLStrings {
    static let musics       = "https://itunes.apple.com/search?entity=song&attribute=ratingIndex&limit=20"
    static let movies       = "https://itunes.apple.com/search?term=movie&entity=movie&attribute=ratingTerm&limit=20"
    static let podcasts     = "https://itunes.apple.com/search?entity=podcast&attribute=ratingTerm&limit=20"
    
    static let artistName   = "https://itunes.apple.com/search?entity=musicArtist"
    static let movieName    = "https://itunes.apple.com/search?entity=movie"
    
    static let songById     = "https://itunes.apple.com/lookup?entity=song"
}

let segmentedItems = ["music", "movie"]
