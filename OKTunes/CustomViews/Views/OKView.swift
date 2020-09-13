//
//  OKView.swift
//  OKTunes
//
//  Created by Önder Koşar on 13.09.2020.
//  Copyright © 2020 Önder Koşar. All rights reserved.
//

import UIKit

class OKItemView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(color: UIColor , cornerRadius: CGFloat, borderWidth: CGFloat) {
        self.init(frame: .zero)
        backgroundColor       = color
        layer.cornerRadius    = cornerRadius
        layer.borderWidth     = borderWidth
        layer.borderColor     = UIColor.lightGray.cgColor
        
    }
}
