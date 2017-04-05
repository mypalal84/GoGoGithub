//
//  RepoViewController.swift
//  GoGoGithub
//
//  Created by A Cahn on 4/4/17.
//  Copyright © 2017 A Cahn. All rights reserved.
//

import UIKit

class RepoViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    

    @IBOutlet weak var searchBar: UISearchBar!
    
    var repos = [Repository]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var displayRepos : [Repository]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
        // Do any additional setup after loading the view.
        update()
    }
    
    func update() {

        GitHub.shared.getRepos { (repositories) in
            //update tableView
            guard let repositories = repositories else { return }
                self.repos = repositories
//                self.tableView.reloadData()
            
        }
    }
}
//MARK: UITableViewDelegate

extension RepoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayRepos?.count ?? repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell", for: indexPath) as! RepoTableViewCell
        
        cell.repoNameLabel.text = displayRepos?[indexPath.row].name ?? repos[indexPath.row].name
        cell.descriptionLabel.text = displayRepos?[indexPath.row].description ?? repos[indexPath.row].description
        cell.languageLabel.text = displayRepos?[indexPath.row].language ??
            repos[indexPath.row].language
        
        
        return cell
    }
}

extension RepoViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if let searchedText = searchBar.text {
            
            self.displayRepos = self.repos.filter({$0.name.contains(searchedText)})
        }
        
        if searchBar.text == "" {
            self.displayRepos = nil
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.displayRepos = nil
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
}
