//
//  MusicVC.swift
//  OKTunes
//
//  Created by Önder Koşar on 11.09.2020.
//  Copyright © 2020 Önder Koşar. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

var audioPlayer = AVPlayer()

class MusicVC: OKDataLoadingVC {
    var musicsCollectionView: UICollectionView!
    var resultsArray: [AllResults] = []
    
    var pushedBySearchVC = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        configureCollectionView()
        configure()
        getItunes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        audioPlayer.pause()
    }
    
    
    private func configure() {
        view.addSubview(musicsCollectionView)
        musicsCollectionView.pinToEdges(of: view, by: 5)
    }
    
    private func configureCollectionView() {
        musicsCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        musicsCollectionView.register(MusicCell.self, forCellWithReuseIdentifier: MusicCell.reuseID)
        musicsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        musicsCollectionView.delegate         = self
        musicsCollectionView.dataSource       = self
        musicsCollectionView.backgroundColor  = .clear
    }
    
    func getItunes() {
        showLoadingView()
        NetworkManager.shared.fetch(from: URLStrings.musics) { (musics: FetchModel) in
            self.dismissLoadingView()
            if !self.pushedBySearchVC { self.resultsArray.append(contentsOf: musics.results) }
            self.updateUI()
        }
    }
    
    func updateUI() {
        DispatchQueue.main.async {
            self.musicsCollectionView.reloadData()
        }
    }
}

extension MusicVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width - 10), height: 100)
    }
}

extension MusicVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MusicCell.reuseID, for: indexPath) as! MusicCell
        cell.set(with: resultsArray[indexPath.row], delegate: self)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let url = URL(string: resultsArray[indexPath.row].trackViewUrl!) {
            UIApplication.shared.open(url)
        }
    }
}

extension MusicVC: MusicPreviewDelegate {
    func playPreview(urlStr: String) {
        audioPlayerSetup(urlString: urlStr)
        audioPlayer.play()
    }
    
    func pausePreview() {
        audioPlayer.pause()
    }
    
    private func audioPlayerSetup(urlString: String) {
        guard let url = URL(string: urlString) else {
            print("error to get the mp3 file")
            return
        }
        audioPlayer = AVPlayer(url: url)
    }
    
}
