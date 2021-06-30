//
//  UserVC.swift
//  HSESchoolVIII
//
//  Created by Kostya Bunsberry on 24.06.2021.
//

import UIKit
import Kingfisher
import RealmSwift

class UserVC: UIViewController {
    
    var data: User!
    var delegate: MarkedDelegate?
    
    private var repos = [Repo]()
    private var repoObject = Repo()
    
    let realm = try! Realm()
    private var saved = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    private var savedObject = RealmUser()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for object in realm.objects(RealmUser.self) {
            if object.title == data.title {
                savedObject = object
                saved = true
            }
        }

        avatarImageView.backgroundColor = .tertiarySystemBackground
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarImageView.kf.setImage(with: URL(string: data.avatar))
        nameLabel.text = data.title
        
        self.navigationItem.title = ""
        let logo = UIImageView(image: UIImage(named: "GithubLogo"))
        logo.contentMode = .scaleAspectFit
        self.navigationItem.titleView = logo
        
        if saved {
            saveButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        } else {
            saveButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
        
        getRepos()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.marksChanged()
    }
    
    func getRepos() {
        AdditionalAPI().getRepositories(repos_url: data.repos_url, completition: { repos in
            self.repos = repos
            self.tableView.reloadData()
        })
    }
    
    @IBAction func saveUser() {
        if saved {
            for object in realm.objects(RealmUser.self) {
                if object.title == savedObject.title {
                    do {
                        try realm.write {
                            realm.delete(object)
                        }
                    } catch {
                        print("Error while deleting")
                    }
                }
            }
            saved = false
            saveButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        } else {
            savedObject = RealmUser(title: data.title, id: data.id, repos_url: data.repos_url, avatar: data.avatar, followers: data.followers)
            RealmService().create(savedObject)
            saved = true
            saveButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        }
    }

}

extension UserVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath) as! RepoCell
        cell.titleLabel.text = repos[indexPath.row].title
        cell.dateLabel.text = "Created at \(repos[indexPath.row].created)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        repoObject = repos[indexPath.row]
        performSegue(withIdentifier: "toUserRepo", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! RepositoryVC
        destination.data = repoObject
    }
}
