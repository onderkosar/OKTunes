//
//  ItemInfoVC.swift
//  OKTunes
//
//  Created by Önder Koşar on 12.09.2020.
//  Copyright © 2020 Önder Koşar. All rights reserved.
//

import UIKit


class ItemInfoVC: OKDataLoadingVC {
    let contentView     = OKItemView(color: .darkGray, cornerRadius: 16, borderWidth: 4)
    
    let posterImgView   = OKImageView(content: .scaleAspectFit)
    let infoView        = OKItemView(color: .clear, cornerRadius: 10, borderWidth: 2)
    let overviewView    = OKItemView(color: .clear, cornerRadius: 10, borderWidth: 2)
    let buttonsView     = OKItemView(color: .lightGray, cornerRadius: 10, borderWidth: 2)
    
    var result: Results!

    
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
        contentView.addSubviews(posterImgView, infoView, overviewView, buttonsView)
        
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
            infoView.bottomAnchor.constraint(equalTo: posterImgView.bottomAnchor),
            
            overviewView.topAnchor.constraint(equalTo: posterImgView.bottomAnchor, constant: padding),
            overviewView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            overviewView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            overviewView.heightAnchor.constraint(equalToConstant: 400),

            buttonsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            buttonsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            buttonsView.heightAnchor.constraint(equalToConstant: 45),
            buttonsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
            
        ])
    }
    
    func configureUIElements() {
        posterImgView.downloadImage(fromURL: URL(string: result.artworkUrl100)!)
        
        add(childVC: InfoVC(model: result), to: infoView)
        add(childVC: OverviewVC(model: result), to: overviewView)
        add(childVC: ButtonsVC(model: result), to: buttonsView)
    }
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
}
