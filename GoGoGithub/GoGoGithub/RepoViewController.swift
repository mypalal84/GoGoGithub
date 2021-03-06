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
        // initialize your nib
        let repoXib = UINib(nibName: RepoTableViewCell.identifier, bundle: Bundle.main)
        // register your cell xib file
        self.tableView.register(repoXib, forCellReuseIdentifier: RepoTableViewCell.identifier)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        update()
    }
    
    func update() {

        GitHub.shared.getRepos { (repositories) in
            //update tableView
            guard let repositories = repositories else { return }
                self.repos = repositories
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let destination = segue.destination as? RepoDetailViewController else {
            return
        }
        
        if segue.identifier == RepoDetailViewController.identifier {
            
            destination.transitioningDelegate = self
            if let selectedIndex = self.tableView.indexPathForSelectedRow {

                destination.repo = self.repos[selectedIndex.row]
            }
        }
    }
}

//MARK: UIViewControllerTransitioningDelegate

extension RepoViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return CustomTransition(duration: 1.0)
        
    }
}


//MARK: UITableViewDelegate

extension RepoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayRepos?.count ?? repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepoTableViewCell.identifier, for: indexPath) as! RepoTableViewCell
        
        cell.repoNameLabel.text = displayRepos?[indexPath.row].name ?? repos[indexPath.row].name
        cell.descriptionLabel.text = displayRepos?[indexPath.row].description ?? repos[indexPath.row].description
        cell.languageLabel.text = displayRepos?[indexPath.row].language ??
            repos[indexPath.row].language
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: RepoDetailViewController.identifier, sender: nil)
    }
}

//MARK: UISearchBarDelegate

extension RepoViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if !searchText.validate() {
            let lastIndex = searchText.index(before: searchText.endIndex)
            
            searchBar.text = searchText.substring(to: lastIndex)
//            print(searchText)
            
        }
        
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
