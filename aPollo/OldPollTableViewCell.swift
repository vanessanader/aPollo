//
//  OldPollTableViewCell.swift
//  aPollo
//
//  Created by Vanessa Nader on 4/16/18.
//  Copyright © 2018 Vanessa Nader. All rights reserved.
//

import UIKit

class OldPollTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var yourAnswerText: UILabel!
    @IBOutlet weak var correctAnswerText: UILabel!
    @IBOutlet weak var questionText: UITextView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
