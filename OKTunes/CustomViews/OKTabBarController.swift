//
//  OKTabBarController.swift
//  OKTunes
//
//  Created by Önder Koşar on 11.09.2020.
//  Copyright © 2020 Önder Koşar. All rights reserved.
//

import UIKit


class OKTabBarController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers         = [createMusicNC(), createPodcastNC(), createMovieNC(), createSearchNC()]
    }
    
    
    func createMusicNC() -> UINavigationController {
        let musicVC             = MusicVC()
        musicVC.title           = "Top Musics"
        musicVC.tabBarItem      = UITabBarItem(title: "Musics", image: SFSymbols.music, tag: 0)
        
        return UINavigationController(rootViewController: musicVC)
    }
    
    func createPodcastNC() -> UINavigationController {
        let podcastVC           = PodcastVC()
        podcastVC.title         = "Top Podcasts"
        podcastVC.tabBarItem    = UITabBarItem(title: "Podcasts", image: SFSymbols.podcast, tag: 1)
        
        return UINavigationController(rootViewController: podcastVC)
    }
    
    func createMovieNC() -> UINavigationController {
        let movieVC             = MovieVC()
        movieVC.title           = "Top Movies"
        movieVC.tabBarItem      = UITabBarItem(title: "Movies", image: SFSymbols.movie, tag: 2)
        
        return UINavigationController(rootViewController: movieVC)
    }
    
    func createSearchNC() -> UINavigationController {
        let searchVC            = SearchVC()
        searchVC.title          = "Search"
        searchVC.tabBarItem     = UITabBarItem(title: "Search", image: SFSymbols.search, tag: 3)
        
        return UINavigationController(rootViewController: searchVC)
    }
}
