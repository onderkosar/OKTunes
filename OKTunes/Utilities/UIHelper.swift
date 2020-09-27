//
//  UIHelper.swift
//  OKTunes
//
//  Created by Önder Koşar on 27.09.2020.
//  Copyright © 2020 Önder Koşar. All rights reserved.
//

import UIKit

enum UIHelper {
    static func itemWidthFor(column numb: CGFloat, in view: UIView) -> CGFloat {
        let width: CGFloat                  = view.bounds.width
        let padding: CGFloat                = width / 35
        let minimumItemSpacing: CGFloat     = width / 25
        
        let availableWidth: CGFloat         = width - (padding * numb) - (minimumItemSpacing * (numb - 1))
        let itemWidht: CGFloat              = availableWidth / numb
        return itemWidht
    }
    
    static func createFlowLayoutFor(columns numb: CGFloat, in view: UIView) -> UICollectionViewFlowLayout {
        let width: CGFloat                  = view.bounds.width
        let height: CGFloat                 = view.bounds.height
        let padding: CGFloat                = width / 35
        
        let itemWidht: CGFloat              = itemWidthFor(column: numb , in: view)
        let itemHeight: CGFloat             = height / 10
        
        let flowLayout                      = UICollectionViewFlowLayout()
        flowLayout.sectionInset             = UIEdgeInsets(top: padding, left: padding / 2, bottom: padding, right: padding / 2)
        flowLayout.itemSize                 = CGSize(width: itemWidht, height: itemHeight)
        
        return flowLayout
    }
}
