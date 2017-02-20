//
//  TodoTableViewCell.swift
//  Todome
//
//  Created by Karol Karczewski on 15.02.2017.
//  Copyright © 2017 Karol Karczewski. All rights reserved.
//

import UIKit

class TodoTableViewCell: UITableViewCell {

    @IBOutlet weak var todoContentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
