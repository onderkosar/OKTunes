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
    let overviewView    = OKItemView(color: .clear, cornerRadius: 10, borderWidth: 2)
    
    let playBtn         = OKButton(backgroundColor: .clear, title: "")
    let stopBtn         = OKButton(backgroundColor: .clear, title: "")
    let iTunesBtn       = OKButton(backgroundColor: .darkGray, title: "iTunes Store")
    
    var audioPlayer     = AVAudioPlayer()
    var videoPlayer     = AVPlayer()
    
    var isMovie         = true
    
    var result: AllResults!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
        configureViewLayout()
        configureContentViewLayout()
        configureUIElements()
    }
    
    private func configureViewLayout() {
        view.addSubview(contentView)
        contentView.pinToEdges(of: view, by: 15)
    }
    
    private func configureContentViewLayout() {
        contentView.addSubviews(posterImgView, infoView, overviewView, playBtn, stopBtn, iTunesBtn)
        
        let padding: CGFloat        = 10
        
        NSLayoutConstraint.activate([
            posterImgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            posterImgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            
            playBtn.centerXAnchor.constraint(equalTo: posterImgView.centerXAnchor),
            playBtn.centerYAnchor.constraint(equalTo: posterImgView.centerYAnchor),
            playBtn.widthAnchor.constraint(equalToConstant: 60),
            playBtn.heightAnchor.constraint(equalToConstant: 60),
            
            stopBtn.centerXAnchor.constraint(equalTo: posterImgView.centerXAnchor),
            stopBtn.centerYAnchor.constraint(equalTo: posterImgView.centerYAnchor),
            stopBtn.widthAnchor.constraint(equalToConstant: 60),
            stopBtn.heightAnchor.constraint(equalToConstant: 60),
            
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
        
        if !isMovie {
            overviewView.isHidden = true
            NSLayoutConstraint.activate([
                posterImgView.widthAnchor.constraint(equalToConstant: 140),
                posterImgView.heightAnchor.constraint(equalToConstant: 140)
            ])
            audioPlayerSetup()
        } else {
            let posterHeight: CGFloat   = 140
            let posterWidth: CGFloat    = posterHeight * 27 / 40
            
            NSLayoutConstraint.activate([
                posterImgView.widthAnchor.constraint(equalToConstant: posterWidth),
                posterImgView.heightAnchor.constraint(equalToConstant: posterHeight),
            ])
            
        }
    }
    
    func configureUIElements() {
        posterImgView.downloadImage(fromURL: URL(string: result.artworkUrl100!)!)
        
        playBtn.addTarget(self, action: #selector(playBtnPressed), for: .touchUpInside)
        stopBtn.addTarget(self, action: #selector(stopBtnPressed), for: .touchUpInside)
        iTunesBtn.addTarget(self, action: #selector(iTunesBtnPressed), for: .touchUpInside)
        
        add(childVC: InfoVC(model: result), to: infoView)
        add(childVC: OverviewVC(model: result), to: overviewView)
        
        posterImgView.alpha = 0.8
        playBtn.tintColor   = .black
        stopBtn.tintColor   = .lightGray
        
        iTunesBtn.setBackgroundImage(SFSymbols.iTunes, for: .normal)
        iTunesBtn.layer.borderWidth   = 2
        iTunesBtn.layer.borderColor   = UIColor.lightGray.cgColor
        
        playBtn.setBackgroundImage(SFSymbols.play, for: .normal)
        stopBtn.setBackgroundImage(SFSymbols.pause, for: .normal)
        
        playBtn.isHidden = false
        stopBtn.isHidden = true
        
    }
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
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
    
    private func audioPlayerSetup() {
        if let url = URL(string: result.previewUrl!) {
            do {
                let songData = try NSData(contentsOf: url, options: NSData.ReadingOptions.mappedIfSafe)
                try AVAudioSession.sharedInstance().setCategory(.playback)
                try AVAudioSession.sharedInstance().setActive(true)
                
                audioPlayer = try AVAudioPlayer(data: songData as Data, fileTypeHint: AVFileType.mp3.rawValue)
                
                audioPlayer.prepareToPlay()
            } catch { print(error) }
        }
    }
    
    @objc func playBtnPressed() {
        
        if isMovie {
            videoPlayerSetup()
            videoPlayer.play()
        } else {
            playBtn.isHidden = true
            stopBtn.isHidden = false
            audioPlayer.stop()
            audioPlayer.play()
        }
        
    }
    
    @objc func stopBtnPressed() {
        playBtn.isHidden = false
        stopBtn.isHidden = true
        audioPlayer.stop()
        audioPlayer.stop()
    }
    
    @objc func iTunesBtnPressed() {
        if let url = URL(string: result.trackViewUrl!) {
            UIApplication.shared.open(url)
        }
    }
}
