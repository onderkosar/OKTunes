//
//  NamePractTVCell.swift
//  OKTunes
//
//  Created by Önder Koşar on 14.09.2020.
//  Copyright © 2020 Önder Koşar. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    static let reuseID  = "namePractTVCell"
    let artistNameLbl   = OKTitleLabel(textAlignment: .left, fontSize: 13)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(with result: ArtistResults) {
        artistNameLbl.text   = result.artistName
    }
    
    private func configure() {
        addSubviews(artistNameLbl)
        artistNameLbl.backgroundColor = .clear
        artistNameLbl.pinToEdges(of: contentView, by: 0)
    }

}
