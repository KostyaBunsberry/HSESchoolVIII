//
//  SearchVC.swift
//  HSESchoolVIII
//
//  Created by Kostya Bunsberry on 24.06.2021.
//

import UIKit

enum TableObjectType {
    case user
    case repo
}

struct TableObject {
    var title = String()
    var id = Int()
    var time = String()
    var type: TableObjectType = .user
    var repos_url = String()
    var avatar = String()
    var followers = String()
    var desc = String()
    var language = String()
}

class SearchVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterButton: UIBarItem!
    @IBOutlet weak var searchTextField: UITextField!

    private var filterMode = 0
    
    var users = [User]()
    var repos = [Repo]()
    var tableData = [TableObject]()
    
    var userObject = User()
    var repoObject = Repo()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchTextField.delegate = self
        
        self.navigationItem.title = ""
        let logo = UIImageView(image: UIImage(named: "GithubLogo"))
        logo.contentMode = .scaleAspectFit
        self.navigationItem.titleView = logo
    }
    
    //MARK: Filters button
    @IBAction func filterChange() {
        switch filterMode {
        case 0:
            filterMode = 1
            filterButton.image = UIImage(systemName: "book.closed")
            searchTextField.placeholder = "Look for repos only..."
        case 1:
            filterMode = 2
            filterButton.image = UIImage(systemName: "person.3")
            searchTextField.placeholder = "Look for users only..."
        case 2:
            filterMode = 0
            filterButton.image = UIImage(systemName: "staroflife.circle")
            searchTextField.placeholder = "Look for users and repos..."
        default:
            debugPrint("Filter is broken")
        }
        reloadTableData(key: "", unloaded: false)
    }
    
    //MARK: Search Usage
    func reloadTableData(key: String, unloaded: Bool) {
        tableData.removeAll()
        
        if filterMode == 0 || filterMode == 2 {
            if unloaded {
                SearchAPI().findUsers(string: key, completition: { users in
                    self.users.removeAll()
                    for user in users {
                        self.users.append(user)
                    }
                })
            }
            
            for user in users {
                tableData.append(TableObject(title: user.title, id: user.id, type: .user, repos_url: user.repos_url, avatar: user.avatar, followers: user.followers))
            }
        }
        if filterMode == 0 || filterMode == 1 {
            if unloaded {
                SearchAPI().findRepos(string: key, completition: { repos in
                    self.repos.removeAll()
                    for repo in repos {
                        self.repos.append(repo)
                    }
                })
            }
            
            for repo in repos {
                tableData.append(TableObject(title: repo.title, id: 0, time: repo.created, type: .repo, desc: repo.desc, language: repo.language))
            }
        }
        
        tableView.reloadData()
    }
    
    var timer = Timer.scheduledTimer(withTimeInterval: 1.2, repeats: false) { timer in
        print("Timer fired!")
    }
}
// MARK: Text Field Delegate
extension SearchVC: UITextFieldDelegate {
    
    func timerShit() {
        timer.invalidate()
        if !searchTextField.text!.isEmpty {
            timer = Timer.scheduledTimer(withTimeInterval: 1.2, repeats: false) { timer in
                self.reloadTableData(key: self.searchTextField.text ?? "", unloaded: true)
                _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
                    self.reloadTableData(key: "", unloaded: false)
                }
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            if text.count > 2 {
                timerShit()
            } else {
                timer = Timer.scheduledTimer(withTimeInterval: 0, repeats: false) { timer in
                    self.tableData.removeAll()
                    self.users.removeAll()
                    self.repos.removeAll()
                    self.tableView.reloadData()
                }
            }
        }
        
        return true
    }
}

//MARK: TableView Delegate
extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableData.isEmpty {
            return 1
        }
        
        if filterMode == 0 {
            tableData.shuffle()
        }
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableData.isEmpty {
            return tableView.dequeueReusableCell(withIdentifier: "typeCell", for: indexPath)
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // MARK: check type and go to shit
        if tableData[indexPath.row].type == .user {
            let object = tableData[indexPath.row]
            userObject = User(title: object.title, id: object.id, repos_url: object.repos_url, avatar: object.avatar, followers: object.followers)
            self.performSegue(withIdentifier: "toUserView", sender: nil)
        }
        self.view.endEditing(true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier  == "toUserView" {
                let destination = segue.destination as! UserVC
                destination.data = userObject
            }
        }
}
