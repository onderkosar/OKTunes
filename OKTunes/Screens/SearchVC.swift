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
    
    var movieSelected       = false
    var urlString           = URLStrings.artistName
    
    let disposebag          = DisposeBag()
    var dataSource          = BehaviorRelay(value: [AllResults]())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configure()
        configureSegControl()
        configureTableView()
        configureSearchBar()
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
        tableView.frame                 = view.bounds
        tableView.separatorStyle        = .none
        tableView.rowHeight             = 40
        tableView.keyboardDismissMode   = .onDrag
        
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.reuseID)
        
        self.tableView
            .rx
            .itemSelected
            .subscribe(onNext: { [weak self ] (indexPath) in
                guard let strongSelf = self else { return }
                strongSelf.rxCellTapped(on: indexPath)
            }).disposed(by: disposebag)
    }
    
    private func configureSearchBar() {
        searchBar.sizeToFit()
        searchBar.placeholder           = NSLocalizedString("search musics by artist name", comment: "")
        searchBar.showsCancelButton     = true
        navigationItem.titleView        = searchBar
        
        self.searchBar
            .rx
            .text
            .orEmpty
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self ](text) in
                guard let strongSelf = self else { return }
                strongSelf.rxSearchCall(for: text)
            }).disposed(by: disposebag)
        
        self.searchBar
            .rx
            .cancelButtonClicked
            .subscribe(onNext: { [weak self ](text) in
                guard let strongSelf = self else { return }
                strongSelf.searchBar.endEditing(true)
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
        
        rxDataBinding()
    }
    
    func rxSearchCall(for text: String) {
        let remainingValue      = "&term=" + text.replaceSpaceWithPlus()
        let urlString           = self.urlString + remainingValue
        
        getModel(from: urlString).flatMap { allResults -> Observable<[AllResults]> in
            self.searchResultsArray = allResults.results
            return Observable.just(allResults.results)
        }.subscribe(onNext: { model in
            self.dataSource.accept(model)

        }).disposed(by: disposebag)
    }
    
    func rxCellTapped(on indexPath: IndexPath) {
        let searchResult            = searchResultsArray[indexPath.row]
        
        if movieSelected {
            let destinationVC       = ItemInfoVC()
            destinationVC.result    = searchResult
            
            self.present(destinationVC, animated: true, completion: nil)
            
        } else {
            let remainingValue      = "&term=\(searchResult.artistName!.replaceSpaceWithPlus())"
            let urlString           = URLStrings.songByArtistName + remainingValue
            let destinationVC       = MusicVC()
            
            getModel(from: urlString).flatMap { fetchModel -> Observable<FetchModel> in
                return Observable.just(fetchModel)
            }.subscribe(onNext: { model in
                destinationVC.resultsArray.append(contentsOf: model.results)
                
                DispatchQueue.main.async {
                    self.present(destinationVC, animated: true, completion: nil)
                }
                
            }).disposed(by: disposebag)
        }
    }
    
    func rxDataBinding() {
        dataSource.bind(to: tableView.rx.items(cellIdentifier: SearchTableViewCell.reuseID, cellType: SearchTableViewCell.self)) {
            index, search, cell in
            cell.selectionStyle = .none
            
            if self.movieSelected {
                cell.set(with: search.trackName!)
            } else {
                cell.set(with: search.artistName!)
            }
            
        }.disposed(by: disposebag)
    }
    
    func getModel(from urlString: String) -> Observable<FetchModel> {
        return NetworkManager.shared.fetch(from: urlString)
    }
    
    @objc func switchSegControl(sender: UISegmentedControl) {
        dataSource.accept([])
        
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
