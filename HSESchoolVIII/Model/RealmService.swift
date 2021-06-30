//
//  RealmService.swift
//  HSESchoolVIII
//
//  Created by Kostya Bunsberry on 01.07.2021.
//

import Foundation
import RealmSwift

class RealmService {
    let realm = try! Realm()
    
    func create <T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            print("Trouble creating realm object")
        }
    }
}

class RealmRepo: Object {
    @objc dynamic var title = ""
    @objc dynamic var desc = ""
    @objc dynamic var created = ""
    @objc dynamic var language = ""
    
    convenience init(title: String, desc: String, created: String, language: String) {
        self.init()
        self.title = title
        self.desc = desc
        self.created = created
        self.language = language
    }
}

class RealmUser: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var id = 0
    @objc dynamic var repos_url = ""
    @objc dynamic var avatar = ""
    @objc dynamic var followers = ""
    
    convenience init(title: String, id: Int, repos_url: String, avatar: String, followers: String) {
        self.init()
        self.title = title
        self.id = id
        self.repos_url = repos_url
        self.avatar = avatar
        self.followers = followers
    }
}
