//
//  MusicCell.swift
//  OKTunes
//
//  Created by Önder Koşar on 11.09.2020.
//  Copyright © 2020 Önder Koşar. All rights reserved.
//

import UIKit

class MusicCell: UICollectionViewCell {
    static let reuseID  = "musicCell"
    
    let artworkImgView  = OKImageView(content: .scaleAspectFit)
    let trackLbl        = OKTitleLabel(textAlignment: .left, fontSize: 20)
    let albumLbl        = OKSecondaryTitleLabel(fontSize: 18)
    let artistLbl       = OKSecondaryTitleLabel(fontSize: 15)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(with result: AllResults) {
        trackLbl.text   = result.trackName
        albumLbl.text   = result.collectionName
        artistLbl.text  = result.artistName
        artworkImgView.downloadImage(fromURL: URL(string: result.artworkUrl100)!)
    }
    
    private func configure() {
        addSubviews(artworkImgView, trackLbl, albumLbl, artistLbl)
        artworkImgView.backgroundColor  = .black
        trackLbl.backgroundColor        = .clear
        albumLbl.backgroundColor        = .clear
        artistLbl.backgroundColor       = .clear
        artistLbl.alpha                 = 0.7
        
        let imgHeight: CGFloat  = 100
        let imgWidth: CGFloat   = imgHeight

        NSLayoutConstraint.activate([
            artworkImgView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            artworkImgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            artworkImgView.widthAnchor.constraint(equalToConstant: imgWidth),
            artworkImgView.heightAnchor.constraint(equalToConstant: imgHeight),
            
            trackLbl.topAnchor.constraint(equalTo: artworkImgView.topAnchor, constant: 2),
            trackLbl.leadingAnchor.constraint(equalTo: artworkImgView.trailingAnchor, constant: 10),
            trackLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            trackLbl.heightAnchor.constraint(equalToConstant: 22),
            
            albumLbl.topAnchor.constraint(equalTo: trackLbl.bottomAnchor, constant: 2),
            albumLbl.leadingAnchor.constraint(equalTo: artworkImgView.trailingAnchor, constant: 10),
            albumLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            albumLbl.heightAnchor.constraint(equalToConstant: 20),
            
            artistLbl.bottomAnchor.constraint(equalTo: artworkImgView.bottomAnchor, constant: -2),
            artistLbl.leadingAnchor.constraint(equalTo: artworkImgView.trailingAnchor, constant: 10),
            artistLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            artistLbl.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
