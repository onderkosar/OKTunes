//
//  ItemInfoVC.swift
//  OKTunes
//
//  Created by Önder Koşar on 12.09.2020.
//  Copyright © 2020 Önder Koşar. All rights reserved.
//

import UIKit
import AVFoundation


class ItemInfoVC: OKDataLoadingVC {
    let titleLabel          = OKTitleLabel(textAlignment: .center, fontSize: 18)
    let previewView         = UIView()
    let descriptionView     = OKSecondaryTitleLabel(fontSize: 16)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
        
        configureElements()
        configureUI()
    }
    
    
    private func configureElements() {
        titleLabel.adjustsFontSizeToFitWidth    = true
        
        descriptionView.textAlignment           = .justified
        descriptionView.numberOfLines           = 30
    }
    
    func set(with result: Results) {
        titleLabel.text = result.trackName
        showPLayer(urlString: result.previewUrl ?? "N/A")
        descriptionView.text = result.longDescription
    }
    
    private func configureUI() {
        view.addSubviews(titleLabel, previewView, descriptionView)
        
        NSLayoutConstraint.activate([
            previewView.topAnchor.constraint(equalTo: view.topAnchor),
            previewView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            previewView.widthAnchor.constraint(equalToConstant: view.frame.width),
            previewView.heightAnchor.constraint(equalToConstant: view.frame.width * 9 / 16),
            
            titleLabel.topAnchor.constraint(equalTo: previewView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            descriptionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            descriptionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
            ])
    }
    
    func showPLayer(urlString: String) {
            if let url = URL(string: urlString) {
                let player = AVPlayer(url: url)
                let playerLayer = AVPlayerLayer(player: player)
                previewView.layer.addSublayer(playerLayer)
//                playerLayer.frame = previewView.frame
                playerLayer.frame = CGRect(x: 5, y: 5, width: view.frame.width - 10, height: (view.frame.width * 9 / 16) - 10)
                
                player.play()
            }
        }
}
