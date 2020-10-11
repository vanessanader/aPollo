//
//  AnsweredQuestionsTableViewCell.swift
//  aPollo
//
//  Created by Vanessa Nader on 4/17/18.
//  Copyright © 2018 Vanessa Nader. All rights reserved.
//

import UIKit

class AnsweredQuestionsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var answerText: UITextView!
    @IBOutlet weak var questionText: UITextView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
