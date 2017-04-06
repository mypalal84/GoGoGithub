//
//  Repository.swift
//  GoGoGithub
//
//  Created by A Cahn on 4/4/17.
//  Copyright © 2017 A Cahn. All rights reserved.
//

import Foundation

class Repository {
    
    let name: String
    let numberOfStars: Int
    let isFork: Bool
    let createdAt: String
    
    let description: String?
    let language: String?
    
    init?(json: [String: Any]) {
        
        if let name = json["name"] as? String, let numberOfStars = json["stargazers_count"] as? Int, let isFork = json["fork"] as? Bool, let createdAt = json["created_at"] as? String {
            self.name = name
            self.numberOfStars = numberOfStars
            self.isFork = isFork
            self.createdAt = createdAt.components(separatedBy: "T").first!
            
            if let description = json["description"] as? String {
                self.description = description
            } else {
                self.description = "No Description"
            }
            
            if let language = json["language"] as? String {
                self.language = language
            } else {
                self.language = "Unknown Language"
            }
        } else {
            return nil
        }
    }
}
