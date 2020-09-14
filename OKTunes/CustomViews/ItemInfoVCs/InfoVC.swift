//
//  InvoVC.swift
//  OKTunes
//
//  Created by Önder Koşar on 13.09.2020.
//  Copyright © 2020 Önder Koşar. All rights reserved.
//

import UIKit

class InfoVC: UIViewController {
    let movieLbl        = OKTitleLabel(textAlignment: .left, fontSize: 18)
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
        configureLayout()
        configureElements()
    }
    
    
    func configureElements() {
        movieLbl.text       = result.trackName
        directorLbl.text    = "Director: " + (result.artistName ?? "NA")
        releaseDateLbl.text = "Rel Date: " + result.date
    }
    
    func configureLayout() {
        view.addSubviews(movieLbl, directorLbl, releaseDateLbl)
        
        NSLayoutConstraint.activate([
            movieLbl.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            movieLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            movieLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            movieLbl.heightAnchor.constraint(equalToConstant: 20),
            
            directorLbl.topAnchor.constraint(equalTo: movieLbl.bottomAnchor, constant: 2),
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
