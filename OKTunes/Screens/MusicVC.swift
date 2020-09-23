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
import RxSwift
import RxCocoa

var audioPlayer = AVPlayer()

class MusicVC: OKDataLoadingVC {
    var musicsCollectionView: UICollectionView!
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
        view.addSubviews(musicsCollectionView)
        musicsCollectionView.pinToEdges(of: view, by: 5)
    }
    
    private func configureCollectionView() {
        musicsCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        musicsCollectionView.register(MusicCell.self, forCellWithReuseIdentifier: MusicCell.reuseID)
        musicsCollectionView.delegate = self
        musicsCollectionView.backgroundColor  = .clear
        
        getModel().flatMap { fetchModel -> Observable<[AllResults]> in
            self.resultsArray.append(contentsOf: fetchModel.results)
            return Observable.just(self.resultsArray)
        }.bind(to: musicsCollectionView.rx.items(cellIdentifier: MusicCell.reuseID, cellType: MusicCell.self)) {
            index, musics, cell in
            cell.set(with: musics, delegate: self)
        }.disposed(by: disposeBag)
        
        musicsCollectionView
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
        return NetworkManager.shared.fetch2(from: URLStrings.musics)
    }
}

extension MusicVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width   = view.frame.width - 10
        let height  = view.frame.height / 10
        return CGSize(width: width, height: height)
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
