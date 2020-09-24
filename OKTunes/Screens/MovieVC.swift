//
//  MovieVC.swift
//  OKTunes
//
//  Created by Önder Koşar on 11.09.2020.
//  Copyright © 2020 Önder Koşar. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class MovieVC: OKDataLoadingVC {
    var moviesCollectionView: UICollectionView!
    var resultsArray: [AllResults] = []
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        configureCollectionView()
        configureSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        audioPlayer.pause()
    }
    
    
    private func configureSubviews() {
        view.addSubviews(moviesCollectionView)
        moviesCollectionView.pinToEdges(of: view, by: 5)
    }
    
    private func configureCollectionView() {
        moviesCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        moviesCollectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseID)
        moviesCollectionView.delegate         = self
        moviesCollectionView.backgroundColor  = .clear
        
        getModel().flatMap { fetchModel -> Observable<[AllResults]> in
            self.resultsArray.append(contentsOf: fetchModel.results)
            return Observable.just(self.resultsArray)
        }.bind(to: moviesCollectionView.rx.items(cellIdentifier: MovieCell.reuseID, cellType: MovieCell.self)) {
            index, movies, cell in
            cell.set(with: movies)
        }.disposed(by: disposeBag)
        
        moviesCollectionView
            .rx
            .itemSelected
            .subscribe(onNext: { [weak self ] (indexPath) in
                guard let strongSelf = self else { return }
                
                let destinationVC       = ItemInfoVC()
                destinationVC.result    = strongSelf.resultsArray[indexPath.row]
                
                strongSelf.present(destinationVC, animated: true, completion: nil)
            }).disposed(by: disposeBag)
    }
    
    func getModel() -> Observable<FetchModel> {
        return NetworkManager.shared.fetch(from: URLStrings.movies)
    }
}

extension MovieVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width   = view.frame.width - 10
        let height  = view.frame.height / 10
        return CGSize(width: width, height: height)
    }
}
