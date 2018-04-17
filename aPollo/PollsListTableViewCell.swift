//
//  PollsListTableViewCell.swift
//  aPollo
//
//  Created by Vanessa Nader on 4/16/18.
//  Copyright © 2018 Vanessa Nader. All rights reserved.
//

import UIKit

class PollsListTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var pollTitle: UILabel!
    @IBOutlet weak var pollDate: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
