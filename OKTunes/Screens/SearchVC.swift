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
    
    var onderArray          = [SearchResults]()
    let disposebag          = DisposeBag()
    
    var movieSelected       = false
    var urlString           = URLStrings.artistName
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        configureLayout()
        configureSegControl()
        configureTableView()
        configureSearchBar()
        searchBarFunc()
    }
    
    
    private func configureLayout() {
        view.addSubviews(segmentedControl, tableView)
        
        NSLayoutConstraint.activate([
            segmentedControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentedControl.widthAnchor.constraint(equalToConstant: 200),
            segmentedControl.heightAnchor.constraint(equalToConstant: 40),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: segmentedControl.topAnchor, constant: -5)
        ])
    }
    
    private func configureSegControl() {
        segmentedControl.selectedSegmentIndex   = 0
        segmentedControl.backgroundColor        = .darkGray
        segmentedControl.layer.borderWidth      = 2
        segmentedControl.layer.borderColor      = UIColor.white.cgColor
        segmentedControl.addTarget(self, action: #selector(switchSegControl), for: .valueChanged)
    }
    
    private func configureTableView() {
        tableView.frame         = view.bounds
        tableView.rowHeight     = 40
        tableView.delegate      = self
        tableView.dataSource    = self
        
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
            .throttle(0.3, scheduler: MainScheduler.instance)
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
                strongSelf.onderArray.removeAll()
                DispatchQueue.main.async {
                    strongSelf.tableView.reloadData()
                }
            }).disposed(by: disposebag)
    }
    
    func searchItunes(text: String) {
        NetworkManager.shared.fetch(from: urlString + "&term=" + text) { (model: SearchModel) in
            self.updateUI(with: model.results)
        }
    }
    
    func updateUI(with resultsArray : [SearchResults]) {
        self.onderArray.removeAll()
        self.onderArray.append(contentsOf: resultsArray)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc func switchSegControl(sender: UISegmentedControl) {
        onderArray.removeAll()
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
        return onderArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell            = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reuseID) as! SearchTableViewCell
        let searchResult    = onderArray[indexPath.row]
        
        if movieSelected {
            cell.set(with: searchResult.trackName!)
        } else {
            cell.set(with: searchResult.artistName!)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchResult    = onderArray[indexPath.row]
        let destVC          = MusicVC()
        
        let navController   = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
    }
}
