//
//  CardImageHolderCell.swift
//  Card Keeper
//
//  Created by Joe Lao on 25/4/2018.
//  Copyright © 2018 Joe Lao. All rights reserved.
//

import UIKit

final class CardImageHolderCell: UITableViewCell {

    @IBOutlet weak var CardImageHolder: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
