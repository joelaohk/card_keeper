//
//  AddCardController.swift
//  Card Keeper
//
//  Created by Joe Lao on 24/4/2018.
//  Copyright © 2018 Joe Lao. All rights reserved.
//

import UIKit
import Former

class AddCardController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let cardNameRow = TextViewRowFormer<FormTextViewCell>().configure {
            row in row.placeholder = "Card name"
        }
        let issuerRow = TextViewRowFormer<FormTextViewCell>().configure {
            row in row.placeholder = "Issuer"
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
