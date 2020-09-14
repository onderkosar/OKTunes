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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        configureCollectionView()
        getItunes()
    }
    
    
    func configureCollectionView() {
        musicsCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        musicsCollectionView.register(MusicCell.self, forCellWithReuseIdentifier: MusicCell.reuseID)
        musicsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        musicsCollectionView.delegate         = self
        musicsCollectionView.dataSource       = self
        musicsCollectionView.backgroundColor  = .darkGray
        
        view.addSubview(musicsCollectionView)
    }
    
    func getItunes() {
        showLoadingView()
        NetworkManager.shared.fetch(from: URLStrings.musics) { (musics: SearchModel) in
            self.dismissLoadingView()
            self.updateUI(with: musics.results)
        }
    }
    
    func updateUI(with resultsArray : [AllResults]) {
        self.resultsArray.append(contentsOf: resultsArray)
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
}
