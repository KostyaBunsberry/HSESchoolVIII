//
//  MarkedVC.swift
//  HSESchoolVIII
//
//  Created by Kostya Bunsberry on 24.06.2021.
//

import UIKit

class MarkedVC: UIViewController {
    
    
    var users = [User]()
    var repos = [Repo]()
    var tableData = [TableObject]()
    
    var userObject = User()
    var repoObject = Repo()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = ""
        let logo = UIImageView(image: UIImage(named: "GithubLogo"))
        logo.contentMode = .scaleAspectFit
        self.navigationItem.titleView = logo
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
            // MARK: nothing done here
            cell.dateLabel.text = "Created at \(tableData[indexPath.row].time)"
            return cell
        }
    }
    
}
