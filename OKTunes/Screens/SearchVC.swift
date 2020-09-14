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
    var searchBar   = UISearchBar()
    var tableView   = UITableView()
    
    var searchArray = [ArtistResults]()
    let disposebag  = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        setupSearchBar()
        searchBarFunc()
        configureTableView()
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.pinToEdges(of: view, by: 0)
        
        tableView.frame         = view.bounds
        tableView.rowHeight     = 40
        tableView.delegate      = self
        tableView.dataSource    = self
        
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.reuseID)
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
                strongSelf.searchItunesMusic(text: text)
            }).disposed(by: disposebag)
        
        self.searchBar
            .rx
            .text
            .ifEmpty(default: "")
            .subscribe(onNext: { [weak self ](text) in
                guard let strongSelf = self else { return }
                strongSelf.searchArray.removeAll()
                DispatchQueue.main.async {
                    strongSelf.tableView.reloadData()
                }
            }).disposed(by: disposebag)
        
        self.searchBar
            .rx
            .cancelButtonClicked
            .subscribe(onNext: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.searchBar.resignFirstResponder()
            }).disposed(by: disposebag)
    }
    
    func setupSearchBar() {
        searchBar.sizeToFit()
        searchBar.showsCancelButton = true
        searchBar.placeholder       = NSLocalizedString("search", comment: "")
        navigationItem.titleView    = searchBar
    }
    
    func searchItunesMusic(text: String) {
        NetworkManager.shared.fetch(from: URLStrings.artistName + "&term=" + text) { (musics: ArtistModel) in
            self.updateUI(with: musics.results)
        }
    }
    
    func updateUI(with resultsArray : [ArtistResults]) {
        self.searchArray.removeAll()
        self.searchArray.append(contentsOf: resultsArray)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}


extension SearchVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell            = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reuseID) as! SearchTableViewCell
        let searchResult        = searchArray[indexPath.row]
        cell.set(with: searchResult)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchResult    = searchArray[indexPath.row]
        let destVC          = MusicVC()
        
        let navController   = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
    }
}
