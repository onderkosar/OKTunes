//
//  ItemInfoVC.swift
//  OKTunes
//
//  Created by Önder Koşar on 12.09.2020.
//  Copyright © 2020 Önder Koşar. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit


class ItemInfoVC: OKDataLoadingVC {
    let contentView     = OKItemView(color: .darkGray, cornerRadius: 16, borderWidth: 4)
    
    let posterImgView   = OKImageView(content: .scaleAspectFit)
    let infoView        = OKItemView(color: .clear, cornerRadius: 10, borderWidth: 2)
    let overviewView    = UIView()
    
    var playBtn         = OKPlayButton()
    let iTunesBtn       = OKButton(backgroundColor: .darkGray, title: "iTunes Store")

    var videoPlayer     = AVPlayer()
    
    var result: AllResults!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
        configurePlayBtnInsets()
        configure()
        configureContentView()
        configureUIElements()
        configureButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        audioPlayer.pause()
    }
    
    
    private func configure() {
        view.addSubview(contentView)
        contentView.pinToEdges(of: view, by: 15)
    }
    
    private func configureContentView() {
        contentView.addSubviews(posterImgView, infoView, overviewView, playBtn, iTunesBtn)
        
        let posterHeight: CGFloat   = 140
        let posterWidth: CGFloat    = posterHeight * 27 / 40
        let padding: CGFloat        = 10
        
        NSLayoutConstraint.activate([
            posterImgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            posterImgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            posterImgView.widthAnchor.constraint(equalToConstant: posterWidth),
            posterImgView.heightAnchor.constraint(equalToConstant: posterHeight),
            
            infoView.topAnchor.constraint(equalTo: posterImgView.topAnchor),
            infoView.leadingAnchor.constraint(equalTo: posterImgView.trailingAnchor, constant: padding),
            infoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            infoView.bottomAnchor.constraint(equalTo: posterImgView.bottomAnchor, constant: -45),
            
            overviewView.topAnchor.constraint(equalTo: posterImgView.bottomAnchor, constant: padding),
            overviewView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            overviewView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            overviewView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),

            iTunesBtn.leadingAnchor.constraint(equalTo: posterImgView.trailingAnchor, constant: padding),
            iTunesBtn.widthAnchor.constraint(equalToConstant: 120),
            iTunesBtn.heightAnchor.constraint(equalToConstant: 40),
            iTunesBtn.bottomAnchor.constraint(equalTo: posterImgView.bottomAnchor)
        ])
    }
    
    private func configureUIElements() {
        posterImgView.downloadImage(fromURL: URL(string: result.artworkUrl100!)!)
        posterImgView.alpha = 0.8
        
        add(childVC: InfoVC(model: result), to: infoView)
        add(childVC: OverviewVC(model: result), to: overviewView)
    }
    
    private func configurePlayBtnInsets() {
        let btnTopInset     = posterImgView.frame.height + 110
        let btnLeftInset    = posterImgView.frame.height + 65
        playBtn             = OKPlayButton(topInset: -btnTopInset, leftInset: -btnLeftInset)
    }
    
    private func configureButtons() {
        playBtn.addTarget(self, action: #selector(playBtnPressed), for: .touchUpInside)
        iTunesBtn.addTarget(self, action: #selector(iTunesBtnPressed), for: .touchUpInside)
        
        playBtn.pinToEdges(of: posterImgView, by: 0)
        
        iTunesBtn.layer.borderWidth = 2
        iTunesBtn.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        childVC.view.frame = containerView.bounds
        containerView.addSubviews(childVC.view)
        childVC.view.pinToEdges(of: containerView, by: 0)
        childVC.didMove(toParent: self)
    }
    
    
    private func videoPlayerSetup() {
        if let url = URL(string: result.previewUrl!) {
            videoPlayer = AVPlayer(url: url)
            
            let vc      = AVPlayerViewController()
            vc.player   = videoPlayer
            present(vc, animated: true)
        }
    }
    
    @objc func playBtnPressed() {
        videoPlayerSetup()
        videoPlayer.play()
    }
    
    @objc func iTunesBtnPressed() {
        if let url = URL(string: result.trackViewUrl!) {
            UIApplication.shared.open(url)
        }
    }
}
