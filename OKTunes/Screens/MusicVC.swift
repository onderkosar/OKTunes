//
//  MusicVC.swift
//  OKTunes
//
//  Created by Önder Koşar on 11.09.2020.
//  Copyright © 2020 Önder Koşar. All rights reserved.
//

import UIKit


class MusicVC: OKDataLoadingVC {
    var musicsCollectionView: UICollectionView!
    var resultsArray: [AllResults] = []
    
    var pushedBySearchVC = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        configureCollectionView()
        getItunes()
    }
    
    
    func configureCollectionView() {
        musicsCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        musicsCollectionView.register(MusicCell.self, forCellWithReuseIdentifier: MusicCell.reuseID)
        musicsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        musicsCollectionView.delegate         = self
        musicsCollectionView.dataSource       = self
        musicsCollectionView.backgroundColor  = .clear
        
        view.addSubview(musicsCollectionView)
        musicsCollectionView.pinToEdges(of: view, by: 2)
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
        return CGSize(width: view.frame.width, height: 110)
    }
}

extension MusicVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MusicCell.reuseID, for: indexPath) as! MusicCell
        cell.set(with: resultsArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destinationVC       = ItemInfoVC()
        destinationVC.result    = resultsArray[indexPath.row]
        destinationVC.isMovie   = false
        
        present(destinationVC, animated: true, completion: nil)
    }
}
