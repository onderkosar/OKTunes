//
//  PodcastVC.swift
//  OKTunes
//
//  Created by Önder Koşar on 11.09.2020.
//  Copyright © 2020 Önder Koşar. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PodcastVC: OKDataLoadingVC {
    var podcastsCollectionView: UICollectionView!
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
        view.addSubviews(podcastsCollectionView)
        podcastsCollectionView.pinToEdges(of: view, by: 5)
    }
    
    private func configureCollectionView() {
        podcastsCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        podcastsCollectionView.register(PodcastCell.self, forCellWithReuseIdentifier: PodcastCell.reuseID)
        podcastsCollectionView.delegate         = self
        podcastsCollectionView.backgroundColor  = .clear
        
        getModel().flatMap { fetchModel -> Observable<[AllResults]> in
            self.resultsArray.append(contentsOf: fetchModel.results)
            return Observable.just(self.resultsArray)
        }.bind(to: podcastsCollectionView.rx.items(cellIdentifier: PodcastCell.reuseID, cellType: PodcastCell.self)) {
            index, podcasts, cell in
            cell.set(with: podcasts)
        }.disposed(by: disposeBag)
        
        podcastsCollectionView
            .rx
            .itemSelected
            .subscribe(onNext: { [weak self ] (indexPath) in
                guard let strongSelf = self else { return }
                if let url = URL(string: strongSelf.resultsArray[indexPath.row].trackViewUrl!) {
                    UIApplication.shared.open(url)
                }
            }).disposed(by: disposeBag)
    }
    
    func getModel() -> Observable<FetchModel> {
        return NetworkManager.shared.fetch2(from: URLStrings.podcasts)
    }
}

extension PodcastVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width   = view.frame.width - 10
        let height  = view.frame.height / 10
        return CGSize(width: width, height: height)
    }
}
