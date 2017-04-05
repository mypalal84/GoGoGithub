//
//  RepoViewController.swift
//  GoGoGithub
//
//  Created by A Cahn on 4/4/17.
//  Copyright © 2017 A Cahn. All rights reserved.
//

import UIKit

class RepoViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var repos = [Repository]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
        update()
    }
    
    func update() {
        print("update repo controller here!")
        
        GitHub.shared.getRepos { (repositories) in
            //update tableView
            if let repositories = repositories {
                self.repos = repositories
                self.tableView.reloadData()
            }
        }
    }
}
//MARK: UITableViewDelegate

extension RepoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell", for: indexPath) as! RepoTableViewCell
        
        cell.repoNameLabel.text = repos[indexPath.row].name
        
        return cell
    }
}
