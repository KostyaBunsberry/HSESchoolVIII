//
//  UserVC.swift
//  HSESchoolVIII
//
//  Created by Kostya Bunsberry on 24.06.2021.
//

import UIKit
import Kingfisher

class UserVC: UIViewController {
    
    var data: User!
    
    var repos = [Repo]()
    var repoObject = Repo()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        avatarImageView.backgroundColor = .tertiarySystemBackground
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarImageView.kf.setImage(with: URL(string: data.avatar))
        bookmarkButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        bookmarkButton.imageView?.contentMode = .scaleAspectFit
        nameLabel.text = data.title
        
        self.navigationItem.title = ""
        let logo = UIImageView(image: UIImage(named: "GithubLogo"))
        logo.contentMode = .scaleAspectFit
        self.navigationItem.titleView = logo
        
        getRepos()
    }
    
    func getRepos() {
        AdditionalAPI().getRepositories(repos_url: data.repos_url, completition: { repos in
            self.repos = repos
            self.tableView.reloadData()
        })
    }
    
    @IBAction func saveToBookmarks() {
        
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
