//
//  RepoViewController.swift
//  GoGoGithub
//
//  Created by A Cahn on 4/4/17.
//  Copyright © 2017 A Cahn. All rights reserved.
//

import UIKit

class RepoViewController: UIViewController, UISearchBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        update()
    }
    
    func update() {
        print("update repo controller here!")
        
        GitHub.shared.getRepos { (repositories) in
            //update tableView
        }
    }

}
