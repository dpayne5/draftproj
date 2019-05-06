//
//  SideBoardTableViewCell.swift
//  
//
//  Created by Dusty Payne on 4/9/19.
//

import UIKit

class SideBoardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cardCountLabel: UILabel!
    
    @IBOutlet weak var cardNameLabel: UILabel!
    
    @IBOutlet weak var cardTypeLabel: UILabel!
    
    
    @IBOutlet weak var cardPTvalLabel: UILabel!
    
    
    @IBOutlet weak var cardCostLabel: UILabel!
    
    
    @IBOutlet weak var cardOracleText: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
