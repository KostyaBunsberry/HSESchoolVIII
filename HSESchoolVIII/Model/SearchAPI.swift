//
//  SearchAPI.swift
//  HSESchoolVIII
//
//  Created by Kostya Bunsberry on 24.06.2021.
//

import Foundation
import Alamofire

class SearchAPI {
    let repositoryURL = "https://api.github.com/search/repositories?q="
    let usersURL = "https://api.github.com/search/users?q="
    
    func findUsers(string: String, completition: @escaping ([User]) -> Void) {
        AF.request(usersURL+string)
            .responseJSON { response in
                if let data = response.data,
                   let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
                   let jsonDict = json as? NSDictionary,
                   let items = jsonDict["items"] as? NSArray {
                    var found: [User] = []
                    for i in items {
                        let item = i as? NSDictionary
                        found.append(User(title: item?["login"] as! String, id: item?["id"] as! Int, repos_url: item?["repos_url"] as! String, avatar: item?["avatar_url"] as! String, followers: item?["followers_url"] as! String))
                    }
                    DispatchQueue.main.async {
                        completition(found)
                    }
                }
            }
    }
    
    func findRepos(string: String, completition: @escaping ([Repo]) -> Void) {
        AF.request(repositoryURL+string)
            .responseJSON { response in
                if let data = response.data,
                   let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
                   let jsonDict = json as? NSDictionary,
                   let items = jsonDict["items"] as? NSArray {
                    var found: [Repo] = []
                    for i in items {
                        let item = i as? NSDictionary
                        var time = (item?["created_at"] as! String)
                        time.removeLast(10)
                        time = time.replacingOccurrences(of: "-", with: "/")
                        
                        found.append(Repo(
                                        title: item?["name"] as! String,
                                        desc: item?["description"] as? String ?? "",
                                        created: time,
                                        language: item?["language"] as? String ?? ""))
                    }
                    DispatchQueue.main.async {
                        completition(found)
                    }
                }
            }
    }
}
