//
//  RepositoryVC.swift
//  HSESchoolVIII
//
//  Created by Kostya Bunsberry on 24.06.2021.
//

import UIKit

class RepositoryVC: UIViewController {
    
    var data: Repo!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var saveButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

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
        saveButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        saveButton.imageView?.contentMode = .scaleAspectFit
    }
    
    @IBAction func saveRepo() {
        
    }
    
}
