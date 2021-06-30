//
//  MarkedVC.swift
//  HSESchoolVIII
//
//  Created by Kostya Bunsberry on 24.06.2021.
//

import UIKit
import RealmSwift

protocol MarkedDelegate {
    func marksChanged()
}

class MarkedVC: UIViewController, MarkedDelegate {
    
    let realm = try! Realm()
    
    var tableData = [TableObject]()
    
    var userObject = User()
    var repoObject = Repo()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = ""
        let logo = UIImageView(image: UIImage(named: "GithubLogo"))
        logo.contentMode = .scaleAspectFit
        self.navigationItem.titleView = logo
        
        reloadData()
    }
    
    func marksChanged() {
        reloadData()
    }
    
    func reloadData() {
        tableData.removeAll()
        
        for user in realm.objects(RealmUser.self) {
            tableData.append(TableObject(title: user.title, id: user.id, type: .user, repos_url: user.repos_url, avatar: user.avatar, followers: user.followers))
        }
        
        for repo in realm.objects(RealmRepo.self) {
            tableData.append(TableObject(title: repo.title, time: repo.created, type: .repo, language: repo.language))
        }
        tableView.reloadData()
    }

}

extension MarkedVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableData.isEmpty {
            return 1
        }
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableData.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "noSavedCell", for: indexPath) as! NoMarksCell
            return cell
        }
        
        if tableData[indexPath.row].type == .user {
            let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserCell
            cell.titleLabel.text = tableData[indexPath.row].title
            cell.reposLabel.text = "id: \(tableData[indexPath.row].id)"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath) as! RepoCell
            cell.titleLabel.text = tableData[indexPath.row].title
            cell.dateLabel.text = "Created at \(tableData[indexPath.row].time)"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableData[indexPath.row].type == .user {
            let object = tableData[indexPath.row]
            userObject = User(title: object.title, id: object.id, repos_url: object.repos_url, avatar: object.avatar, followers: object.followers)
            self.performSegue(withIdentifier: "toSavedUser", sender: nil)
        } else {
            let object = tableData[indexPath.row]
            repoObject = Repo(title: object.title, desc: object.desc, created: object.time, language: object.language)
            self.performSegue(withIdentifier: "toSavedRepo", sender: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier  == "toSavedUser" {
            let destination = segue.destination as! UserVC
            destination.data = userObject
            destination.delegate = self
        } else if segue.identifier  == "toSavedRepo" {
            let destination = segue.destination as! RepositoryVC
            destination.data = repoObject
            destination.delegate = self
        }
    }
    
}
