//
//  RepositoryVC.swift
//  HSESchoolVIII
//
//  Created by Kostya Bunsberry on 24.06.2021.
//

import UIKit
import RealmSwift

class RepositoryVC: UIViewController {
    
    var data: Repo!
    var delegate: MarkedDelegate?
    
    let realm = try! Realm()
    private var saved = false

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    
    private var savedObject = RealmRepo()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for object in realm.objects(RealmRepo.self) {
            if object.title == data.title {
                savedObject = object
                saved = true
            }
        }

        self.navigationItem.title = ""
        let logo = UIImageView(image: UIImage(named: "GithubLogo"))
        logo.contentMode = .scaleAspectFit
        self.navigationItem.titleView = logo
        
        infoView.addBorders(edges: .left, color: .black)
        titleLabel.text = data.title
        if !data.desc.isEmpty {
            descriptionLabel.text = data.desc
        } else {
            descriptionLabel.text = "No description was added"
        }
        languageLabel.text = "Written in \(data.language)"
        createdLabel.text = "Created at \(data.created)"
        
        if saved {
            saveButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        } else {
            saveButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.marksChanged()
    }
    
    @IBAction func saveRepo() {
        if saved {
            for object in realm.objects(RealmRepo.self) {
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
            savedObject = RealmRepo(title: data.title, desc: data.desc, created: data.created, language: data.language)
            RealmService().create(savedObject)
            saved = true
            saveButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        }
    }
    
}
