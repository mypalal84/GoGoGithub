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
    let description: String?
    let language: String?
    
    init?(json: [String: Any]) {
        
        //print(json)
        if let name = json["name"] as? String, let description = json["description"] as? String, let language = json["language"] as? String {
            
            self.name = name
            self.description = description
            self.language = language
//            print("name : \(name)")
//            print("language : \(language)")
//            print("description : \(description)")

        } else {
            return nil
        }
    }
}
