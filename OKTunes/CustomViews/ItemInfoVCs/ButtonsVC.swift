//
//  ButtonsVC.swift
//  OKTunes
//
//  Created by Önder Koşar on 13.09.2020.
//  Copyright © 2020 Önder Koşar. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class ButtonsVC: UIViewController {
    let previewBtn      = OKButton(backgroundColor: .darkGray, title: "Preview")
    let iTunesBtn       = OKButton(backgroundColor: .darkGray, title: "iTunes")
    
    var result: Results!

    init(model: Results) {
        super.init(nibName: nil, bundle: nil)
        self.result     = model
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        configureElements()
    }
    
    
    func configureElements() {
       previewBtn.addTarget(self, action: #selector(previewBtnPressed), for: .touchUpInside)
       iTunesBtn.addTarget(self, action: #selector(iTunesBtnPressed), for: .touchUpInside)
    }
    
    func configureLayout() {
        view.addSubviews(previewBtn, iTunesBtn)
        
        NSLayoutConstraint.activate([
            previewBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 2),
            previewBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 2),
            previewBtn.widthAnchor.constraint(equalToConstant: 150),
            previewBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -2),
            
            iTunesBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 2),
            iTunesBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -2),
            iTunesBtn.widthAnchor.constraint(equalToConstant: 150),
            iTunesBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -2)
        ])
    }
    
    @objc func previewBtnPressed() {
        if let url = URL(string: result.previewUrl!) {
            let player = AVPlayer(url: url)
            
            let vc = AVPlayerViewController()
            vc.player = player
            vc.player?.play()
            
            present(vc, animated: true)
        }
    }
    
    @objc func iTunesBtnPressed() {
        if let url = URL(string: result.trackViewUrl!) {
            UIApplication.shared.open(url)
        }
    }
}
