//
//  PodcastVC.swift
//  OKTunes
//
//  Created by Önder Koşar on 11.09.2020.
//  Copyright © 2020 Önder Koşar. All rights reserved.
//

import UIKit


class PodcastVC: OKDataLoadingVC {
    var podcastsCollectionView: UICollectionView!
    var resultsArray: [AllResults] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        configureCollectionView()
        getItunes()
    }
    
    
    func configureCollectionView() {
        podcastsCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        podcastsCollectionView.register(PodcastCell.self, forCellWithReuseIdentifier: PodcastCell.reuseID)
        podcastsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        podcastsCollectionView.delegate         = self
        podcastsCollectionView.dataSource       = self
        podcastsCollectionView.backgroundColor  = .darkGray
        
        view.addSubview(podcastsCollectionView)
    }
    
    func getItunes() {
        showLoadingView()
        NetworkManager.shared.fetch(from: URLStrings.podcasts) { (podcasts: FetchModel) in
            self.dismissLoadingView()
            self.resultsArray.append(contentsOf: podcasts.results)
            self.updateUI()
        }
    }
    
    func updateUI() {
        DispatchQueue.main.async {
            self.podcastsCollectionView.reloadData()
        }
    }
}

extension PodcastVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 110)
    }
}

extension PodcastVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PodcastCell.reuseID, for: indexPath) as! PodcastCell
        cell.set(with: resultsArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let url = URL(string: resultsArray[indexPath.row].trackViewUrl!) {
            UIApplication.shared.open(url)
        }
    }
}
