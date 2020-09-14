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
        view.backgroundColor = .systemOrange
        configureCollectionView()
        getItunes()
    }
    
    
    func configureCollectionView() {
        moviesCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        moviesCollectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseID)
        moviesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        moviesCollectionView.delegate         = self
        moviesCollectionView.dataSource       = self
        moviesCollectionView.backgroundColor  = .darkGray
        
        view.addSubview(moviesCollectionView)
    }
    
    func getItunes() {
        showLoadingView()
        NetworkManager.shared.fetch(from: URLStrings.movies) { (movies: FetchModel) in
            self.dismissLoadingView()
            self.updateUI(with: movies.results)
        }
    }
    
    func updateUI(with resultsArray : [AllResults]) {
        self.resultsArray.append(contentsOf: resultsArray)
        DispatchQueue.main.async {
            self.moviesCollectionView.reloadData()
        }
    }
}

extension MovieVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 110)
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
