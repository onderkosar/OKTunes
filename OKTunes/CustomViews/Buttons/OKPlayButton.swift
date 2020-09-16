//
//  OKPlayButton.swift
//  OKTunes
//
//  Created by Önder Koşar on 16.09.2020.
//  Copyright © 2020 Önder Koşar. All rights reserved.
//

import UIKit

class OKPlayButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(topInset: CGFloat, leftInset: CGFloat) {
        self.init(frame: .zero)
        imageEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: 0, right: 0)
    }
    
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        setImage(SFSymbols.play, for: .normal)
        
        backgroundColor             = .clear
        alpha                       = 0.8
        tintColor                   = .black
        clipsToBounds               = true
        imageView?.backgroundColor  = .white
    }
}
