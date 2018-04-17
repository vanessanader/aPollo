//
//  OpenEndedTableViewCell.swift
//  aPollo
//
//  Created by Vanessa Nader on 4/17/18.
//  Copyright © 2018 Vanessa Nader. All rights reserved.
//

import UIKit

class OpenEndedTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var done: UIButton!
    @IBOutlet weak var questionText: UITextView!
    @IBOutlet weak var answerText: UITextField!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
