//
//  AdditionalAPI.swift
//  HSESchoolVIII
//
//  Created by Kostya Bunsberry on 30.06.2021.
//

import Foundation
import Alamofire

class AdditionalAPI {
    
    func getRepositories(repos_url: String, completition: @escaping ([Repo]) -> Void) {
        var repos = [Repo]()
        
        AF.request(repos_url)
            .responseJSON { response in
                if let data = response.data,
                   let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
                   let jsonArray = json as? NSArray {
                    for repo in jsonArray {
                        if let repoJson = repo as? NSDictionary {
                            var time = (repoJson["created_at"] as! String)
                            time.removeLast(10)
                            time = time.replacingOccurrences(of: "-", with: "/")
                            
                            repos.append(Repo(
                                                title: repoJson["name"] as! String,
                                                desc: repoJson["description"] as? String ?? "",
                                                created: time,
                                                language: repoJson["language"] as? String ?? ""))
                        }
                    }
                    DispatchQueue.main.async {
                        completition(repos)
                    }
                }
            }
                
        }
}
