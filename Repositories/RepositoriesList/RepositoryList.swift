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
    private var repositoryList: NSMutableArray = []
    private var searchedRepositoryList: NSMutableArray = []
    private var paginationCountRepositories: Int = 1
    private var paginationCountSearchedRepositories: Int = 1
    private let searchController = UISearchController(searchResultsController: nil)
    private let spinner = UIActivityIndicatorView(style: .gray)
        
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
        
        navigationItem.title = "Repositories"
        
        networkService = NetworkService()
        getRepositories(page: paginationCountRepositories)

        spinner.center = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: view.center.y)
        self.view.addSubview(spinner)
    }
    
    func getRepositories(page: Int) {
        spinner.startAnimating()
        networkService.getRepositories(page: page,
                                       successHundler: { (array) in
                                        self.repositoryList.addObjects(from: array as! [Any])
                                        self.tableView.reloadData()
                                        self.spinner.stopAnimating()
        }) { (error) in
            print(error)
            self.spinner.stopAnimating()
        }
    }
    
    func getSearchedRepositories(page: Int) {
        spinner.startAnimating()
        self.networkService.getSearchedRepository(page: page,
                                                  nameRepository: searchController.searchBar.text!,
                                                  successHundler: { (array) in
                                                    self.searchedRepositoryList.addObjects(from: array as! [Any])
                                                    self.tableView.reloadData()
                                                    self.spinner.stopAnimating()
        }) { (error) in
            print(error)
            self.spinner.stopAnimating()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return searchedRepositoryList.count
        }
        return repositoryList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idRepositoryCell", for: indexPath) as! RepositoryCell
        if isFiltering() {
            cell.setup(model: Repository(map: searchedRepositoryList[indexPath.row] as AnyObject))
        } else {
            cell.setup(model: Repository(map: repositoryList[indexPath.row] as AnyObject))
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let repositoryInfoViewController = RepositoryInfoViewController()
        if isFiltering() {
            repositoryInfoViewController.repositoryInfo = RepositoryInfo(map: searchedRepositoryList[indexPath.row] as AnyObject)
        } else {
            repositoryInfoViewController.repositoryInfo = RepositoryInfo(map: repositoryList[indexPath.row] as AnyObject)
        }
        self.navigationController!.pushViewController(repositoryInfoViewController, animated: true)
    }
    
    override open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isFiltering() {
            if indexPath.row == searchedRepositoryList.count - 5 {
                paginationCountSearchedRepositories += 1
                getSearchedRepositories(page: paginationCountSearchedRepositories)
            }
        } else {
            if indexPath.row == repositoryList.count - 5 {
                paginationCountRepositories += 1
                getRepositories(page: paginationCountRepositories)
            }
        }
        
    }
    
    // MARK: - Search controller

    func updateSearchResults(for searchController: UISearchController) {
        if (searchController.searchBar.text?.count)! > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.getSearchedRepositories(page: self.paginationCountSearchedRepositories)
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
