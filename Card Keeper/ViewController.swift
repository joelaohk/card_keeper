//
//  ViewController.swift
//  Card Keeper
//
//  Created by Joe Lao on 23/4/2018.
//  Copyright © 2018 Joe Lao. All rights reserved.
//

import UIKit
import Former
import CoreData

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var allCards: [Card]!
    var dataConnector: CoreDataConnect?
    var appDelegate: AppDelegate!
    var context: NSManagedObjectContext!
    
    @IBAction func unwindToMain(segue:UIStoryboardSegue) { }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let cards = allCards {
            return cards.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        guard let cardData = allCards[indexPath.row].image else {
            return cell
        }
        guard let cardImage = UIImage(data: cardData) else {
            return cell
        }
        let cardImageView = cell.viewWithTag(1) as! UIImageView
        cardImageView.image = cardImage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detailCardVC = mainStoryboard.instantiateViewController(withIdentifier: "CardDetail") as! CardDetailViewController
        detailCardVC.selectedCard = allCards[indexPath.row]
        self.navigationController?.pushViewController(detailCardVC, animated: true)
    }
    
    func initDataConnector() {
        self.dataConnector = CoreDataConnect(context: context)
    }
    
    func getCards() {
        self.allCards = dataConnector?.retrieveCards()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
        self.initDataConnector()
        self.getCards()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

