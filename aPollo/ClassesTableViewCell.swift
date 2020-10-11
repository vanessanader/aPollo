//
//  ClassesTableViewCell.swift
//  aPollo
//
//  Created by Vanessa Nader on 3/28/18.
//  Copyright © 2018 Vanessa Nader. All rights reserved.
//

import UIKit

class ClassesTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var classTitle: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
