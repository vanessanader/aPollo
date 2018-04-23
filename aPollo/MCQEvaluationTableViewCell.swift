//
//  MCQEvaluationTableViewCell.swift
//  aPollo
//
//  Created by Vanessa Nader on 4/23/18.
//  Copyright © 2018 Vanessa Nader. All rights reserved.
//

import UIKit

class MCQEvaluationTableViewCell: UITableViewCell {

    @IBOutlet weak var questionText: UITextView!
    
    @IBOutlet weak var answer1: UIButton!
    @IBOutlet weak var answer2: UIButton!
    @IBOutlet weak var answer3: UIButton!
    
    @IBOutlet weak var answer4: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
