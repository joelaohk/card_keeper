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
    var tableView: UITableView!
    
    private lazy var former: Former = Former(tableView: tableView)
    var cardNameRow: TextViewRowFormer<FormTextViewCell>!
    var issuerRow: TextViewRowFormer<FormTextViewCell>!
    var cardImageHolderRow: CustomRowFormer<CardImageHolderCell>!
    var cardFaceSection: SectionFormer!
    var cardInfoSection: SectionFormer!
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
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UITableView
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth,UIViewAutoresizing.flexibleHeight]
        
        self.tableView = view
        
        self.cardImageHolderRow = CustomRowFormer<CardImageHolderCell>(instantiateType: .Nib(nibName: "CardFaceCell")).configure {
            row in
            row.rowHeight = 227
        }
        let cardNameLabelRow = LabelRowFormer<FormLabelCell>().configure {
            row in
            row.rowHeight = 30
            row.text = "CARD NAME"
        }
        self.cardNameRow = TextViewRowFormer<FormTextViewCell>().configure {
            row in row.placeholder = "Card name"
            row.rowHeight = 40
        }
        self.issuerRow = TextViewRowFormer<FormTextViewCell>().configure {
            row in row.placeholder = "Issuer"
            row.rowHeight = 40
        }
        
        
        self.cardFaceSection = SectionFormer(rowFormer: cardImageHolderRow)
        self.cardInfoSection = SectionFormer(rowFormer: cardNameLabelRow, cardNameRow, issuerRow)
        self.former.append(sectionFormer: cardFaceSection, cardInfoSection)
        addSubview(view)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
