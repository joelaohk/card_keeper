//
//  CardDetailViewController.swift
//  Card Keeper
//
//  Created by Joe Lao on 25/4/2018.
//  Copyright © 2018 Joe Lao. All rights reserved.
//

import UIKit

class CardDetailViewController: ViewController {
    
    @IBOutlet weak var barTitle: UINavigationItem!
    @IBOutlet weak var cardFaceImageView: UIImageView!
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var cardIDLabel: UILabel!
    @IBOutlet weak var issuerLabel: UILabel!
    @IBOutlet weak var expiryLabel: UILabel!
    @IBOutlet weak var remarksLabel: UILabel!
    
    var selectedCard: Card?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        cardFaceImageView.layer.cornerRadius = 15.0
        cardFaceImageView.layer.masksToBounds = true
        
        self.populateCardData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populateCardData() {
        guard let card = selectedCard else {
            return
        }
        
        self.barTitle.title = card.name
        
        if let img = card.image {
            self.cardFaceImageView.image = UIImage(data: img)
        }
        self.cardNameLabel.text = card.name
        self.cardIDLabel.text = card.code
        self.issuerLabel.text = card.issuer
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        if let date = card.expiry {
            self.expiryLabel.text = dateFormatter.string(from: date)
        }
        
        self.remarksLabel.text = card.remarks
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
