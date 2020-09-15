//
//  MovieVC.swift
//  OKTunes
//
//  Created by Önder Koşar on 11.09.2020.
//  Copyright © 2020 Önder Koşar. All rights reserved.
//

import UIKit


class MovieVC: OKDataLoadingVC {
    var moviesCollectionView: UICollectionView!
    var resultsArray: [AllResults] = []
    
    
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
        view.addSubview(moviesCollectionView)
        moviesCollectionView.pinToEdges(of: view, by: 5)
    }
    
    private func configureCollectionView() {
        moviesCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        moviesCollectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseID)
        moviesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        moviesCollectionView.delegate         = self
        moviesCollectionView.dataSource       = self
        moviesCollectionView.backgroundColor  = .clear
    }
    
    func getItunes() {
        showLoadingView()
        NetworkManager.shared.fetch(from: URLStrings.movies) { (movies: FetchModel) in
            self.dismissLoadingView()
            self.resultsArray.append(contentsOf: movies.results)
            self.updateUI()
        }
    }
    
    func updateUI() {
        DispatchQueue.main.async {
            self.moviesCollectionView.reloadData()
        }
    }
}

extension MovieVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width - 10), height: 100)
    }
}

extension MovieVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseID, for: indexPath) as! MovieCell
        cell.set(with: resultsArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destinationVC       = ItemInfoVC()
        destinationVC.result    = resultsArray[indexPath.row]
        
        present(destinationVC, animated: true, completion: nil)
    }
}
