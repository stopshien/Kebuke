//
//  ShopCartTableViewCell.swift
//  Kebuke
//
//  Created by 沈庭鋒 on 2023/4/23.
//

import UIKit

class ShopCartTableViewCell: UITableViewCell {

    
    @IBOutlet weak var drinkImageView: UIImageView!
    
    @IBOutlet weak var drinkName: UILabel!
    
    @IBOutlet weak var drinkAdjust: UILabel!
    
    @IBOutlet weak var drinksizeNPrice: UILabel!
    
    @IBOutlet weak var orderer: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
