//
//  RepoDetailViewController.swift
//  GoGoGithub
//
//  Created by A Cahn on 4/5/17.
//  Copyright © 2017 A Cahn. All rights reserved.
//

import UIKit
import SafariServices

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
    
    @IBAction func moreDetailsPressed(_ sender: Any) {
        
        guard let repo = repo else { return }
        
        presentSafariViewControllerWith(urlString: repo.repoURLString)
//        presentWebViewControllerWith(urlString: repo.repoURLString)
        
    }
    
        func presentSafariViewControllerWith(urlString: String) {
            
            guard let url = URL(string: urlString) else { return }
            
            let safariController = SFSafariViewController(url: url)
            
            self.present(safariController, animated: true, completion: nil)
            
    }
    
    func presentWebViewControllerWith(urlString: String) {
        
        let webController = WebViewController()
        webController.url = urlString
        
        self.present(webController, animated: true, completion: nil)
        
    }
    
}
