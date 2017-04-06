//
//  RepoDetailViewController.swift
//  GoGoGithub
//
//  Created by A Cahn on 4/5/17.
//  Copyright © 2017 A Cahn. All rights reserved.
//

import UIKit

class RepoDetailViewController: UIViewController {
    
    @IBOutlet weak var repoNameLabel: UILabel!
    
    @IBOutlet weak var repoDescriptionLabel: UILabel!
    
    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var starsLabel: UILabel!
    
    @IBOutlet weak var forkLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    var repo: Repository?
//    {
//        didSet {
//            if let repo = repo {
//                self.repoNameLabel.text = repo.name
//                self.repoDescriptionLabel.text = repo.description
//                self.languageLabel.text = repo.language
//                self.starsLabel.text = "Stars: \(repo.numberOfStars)"
//                self.forkLabel.text = repo.isFork ? "Forked" : "Not forked"
//                self.dateLabel.text = repo.createdAt
//            }
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let repo = repo {
            self.repoNameLabel.text = repo.name
            self.repoDescriptionLabel.text = repo.description
            self.languageLabel.text = repo.language
            self.starsLabel.text = "Stars: \(repo.numberOfStars)"
            self.forkLabel.text = repo.isFork ? "Forked" : "Not forked"
            self.dateLabel.text = "Date Created: \(repo.createdAt)"
        }
    }
    
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
