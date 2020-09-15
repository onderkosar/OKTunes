//
//  SearchPractVC.swift
//  OKTunes
//
//  Created by Önder Koşar on 14.09.2020.
//  Copyright © 2020 Önder Koşar. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchVC: OKDataLoadingVC {
    var segmentedControl    = UISegmentedControl(items: segmentedItems)
    var tableView           = UITableView()
    var searchBar           = UISearchBar()
    
    var searchResultsArray  = [AllResults]()
    let disposebag          = DisposeBag()
    
    var movieSelected       = false
    var urlString           = URLStrings.artistName
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configure()
        configureSegControl()
        configureTableView()
        configureSearchBar()
        searchBarFunc()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        audioPlayer.pause()
    }
    
    
    private func configure() {
        view.addSubviews(segmentedControl, tableView)
        
        NSLayoutConstraint.activate([
            segmentedControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentedControl.widthAnchor.constraint(equalToConstant: 200),
            segmentedControl.heightAnchor.constraint(equalToConstant: 40),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: segmentedControl.topAnchor, constant: -5)
        ])
    }
    
    private func configureSegControl() {
        segmentedControl.selectedSegmentIndex   = 0
        segmentedControl.backgroundColor        = .darkGray
        segmentedControl.layer.borderWidth      = 2
        segmentedControl.layer.borderColor      = UIColor.darkGray.cgColor
        segmentedControl.addTarget(self, action: #selector(switchSegControl), for: .valueChanged)
    }
    
    private func configureTableView() {
        tableView.frame             = view.bounds
        tableView.separatorStyle    = .none
        tableView.rowHeight         = 40
        tableView.delegate          = self
        tableView.dataSource        = self
        
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.reuseID)
    }
    
    private func configureSearchBar() {
        searchBar.sizeToFit()
        searchBar.placeholder       = NSLocalizedString("search musics by artist name", comment: "")
        navigationItem.titleView    = searchBar
    }
    
    func searchBarFunc() {
        self.searchBar
            .rx
            .text
            .orEmpty
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .filter { $0.count > 2 }
            .subscribe(onNext: { [weak self ](text) in
                guard let strongSelf = self else { return }
                strongSelf.searchItunes(text: text)
            }).disposed(by: disposebag)
        
        self.searchBar
            .rx
            .text
            .ifEmpty(default: "")
            .subscribe(onNext: { [weak self ](text) in
                guard let strongSelf = self else { return }
                strongSelf.searchResultsArray.removeAll()
                DispatchQueue.main.async {
                    strongSelf.tableView.reloadData()
                }
            }).disposed(by: disposebag)
    }
    
    func searchItunes(text: String) {
        let remainingValue  = "&term=" + text.replaceSpaceWithPlus()
        
        NetworkManager.shared.fetch(from: urlString + remainingValue) { (model: FetchModel) in
            self.updateUI(with: model.results)
        }
    }
    
    func updateUI(with resultsArray : [AllResults]) {
        self.searchResultsArray.removeAll()
        self.searchResultsArray.append(contentsOf: resultsArray)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc func switchSegControl(sender: UISegmentedControl) {
        searchResultsArray.removeAll()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        switch sender.selectedSegmentIndex {
        case 1:
            searchBar.placeholder   = NSLocalizedString("search movies by movie name", comment: "")
            searchBar.text          = ""
            urlString               = URLStrings.movieName
            movieSelected           = true
        default:
            searchBar.placeholder   = NSLocalizedString("search musics by artist name", comment: "")
            searchBar.text          = ""
            urlString               = URLStrings.artistName
            movieSelected           = false
        }
    }
}


extension SearchVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell            = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reuseID) as! SearchTableViewCell
        let searchResult    = searchResultsArray[indexPath.row]
        
        if movieSelected {
            cell.set(with: searchResult.trackName!)
        } else {
            cell.set(with: searchResult.artistName!)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchResult    = searchResultsArray[indexPath.row]
        if movieSelected {
            let destVC          = ItemInfoVC()
            destVC.result       = searchResult
            
            let navController   = UINavigationController(rootViewController: destVC)
            present(navController, animated: true)
        } else {
            let remainingValue  = "&term=\(searchResult.artistName!.replaceSpaceWithPlus())"
            let urlString       = URLStrings.songByArtistName + remainingValue
            let destVC          = MusicVC()
            destVC.pushedBySearchVC = true
            
            NetworkManager.shared.fetch(from: urlString) { (model: FetchModel) in
                destVC.resultsArray.append(contentsOf: model.results)
            }
            
            let navController   = UINavigationController(rootViewController: destVC)
            present(navController, animated: true)
        }
    }
}
