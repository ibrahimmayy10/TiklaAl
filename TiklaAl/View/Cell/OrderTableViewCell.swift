//
//  OrderTableViewCell.swift
//  TiklaAl
//
//  Created by İbrahim Ay on 13.09.2023.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var orderTitleLabel: UILabel!
    
    @IBOutlet weak var orderImageView: UIImageView!
    
    @IBOutlet weak var orderPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
