//
//  ProjectsTableViewCell.swift
//  Todome
//
//  Created by Karol Karczewski on 15.02.2017.
//  Copyright © 2017 Karol Karczewski. All rights reserved.
//

import UIKit

class ProjectsTableViewCell: UITableViewCell {
    @IBOutlet weak var projectNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
