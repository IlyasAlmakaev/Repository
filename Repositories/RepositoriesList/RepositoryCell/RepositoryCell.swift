//
//  RepositoryCell.swift
//  Repositories
//
//  Created by Ильяс on 15/12/2018.
//  Copyright © 2018 Алмакаев Ильяс. All rights reserved.
//

import UIKit

class RepositoryCell: UITableViewCell {

    @IBOutlet var fullName: UILabel!
    @IBOutlet var language: UILabel!
    @IBOutlet var stargazersCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(model: Repository) {
        fullName.text = model.fullName
        language.text = model.language
        stargazersCount.text = String(model.stargazersCount ?? 0)
    }
    
}
