//
//  CardEditor.swift
//  Card Keeper
//
//  Created by Joe Lao on 25/4/2018.
//  Copyright © 2018 Joe Lao. All rights reserved.
//

import UIKit
import Former

class CardEditor: UIView {
    
    
    @IBOutlet weak var editorTable: UITableView!
    private lazy var former: Former = Former(tableView: editorTable)
    var cardNameRow: TextViewRowFormer<FormTextViewCell>
    var issuerRow: TextViewRowFormer<FormTextViewCell>
    var section: SectionFormer
    
    
    
    init() {
        self.cardNameRow = TextViewRowFormer<FormTextViewCell>().configure {
            row in row.placeholder = "Card name"
        }
        self.issuerRow = TextViewRowFormer<FormTextViewCell>().configure {
            row in row.placeholder = "Issuer"
        }
        self.section = SectionFormer(rowFormer: cardNameRow, issuerRow)
        
        super.init(frame: CGRect.zero)
        self.former.append(sectionFormer: section)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
