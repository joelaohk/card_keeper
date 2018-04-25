//
//  CardEditorTableView.swift
//  Card Keeper
//
//  Created by Joe Lao on 26/4/2018.
//  Copyright © 2018 Joe Lao. All rights reserved.
//

import UIKit
import Former

class CardEditorTableView: UITableView {

    
    private lazy var former: Former = Former(tableView: self)
    var cardNameRow: TextViewRowFormer<FormTextViewCell>!
    var issuerRow: TextViewRowFormer<FormTextViewCell>!
    var cardImageHolderRow: CustomRowFormer<CardImageHolderCell>!
    var section: SectionFormer!
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: CGRect.zero, style: .grouped)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func populateCardData(card: Card) {
        
    }
    
    func setup() {
        self.cardNameRow = TextViewRowFormer<FormTextViewCell>().configure {
            row in row.placeholder = "Card name"
        }
        self.issuerRow = TextViewRowFormer<FormTextViewCell>().configure {
            row in row.placeholder = "Issuer"
        }
        self.cardImageHolderRow = CustomRowFormer<CardImageHolderCell>()
        
        self.section = SectionFormer(rowFormer: cardImageHolderRow,cardNameRow, issuerRow)
        self.former.append(sectionFormer: section)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
