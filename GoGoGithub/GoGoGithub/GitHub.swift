//
//  GitHub.swift
//  GoGoGithub
//
//  Created by A Cahn on 4/3/17.
//  Copyright © 2017 A Cahn. All rights reserved.
//

import UIKit

let kOAuthBaseURLString = "https://github.com/login/oauth/"

enum GitHubAuthError: Error {
    case extractingCode
}

class GitHub {
    
    let gitHubClientID = "b3dd1203cd38fe1a3e8f"
    let gitHubClientSecret = "b2875f0c807f43b73a95dc6913f27f3187b09fe5"
    
    static let shared = GitHub()
    
    func oAuthRequestWith(parameters: [String : String]) {
        var parametersString = ""
        
        for (key, value) in parameters {
            parametersString += "&\(key)=\(value)"
        }
        
        print("Parameter String: \(parametersString)")
        
        if let requestURL = URL(string: "\(kOAuthBaseURLString)authorize?client_id=\(gitHubClientID)\(parametersString)") {
            
            print(requestURL.absoluteString)
            
            UIApplication.shared.open(requestURL)
        }
    }
    
    func getCodeFrom(url: URL) throws -> String {
        
        guard let code = url.absoluteString.components(separatedBy: "=").last else {
            throw GitHubAuthError.extractingCode
        }
        
        return code
        
    }
    
}













