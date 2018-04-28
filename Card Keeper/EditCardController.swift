//
//  AddCardController.swift
//  Card Keeper
//
//  Created by Joe Lao on 24/4/2018.
//  Copyright © 2018 Joe Lao. All rights reserved.
//

import UIKit
import Former
import CoreData
import IRLDocumentScanner

class EditCardController: FormViewController, IRLScannerViewControllerDelegate, ScanIDDelegate, SendMetadataDelegate {
    func pageSnapped(_ page_image: UIImage, from controller: IRLScannerViewController) {
        controller.dismiss(animated: true) { () -> Void in
            let processed = ImageManager.processCardImage(cardImage: page_image)
            self.mainView.cardImageHolderRow.cell.CardImageHolder.image = processed
            let imageData = UIImageJPEGRepresentation(processed, 1)
            self.mainView.cardData["image"] = imageData
        }
    }
    
    func scanID(_ sender: CardIDCell) {
        let idScanner = self.storyboard?.instantiateViewController(withIdentifier: "ScanID") as! ScanCodeViewController
        idScanner.dataDelegate = self
        self.navigationController?.showDetailViewController(idScanner, sender: self)
    }
    
    func sendMetadata(_ sender: ScanCodeViewController, metadata: [String : Any]) {
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
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let scanner = IRLScannerViewController.standardCameraView(with: self)
        scanner.showControls = true
        scanner.showAutoFocusWhiteRectangle = true
        present(scanner, animated: true, completion: nil)
        // Your action
    }
    
    var editCard: Card!
    var dataConnect: CoreDataConnect!
    var appDelegate: AppDelegate!
    var context: NSManagedObjectContext!
    
    @IBOutlet weak var mainView: CardEditorTableView!
    @IBAction func saveUpdate(_ sender: Any) {
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
        self.dataConnect = CoreDataConnect(context: context)
        let success = dataConnect.updateCard(cardID: self.editCard.id!, updateData: mainView.cardData)
        if (!success) {
            print("cannot update the card!")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelUpdate(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.populateCardData(card: editCard)
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
        self.dataConnect = CoreDataConnect(context: context)
        let cardFaceImageView = mainView.cardImageHolderRow.cell.CardImageHolder
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        cardFaceImageView!.isUserInteractionEnabled = true
        mainView.cardIDRow.cell.scanDelegate = self
        mainView.cardImageHolderRow.cell.CardImageHolder.addGestureRecognizer(tapGestureRecognizer)
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
