//
//  RatingTableViewCell.swift
//  aPollo
//
//  Created by Vanessa Nader on 4/23/18.
//  Copyright © 2018 Vanessa Nader. All rights reserved.
//

import UIKit
import Cosmos

class RatingTableViewCell: UITableViewCell {

    @IBOutlet weak var questionText: UITextView!
    
    @IBOutlet weak var submit: UIButton!
    
    @IBOutlet weak var stars: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
