//
//  BasketTableViewCell.swift
//  TiklaAl
//
//  Created by İbrahim Ay on 11.09.2023.
//

import UIKit

class BasketTableViewCell: UITableViewCell {
    
    @IBOutlet weak var basketImageView: UIImageView!
    @IBOutlet weak var basketTitleLabel: UILabel!
    @IBOutlet weak var basketPriceLabel: UILabel!
    @IBOutlet weak var adetLabel: UILabel!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var plusBtn: UIButton!
    
    var quantity = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func minusButton(_ sender: Any) {
        if quantity > 1 {
            quantity -= 1
            adetLabel.text = "\(quantity)"
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "adetDegisti"), object: nil)
        }
    }
    
    @IBAction func plusButton(_ sender: Any) {
        quantity += 1
        adetLabel.text = "\(quantity)"
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "adetDegisti"), object: nil)
    }
    
}
