//
//  MovieCell.swift
//  OKTunes
//
//  Created by Önder Koşar on 12.09.2020.
//  Copyright © 2020 Önder Koşar. All rights reserved.
//

import UIKit

class MovieCell: UICollectionViewCell {
    static let reuseID  = "movieCell"
    
    let artworkImgView  = OKImageView(content: .scaleAspectFit)
    let movieLbl        = OKTitleLabel(textAlignment: .left, fontSize: 20)
    let directorLbl     = OKSecondaryTitleLabel(fontSize: 18)
    let releaseDateLbl  = OKSecondaryTitleLabel(fontSize: 15)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(with result: AllResults) {
        movieLbl.text       = result.trackName
        directorLbl.text    = "Director: " + (result.artistName ?? "NA")
        releaseDateLbl.text = "Rel Date: " + result.date
        artworkImgView.downloadImage(fromURL: URL(string: result.artworkUrl100!)!)
    }
    
    private func configure() {
        addSubviews(artworkImgView, movieLbl, releaseDateLbl, directorLbl)
        artworkImgView.backgroundColor  = .clear
        movieLbl.backgroundColor        = .clear
        directorLbl.backgroundColor     = .clear
        releaseDateLbl.backgroundColor  = .clear
        releaseDateLbl.alpha            = 0.7
        
        let imgHeight: CGFloat  = 100
        let imgWidth: CGFloat   = imgHeight * 27 / 40

        NSLayoutConstraint.activate([
            artworkImgView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            artworkImgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            artworkImgView.widthAnchor.constraint(equalToConstant: imgWidth),
            artworkImgView.heightAnchor.constraint(equalToConstant: imgHeight),
            
            movieLbl.topAnchor.constraint(equalTo: artworkImgView.topAnchor, constant: 2),
            movieLbl.leadingAnchor.constraint(equalTo: artworkImgView.trailingAnchor, constant: 10),
            movieLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            movieLbl.heightAnchor.constraint(equalToConstant: 22),
            
            directorLbl.topAnchor.constraint(equalTo: movieLbl.bottomAnchor, constant: 2),
            directorLbl.leadingAnchor.constraint(equalTo: artworkImgView.trailingAnchor, constant: 10),
            directorLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            directorLbl.heightAnchor.constraint(equalToConstant: 20),
            
            releaseDateLbl.bottomAnchor.constraint(equalTo: artworkImgView.bottomAnchor, constant: -2),
            releaseDateLbl.leadingAnchor.constraint(equalTo: artworkImgView.trailingAnchor, constant: 10),
            releaseDateLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            releaseDateLbl.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
}
