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
    let trackLbl        = OKTitleLabel(textAlignment: .left, fontSize: 18)
    let albumLbl        = OKSecondaryTitleLabel(fontSize: 18)
    let artistLbl       = OKSecondaryTitleLabel(fontSize: 15)
    
    let playBtn         = OKButton(backgroundColor: .clear, title: "")
    let pauseBtn        = OKButton(backgroundColor: .clear, title: "")
    
    var delegate: MusicPreviewDelegate?
    
    var previewUrlString: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureButtons()
        configureElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(with result: AllResults, delegate: MusicPreviewDelegate) {
        self.delegate           = delegate
        self.previewUrlString   = result.previewUrl
        trackLbl.text           = result.trackName
        albumLbl.text           = result.collectionName!
        artistLbl.text          = result.artistName
        artworkImgView.downloadImage(fromURL: URL(string: result.artworkUrl100!)!)
    }
    
    private func configure() {
        addSubviews(artworkImgView, trackLbl, albumLbl, artistLbl, playBtn, pauseBtn)
        
        let imgHeight: CGFloat  = contentView.frame.height - 5
        let imgWidth: CGFloat   = imgHeight

        NSLayoutConstraint.activate([
            artworkImgView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            artworkImgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            artworkImgView.widthAnchor.constraint(equalToConstant: imgWidth),
            artworkImgView.heightAnchor.constraint(equalToConstant: imgHeight),
            
            trackLbl.topAnchor.constraint(equalTo: artworkImgView.topAnchor),
            trackLbl.leadingAnchor.constraint(equalTo: artworkImgView.trailingAnchor, constant: 5),
            trackLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            trackLbl.heightAnchor.constraint(equalToConstant: 20),
            
            albumLbl.topAnchor.constraint(equalTo: trackLbl.bottomAnchor, constant: 2),
            albumLbl.leadingAnchor.constraint(equalTo: artworkImgView.trailingAnchor, constant: 5),
            albumLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            albumLbl.heightAnchor.constraint(equalToConstant: 20),
            
            artistLbl.bottomAnchor.constraint(equalTo: artworkImgView.bottomAnchor, constant: -2),
            artistLbl.leadingAnchor.constraint(equalTo: artworkImgView.trailingAnchor, constant: 5),
            artistLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            artistLbl.heightAnchor.constraint(equalToConstant: 17)
        ])
    }
    
    private func configureButtons() {
        let buttons = [playBtn, pauseBtn]
        
        for button in buttons {
            button.adjustsImageWhenHighlighted = false
            button.pinToEdges(of: artworkImgView, by: 0)
            button.tintColor        = .black
            button.clipsToBounds    = true
            
            button.setImage(SFSymbols.play, for: .normal)
            button.imageView?.layer.cornerRadius    = (button.imageView?.frame.size.height)! / 2
            button.imageView?.backgroundColor       = .white
        }
    }
    
    private func configureElements() {
        artistLbl.alpha     = 0.7
        
        playBtn.isHidden    = false
        pauseBtn.isHidden   = true
        
        playBtn.addTarget(self, action: #selector(playBtnPressed), for: .touchUpInside)
        pauseBtn.addTarget(self, action: #selector(pauseBtnPressed), for: .touchUpInside)
    }
    
    @objc func playBtnPressed() {
        playBtn.isHidden    = true
        pauseBtn.isHidden   = false
        
        guard let urlStr = previewUrlString else {
            return
        }
        
        delegate?.playPreview(urlStr: urlStr)
    }
    
    @objc func pauseBtnPressed() {
        pauseBtn.isHidden   = true
        playBtn.isHidden    = false
        
        delegate?.pausePreview()
    }
}
