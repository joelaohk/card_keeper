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

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate {
    
    var allCards: [Card]!
    var dataConnector: CoreDataConnect?
    var appDelegate: AppDelegate!
    var context: NSManagedObjectContext!

    
    @IBOutlet weak var cardCollection: UICollectionView!
    @IBAction func unwindToMain(segue:UIStoryboardSegue) { }
    
    @objc func handleLongPress(recogniser: UILongPressGestureRecognizer) {
        if (recogniser.state == .began) {
            let location = recogniser.location(in: self.cardCollection)
            let indexPath = self.cardCollection.indexPathForItem(at: location)
            if let index = indexPath {
                let card = self.allCards[index.item]
                
                let cardName: String
                if let name = card.name {
                    cardName = name
                } else {
                    cardName = ""
                }
                
                let alertController = UIAlertController(title: "Delete card",
                                                        message: "Are your sure you want to delete card " + cardName + " ?",
                                                        preferredStyle: .actionSheet)
                let yesAction = UIAlertAction(title: "Yes", style: .default, handler: {
                    _ in
                    self.dataConnector?.deleteCard(cardID: card.id!)
                    self.getCards()
                    self.cardCollection.reloadData()
                })
                let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
                alertController.addAction(yesAction)
                alertController.addAction(noAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
    }
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
        cardImageView.layer.cornerRadius = 15
        cardImageView.layer.masksToBounds = true
        cardImageView.image = cardImage
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "seeDetail") {
            let detailCardVC = segue.destination as! CardDetailViewController
            let selected = sender as! UICollectionViewCell
            let count = self.cardCollection.indexPath(for: selected)?.item
            detailCardVC.selectedCard = allCards[count!]
        }
    }
    
    func initDataConnector() {
        self.dataConnector = CoreDataConnect(context: context)
    }
    
    func getCards() {
        self.allCards = dataConnector?.retrieveCards()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getCards()
        if let collect = self.cardCollection {
            collect.reloadData()
        }
        
        let recogniser = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.handleLongPress))
        recogniser.minimumPressDuration = 0.5
        recogniser.delaysTouchesBegan = true
        recogniser.delegate = self
        self.cardCollection.addGestureRecognizer(recogniser)
        
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

