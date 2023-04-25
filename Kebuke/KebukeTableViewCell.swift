//
//  KebukeTableViewCell.swift
//  Kebuke
//
//  Created by 沈庭鋒 on 2023/4/21.
//

import UIKit

class KebukeTableViewCell: UITableViewCell {

    
    @IBOutlet weak var drinkNameLabel: UILabel!
    @IBOutlet weak var drinkInfoLabel: UILabel!
    
    @IBOutlet weak var drinkSizeNPriceLabel: UILabel!
    
    @IBOutlet weak var drinkImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
