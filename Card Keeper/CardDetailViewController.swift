//
//  CardDetailViewController.swift
//  Card Keeper
//
//  Created by Joe Lao on 25/4/2018.
//  Copyright © 2018 Joe Lao. All rights reserved.
//

import UIKit
import CoreData

class CardDetailViewController: ViewController {
    
    @IBOutlet weak var barTitle: UINavigationItem!
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var cardIDLabel: UILabel!
    @IBOutlet weak var issuerLabel: UILabel!
    @IBOutlet weak var expiryLabel: UILabel!
    @IBOutlet weak var remarksLabel: UILabel!
    var codeImageView: UIImageView!
    var cardImageView: UIImageView!
    var codeImage: UIImage!
    
    @IBOutlet weak var cardImagesUIView: UIView!
    
    var selectedCard: Card?
    var showBack = false
    
    @IBAction func flipImage(_ sender: Any) {
        print(self.showBack)
        if (!self.showBack) {
            UIView.transition(from: self.cardImageView, to: self.codeImageView, duration: 0.7, options: UIViewAnimationOptions.transitionFlipFromRight, completion: nil)
            self.showBack = true
        } else {
            UIView.transition(from: self.codeImageView, to: self.cardImageView, duration: 0.7, options: UIViewAnimationOptions.transitionFlipFromLeft, completion: nil)
            self.showBack = false
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.cardImageView = UIImageView(frame: CGRect(x: 0,
                                                       y: 0,
                                                       width: cardImagesUIView.frame.width,
                                                       height: cardImagesUIView.frame.height))
        self.cardImageView.contentMode = UIViewContentMode.scaleAspectFit
        self.cardImageView.layer.cornerRadius = 15.0
        self.cardImageView.layer.masksToBounds = true
        self.populateCardData()
        
        self.codeImageView = UIImageView(frame: CGRect(x: 0,
                                          y: 0,
                                          width: cardImagesUIView.frame.width,
                                          height: cardImagesUIView.frame.height))
        
        self.codeImageView.contentMode = UIViewContentMode.scaleAspectFit
        codeImageView.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.codeImageView.layer.cornerRadius = 15.0
        self.codeImageView.layer.masksToBounds = true
        self.generateCodeImage()
        
        cardImagesUIView.addSubview(cardImageView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populateCardData() {
        guard let card = selectedCard else {
            print("no card!")
            return
        }
        
        
        
        self.barTitle.title = card.name
        
        if let img = card.image {
            self.cardImageView.image = UIImage(data: img)
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
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.selectedCard = dataConnector?.getCard(cardID: (self.selectedCard?.id)!)
        self.populateCardData()
        self.generateCodeImage()
    }

    func generateCodeImage() {
        guard let codeData = selectedCard?.code?.data(using: String.Encoding.isoLatin1, allowLossyConversion: false) else {
            return
        }
        if (selectedCard?.code_type == "qr") {
            let filter = CIFilter(name: "CIQRCodeGenerator")
            filter?.setValue(codeData, forKey: "inputMessage")
            filter?.setValue("Q", forKey: "inputCorrectionLevel")
            if let ciImage = filter?.outputImage {
                let transformed = ciImage.transformed(by: CGAffineTransform(scaleX: 10.0, y: 10.0))
                self.codeImage = UIImage(ciImage: transformed)
            }
            print("anyQR?")
            
        } else if (selectedCard?.code_type == "barcode") {
            let filter = CIFilter(name: "CICode128BarcodeGenerator")
            filter?.setValue(codeData, forKey: "inputMessage")
            if let ciImage = filter?.outputImage {
                let transformed = ciImage.transformed(by: CGAffineTransform(scaleX: 10.0, y: 10.0))
                self.codeImage = UIImage(ciImage: transformed)
            }
            print("anybar?")
        } else {
            let frame = CGRect(x: 0, y: 0, width: self.cardImagesUIView.frame.width, height: self.cardImagesUIView.frame.height)
            let label = UILabel(frame: frame)
            label.textAlignment = .center
            label.backgroundColor = .lightGray
            label.textColor = .white
            label.font = UIFont.boldSystemFont(ofSize: 25)
            label.text = selectedCard?.code
            UIGraphicsBeginImageContext(frame.size)
            if let currentContext = UIGraphicsGetCurrentContext() {
                label.layer.render(in: currentContext)
                self.codeImage = UIGraphicsGetImageFromCurrentImageContext()
            } else {
                self.codeImage = UIImage(data: codeData)
            }
            UIGraphicsEndImageContext()
            print("anything?")
        }
        self.codeImageView.image = self.codeImage
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editCardSegue") {
            let navC = segue.destination as? UINavigationController
            let editCardVC = navC?.viewControllers.first as! EditCardController
            editCardVC.editCard = selectedCard
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
