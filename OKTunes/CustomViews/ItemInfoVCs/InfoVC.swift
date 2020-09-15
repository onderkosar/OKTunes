//
//  InvoVC.swift
//  OKTunes
//
//  Created by Önder Koşar on 13.09.2020.
//  Copyright © 2020 Önder Koşar. All rights reserved.
//

import UIKit

class InfoVC: UIViewController {
    let movieTitleLbl   = OKTitleLabel(textAlignment: .left, fontSize: 18)
    let directorLbl     = OKSecondaryTitleLabel(fontSize: 15)
    let releaseDateLbl  = OKSecondaryTitleLabel(fontSize: 12)
    
    var result: AllResults!

    init(model: AllResults) {
        super.init(nibName: nil, bundle: nil)
        self.result     = model
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureElements()
        set()
    }
    
    
    private func configureElements() {
        movieTitleLbl.adjustsFontSizeToFitWidth = true
        movieTitleLbl.numberOfLines             = 2
        movieTitleLbl.minimumScaleFactor        = 0.7
    }
    
    private func set() {
        movieTitleLbl.text                      = result.trackName
        directorLbl.text                        = result.artistName ?? "NA"
        releaseDateLbl.text                     = "Rel Date: " + result.date
    }
    
    private func configure() {
        view.addSubviews(movieTitleLbl, directorLbl, releaseDateLbl)
        
        NSLayoutConstraint.activate([
            movieTitleLbl.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            movieTitleLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            movieTitleLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            movieTitleLbl.heightAnchor.constraint(equalToConstant: 30),
            
            directorLbl.topAnchor.constraint(equalTo: movieTitleLbl.bottomAnchor, constant: 2),
            directorLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            directorLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            directorLbl.heightAnchor.constraint(equalToConstant: 17),

            releaseDateLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            releaseDateLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            releaseDateLbl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            releaseDateLbl.heightAnchor.constraint(equalToConstant: 15)
        ])
    }
}
