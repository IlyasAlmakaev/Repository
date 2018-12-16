//
//  RepositoryList.swift
//  Repositories
//
//  Created by Ильяс on 15/12/2018.
//  Copyright © 2018 Алмакаев Ильяс. All rights reserved.
//

import UIKit

class RepositoryList: UITableViewController, UISearchResultsUpdating {

    private var networkService: NetworkService!
    private var repositoryList: NSArray?
    private var searchedRepositoryList: NSArray?
    private let searchController = UISearchController(searchResultsController: nil)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "RepositoryCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "idRepositoryCell")
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search repositories"
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
        definesPresentationContext = true
        
        networkService = NetworkService()
        networkService.getRepositories(successHundler: { (array) in
            self.repositoryList = array
            self.tableView.reloadData()
        }) { (error) in
            print(error)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return searchedRepositoryList?.count ?? 0
        }
        return repositoryList?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idRepositoryCell", for: indexPath) as! RepositoryCell
        if isFiltering() {
            cell.setup(model: Repository(map: searchedRepositoryList?[indexPath.row] as AnyObject))
        } else {
            cell.setup(model: Repository(map: repositoryList?[indexPath.row] as AnyObject))
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let repositoryInfoViewController = RepositoryInfoViewController()
        if isFiltering() {
            repositoryInfoViewController.repositoryInfo = RepositoryInfo(map: searchedRepositoryList?[indexPath.row] as AnyObject)
        } else {
            repositoryInfoViewController.repositoryInfo = RepositoryInfo(map: repositoryList?[indexPath.row] as AnyObject)
        }
        self.navigationController!.pushViewController(repositoryInfoViewController, animated: true)
    }
    
    // MARK: - Search controller

    func updateSearchResults(for searchController: UISearchController) {
        if (searchController.searchBar.text?.count)! > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.networkService.getSearchedRepository(nameRepository: searchController.searchBar.text!,
                                                          successHundler: { (array) in
                                                            self.searchedRepositoryList = array
                                                            self.tableView.reloadData()
                }) { (error) in
                    print(error)
                }
            }
        } else {
            self.searchedRepositoryList = []
            self.tableView.reloadData()
        }
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
}
