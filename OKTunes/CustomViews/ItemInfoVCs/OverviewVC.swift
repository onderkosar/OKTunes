//
//  OverviewVC.swift
//  OKTunes
//
//  Created by Önder Koşar on 13.09.2020.
//  Copyright © 2020 Önder Koşar. All rights reserved.
//

import UIKit

class OverviewVC: UIViewController {
    let titleLbl        = OKTitleLabel(textAlignment: .left, fontSize: 16)
    let descriptionLbl  = OKSecondaryTitleLabel(fontSize: 16)
    
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
        titleLbl.text                               = "Long description;"
        
        descriptionLbl.text                         = result.longDescription
        descriptionLbl.adjustsFontSizeToFitWidth    = true
        descriptionLbl.minimumScaleFactor           = 0.6
        descriptionLbl.textAlignment                = .justified
        descriptionLbl.numberOfLines                = 50
    }
    
    func configureLayout() {
        view.addSubviews(titleLbl, descriptionLbl)
        
        NSLayoutConstraint.activate([
            titleLbl.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            titleLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            titleLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            titleLbl.heightAnchor.constraint(lessThanOrEqualToConstant: 18),
            
            descriptionLbl.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 5),
            descriptionLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            descriptionLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            descriptionLbl.heightAnchor.constraint(lessThanOrEqualToConstant: 260)
        ])
    }
}
