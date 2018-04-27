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
    var cardNameRow: TextFieldRowFormer<FormTextFieldCell>!
    var issuerRow: TextFieldRowFormer<FormTextFieldCell>!
    var cardImageHolderRow: CustomRowFormer<CardImageHolderCell>!
    var cardIDRow: TextFieldRowFormer<CardIDCell>!
    var showIDMethodRow: InlinePickerRowFormer<FormInlinePickerCell, String>!
    var expDateRow: InlineDatePickerRowFormer<FormInlineDatePickerCell>!
    var remarkRow: TextViewRowFormer<FormTextViewCell>!
    var cardFaceSection: SectionFormer!
    var cardInfoSection: SectionFormer!
    var cardData: [String:Any]!
    
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
        
        
        cardData = [String:Any]()
        self.cardImageHolderRow = CustomRowFormer<CardImageHolderCell>(instantiateType: .Nib(nibName: "CardFaceCell")).configure {
            row in
            row.rowHeight = 227
            }.onUpdate {
                item in
                let imageData = UIImageJPEGRepresentation(item.cell.CardImageHolder.image!, 1)
                self.cardData["image"] = imageData
        }
        self.cardNameRow = TextFieldRowFormer<FormTextFieldCell>().configure {
            row in
            row.cell.textField.keyboardType = UIKeyboardType.namePhonePad
            row.placeholder = "Card name"
            row.rowHeight = 40
            }.onTextChanged{
                item in
                self.cardData["name"] = item
        }
        self.issuerRow = TextFieldRowFormer<FormTextFieldCell>().configure {
            row in row.placeholder = "Issuer"
            row.rowHeight = 40
            }.onTextChanged{
                item in
                self.cardData["issuer"] = item
        }
        self.cardIDRow = TextFieldRowFormer<CardIDCell>(instantiateType: .Nib(nibName: "CardIDCell")).configure {
            row in
            row.placeholder = "Card ID"
            row.rowHeight = 40
            }.onTextChanged {
                item in
                self.cardData["code"] = item
        }
        self.showIDMethodRow = InlinePickerRowFormer<FormInlinePickerCell, String>() {
            $0.titleLabel.text = "ID Display Format"
            }.configure {
                row in
                let items = [InlinePickerItem(title: "QR", value: "qr"),
                             InlinePickerItem(title: "Barcode", value: "barcode"),
                             InlinePickerItem(title: "Plain Text", value: "plain")]
                row.pickerItems = items
            }.onValueChanged{
                item in
                self.cardData["code_type"] = item.value
        }
        self.expDateRow = InlineDatePickerRowFormer<FormInlineDatePickerCell>() {
            $0.titleLabel.text = "Expiry Date"
            }.inlineCellSetup{
                $0.datePicker.datePickerMode = .date
                $0.datePicker.minimumDate = Date()
                self.cardData["expiry"] = $0.datePicker.date
            }.onDateChanged{
                self.cardData["expiry"] = $0
        }
        self.remarkRow = TextViewRowFormer<FormTextViewCell>().configure {
            $0.placeholder = "Remarks"
            $0.rowHeight = 100
            }.onTextChanged {
                self.cardData["remarks"] = $0
        }
        
        self.cardFaceSection = SectionFormer(rowFormer: cardImageHolderRow)
        self.cardInfoSection = SectionFormer(rowFormer: cardNameRow, issuerRow, cardIDRow, showIDMethodRow, expDateRow, remarkRow)
        self.former.append(sectionFormer: cardFaceSection, cardInfoSection)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
