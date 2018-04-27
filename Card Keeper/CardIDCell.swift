//
//  CardIDCell.swift
//  
//
//  Created by Joe Lao on 26/4/2018.
//

import UIKit
import Former

class CardIDCell: UITableViewCell, TextFieldFormableRow {
    
    var scanDelegate: ScanIDDelegate?
    
    @IBOutlet weak var cardIDTextField: UITextField!
    
    @IBAction func scanButtonClicked(_ sender: Any) {
        print("hello")
        scanDelegate?.scanID(self)
    }
    func formTextField() -> UITextField {
        return cardIDTextField
    }
    
    func formTitleLabel() -> UILabel? {
        return nil
    }
    
    func updateWithRowFormer(_ rowFormer: RowFormer) {
        
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
