//
//  GitHub.swift
//  GoGoGithub
//
//  Created by A Cahn on 4/3/17.
//  Copyright © 2017 A Cahn. All rights reserved.
//

import UIKit

let kOAuthBaseURLString = "https://github.com/login/oauth/"

typealias GitHubOAuthCompletion = (Bool) -> ()

typealias FetchReposCompletion = ([Repository]?) -> ()

enum GitHubAuthError: Error {
    case extractingCode
}

enum SaveOptions {
    
    //empty dictionary, persists like local storage
    case userDefaults
}

//singleton
class GitHub {
    
    private var session: URLSession
    private var components: URLComponents
    
    static let shared = GitHub()
    
    //true singleton
    private init() {
        
        self.session = URLSession(configuration: .default)
        self.components = URLComponents()
        
        self.components.scheme = "https"
        self.components.host = "api.github.com"
        
        if let token = UserDefaults.standard.getAccessToken() {
            let queryItem = URLQueryItem(name: "access_token", value: token)
            self.components.queryItems = [queryItem]
        }
    }
    
    //requesting OAuth, opens login window
    func oAuthRequestWith(parameters: [String : String]) {
        var parametersString = ""
        
        for (key, value) in parameters {
            parametersString += "&\(key)=\(value)"
        }
        
        print("Parameter String: \(parametersString)")
        
        if let requestURL = URL(string: "\(kOAuthBaseURLString)authorize?client_id=\(kGitHubClientID)\(parametersString)") {
            
            print(requestURL.absoluteString)
            
            UIApplication.shared.open(requestURL)
        }
    }
    
    //get github code from url
    func getCodeFrom(url: URL) throws -> String {
        
        guard let code = url.absoluteString.components(separatedBy: "=").last else {
            throw GitHubAuthError.extractingCode
        }
        
        return code
        
    }
    
    //request OAuth token using url, code, clientid, and clientsecret
    func tokenRequestFor(url: URL, saveOptions: SaveOptions, completion: @escaping GitHubOAuthCompletion) {
        
        func complete(success: Bool) {
            
            OperationQueue.main.addOperation {
                completion(success)
            }
        }
        
        do{
            let code = try self.getCodeFrom(url: url)
            
            let requestString = "\(kOAuthBaseURLString)access_token?client_id=\(kGitHubClientID)&client_secret=\(kGitHubClientSecret)&code=\(code)"
            
            if let requestURL = URL(string: requestString) {
                
                let session = URLSession(configuration: .default)
                
                session.dataTask(with: requestURL, completionHandler: { (data, response, error) in
                    
                    if error != nil { complete(success: false) }
                    
                    guard let data = data else { complete(success: false); return }
                    
                    if let dataString = String(data: data, encoding: .utf8) {
                        
                        //save access token to userdefaults
                        if let token = self.accessTokenFrom(dataString) {
                            if UserDefaults.standard.save(accessToken: token) {
                                print("Saved successfully")
                            }
                        }
                        complete(success: true)
                    }
                }) .resume()//tells datatask to execute. most common bug in production(no feedback) have to do this!
                
            }
        } catch {
            print(error)
            complete(success: false)
        }
    }
    
    func accessTokenFrom(_ string: String) -> String? {
        
        if string.contains("access_token") {
            
            let components = string.components(separatedBy: "&")
            
            for component in components {
                if component.contains("access_token") {
                    let token = component.components(separatedBy: "=").last
                    
                    return token
                }
            }
        }
        return nil
    }
    
    func getRepos(completion: @escaping FetchReposCompletion) {
        
        //return to main queue
        func returnToMain(results: [Repository]?) {
            OperationQueue.main.addOperation {
                completion(results)
            }
        }
        
        self.components.path = "/user/repos"
        
        guard let url = self.components.url else { returnToMain(results: nil); return }
        
        self.session.dataTask(with: url) { (data, response, error) in
            
            if error != nil { returnToMain(results: nil); return }
            
            if let data = data {
                
                var repositories = [Repository]()
                
                do {
                    if let rootJson = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] {
                                                
                        for repositoryJSON in rootJson {
                            if let repo = Repository(json: repositoryJSON) {
                                repositories.append(repo)
                                //print("\(repositories.count)")
                            }
                        }
                        returnToMain(results: repositories)
                    }
                    
                } catch {
                    
                }
            }
            
        } .resume()
    }
}
