//
//  OpenEndedEvaluationTableViewCell.swift
//  aPollo
//
//  Created by Vanessa Nader on 4/23/18.
//  Copyright © 2018 Vanessa Nader. All rights reserved.
//

import UIKit

class OpenEndedEvaluationTableViewCell: UITableViewCell {

    @IBOutlet weak var questionText: UITextView!
    
    @IBOutlet weak var answerText: UITextField!
    
    @IBOutlet weak var submit: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
