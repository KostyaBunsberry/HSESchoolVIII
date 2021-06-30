//
//  LoadingCell.swift
//  HSESchoolVIII
//
//  Created by Kostya Bunsberry on 30.06.2021.
//

import UIKit

class LoadingCell: UITableViewCell {

    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        loader.startAnimating()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
