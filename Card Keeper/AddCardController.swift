//
//  AddCardController.swift
//  Card Keeper
//
//  Created by Joe Lao on 25/4/2018.
//  Copyright © 2018 Joe Lao. All rights reserved.
//

import UIKit
import CoreData
import IRLDocumentScanner
import Former

class AddCardController: UIViewController, IRLScannerViewControllerDelegate, ScanIDDelegate, SendMetadataDelegate {
    
    func sendMetadata(_ sender: ScanCodeViewController, metadata: [String:Any]) {
        mainView.cardIDRow.cell.cardIDTextField.text = metadata["code"] as? String
        if (metadata["code_type"] as? String == "qr") {
            mainView.showIDMethodRow.selectedRow = 0
        } else if (metadata["code_type"] as? String == "barcode") {
            mainView.showIDMethodRow.selectedRow = 1
        }
        
        for data in metadata {
            mainView.cardData[data.key] = data.value
        }
        
    }
    
    func scanID(_ sender: CardIDCell) {
        
        let idScanner = self.storyboard?.instantiateViewController(withIdentifier: "ScanID") as! ScanCodeViewController
        idScanner.dataDelegate = self
        self.navigationController?.showDetailViewController(idScanner, sender: self)
    }
    
    func pageSnapped(_ page_image: UIImage, from controller: IRLScannerViewController) {
        controller.dismiss(animated: true) { () -> Void in
            let processed = ImageManager.processCardImage(cardImage: page_image)
            self.mainView.cardImageHolderRow.cell.CardImageHolder.image = processed
            let imageData = UIImageJPEGRepresentation(processed, 1)
            self.mainView.cardData["image"] = imageData
        }
    }
    
    func cameraViewWillUpdateTitleLabel(_ cameraView: IRLScannerViewController) -> String? {
        
        var text = ""
        switch cameraView.cameraViewType {
        case .normal:           text = text + "NORMAL"
        case .blackAndWhite:    text = text + "B/W-FILTER"
        case .ultraContrast:    text = text + "CONTRAST"
        }
        
        switch cameraView.detectorType {
        case .accuracy:         text = text + " | Accuracy"
        case .performance:      text = text + " | Performance"
        }
        
        return text
    }
    
    func didCancel(_ cameraView: IRLScannerViewController) {
        cameraView.dismiss(animated: true){ ()-> Void in
            NSLog("Cancel pressed");
        }
    }
    
    @IBOutlet weak var mainView: CardEditorTableView!
    var dataConnect: CoreDataConnect!
    var appDelegate: AppDelegate!
    var context: NSManagedObjectContext!
    
    @IBAction func confirmToAdd(_ sender: Any) {
        let success = dataConnect.addCard(data: mainView.cardData)
        if (!success) {
            print("GOSH!")
        }
        performSegue(withIdentifier: "unwindToMain", sender: self)
    }
    @IBAction func goBack(_ sender: Any) {
        performSegue(withIdentifier: "unwindToMain", sender: self)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let scanner = IRLScannerViewController.standardCameraView(with: self)
        scanner.showControls = true
        scanner.showAutoFocusWhiteRectangle = true
        present(scanner, animated: true, completion: nil)
        // Your action
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
        self.dataConnect = CoreDataConnect(context: context)
        mainView.alwaysBounceVertical = true
        let cardFaceImageView = mainView.cardImageHolderRow.cell.CardImageHolder
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        cardFaceImageView!.isUserInteractionEnabled = true
        mainView.cardIDRow.cell.scanDelegate = self
        mainView.cardImageHolderRow.cell.CardImageHolder.addGestureRecognizer(tapGestureRecognizer)
        
        //let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        //mainView.cardIDRow.cell.scanIDButton.addGestureRecognizer()
        
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
