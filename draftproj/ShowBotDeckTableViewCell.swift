//
//  ShowBotDeckTableViewCell.swift
//  draftproj
//
//  Created by Dusty Payne on 5/4/19.
//  Copyright © 2019 Dusty Payne. All rights reserved.
//

import UIKit

class ShowBotDeckTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    @IBOutlet weak var cardQty: UILabel!
    
    @IBOutlet weak var cardName: UILabel!
    
    
    @IBOutlet weak var cardCost: UILabel!
    
    @IBOutlet weak var cardType: UILabel!
    
    
    @IBOutlet weak var cardPT: UILabel!
    @IBOutlet weak var cardOracle: UILabel!
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
