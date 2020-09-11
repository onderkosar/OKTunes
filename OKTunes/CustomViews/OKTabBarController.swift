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
        UITabBar.appearance().tintColor     = .systemGreen
        viewControllers                     = [createMusicNC(), createMovieNC(), createPodcastNC()]
    }
    
    
    func createMusicNC() -> UINavigationController {
        let musicVC = MusicVC()
        musicVC.title           = "Musics"
        musicVC.tabBarItem      = UITabBarItem(title: "Musics", image: SFSymbols.music, tag: 0)
        
        return UINavigationController(rootViewController: musicVC)
    }
    
    func createMovieNC() -> UINavigationController {
        let movieVC = MovieVC()
        movieVC.title           = "Movies"
        movieVC.tabBarItem      = UITabBarItem(title: "Movies", image: SFSymbols.movie, tag: 1)
        
        return UINavigationController(rootViewController: movieVC)
    }
    
    func createPodcastNC() -> UINavigationController {
        let podcastVC           = PodcastVC()
        podcastVC.title         = "Podcasts"
        podcastVC.tabBarItem    = UITabBarItem(title: "Podcasts", image: SFSymbols.podcast, tag: 2)
        
        return UINavigationController(rootViewController: podcastVC)
    }
}
