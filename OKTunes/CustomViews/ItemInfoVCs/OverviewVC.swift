//
//  OverviewVC.swift
//  OKTunes
//
//  Created by Önder Koşar on 13.09.2020.
//  Copyright © 2020 Önder Koşar. All rights reserved.
//

import UIKit

class OverviewVC: UIViewController {
    let descriptionLbl  = OKSecondaryTitleLabel(fontSize: 16)
    
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
    }
    
    
    private func configureElements() {
        descriptionLbl.text                         = result.longDescription
        descriptionLbl.adjustsFontSizeToFitWidth    = true
        descriptionLbl.minimumScaleFactor           = 0.6
        descriptionLbl.textAlignment                = .justified
        descriptionLbl.numberOfLines                = 50
    }
    
    private func configure() {
        view.addSubviews(descriptionLbl)
        
        NSLayoutConstraint.activate([
            descriptionLbl.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            descriptionLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            descriptionLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            descriptionLbl.heightAnchor.constraint(lessThanOrEqualToConstant: 500)
        ])
    }
}
