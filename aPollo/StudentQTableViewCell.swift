//
//  StudentQTableViewCell.swift
//  aPollo
//
//  Created by Vanessa Nader on 4/17/18.
//  Copyright © 2018 Vanessa Nader. All rights reserved.
//

import UIKit

class StudentQTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var topic: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }    
}
