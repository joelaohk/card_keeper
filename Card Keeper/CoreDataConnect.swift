//
//  CoreDataConnect.swift
//  Card Keeper
//
//  Created by Joe Lao on 23/4/2018.
//  Copyright © 2018 Joe Lao. All rights reserved.
//

import Foundation
import CoreData



class CoreDataConnect {
    var context: NSManagedObjectContext!
    typealias cardType = Card
    let entityName = "Card"
    
    init(context:NSManagedObjectContext) {
        self.context = context
    }
    
    func addCard(data:[String:AnyObject]) -> Bool {
        let the_id = UUID()
        
        let insertion = NSEntityDescription.insertNewObject(forEntityName: self.entityName, into: self.context) as! cardType
        insertion.setValue(the_id, forKey: "id")
        for (key,value) in data {
            insertion.setValue(value, forKey: key)
        }
        
        do {
            try context.save()
            return true
        } catch {
            fatalError("Some stuff happened")
        }
        return false
    }
    
    func retrieveCards() -> [Card] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        do {
            let results = try context.fetch(request) as! [Card]
            return results
        } catch {
            fatalError("Cannot retrieve card")
        }
        return []
    }
    
    func deleteCard(cardID:UUID) -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        request.predicate = NSPredicate(format: "id = \(cardID)")
        do {
            let results = try context.fetch(request) as! [Card]
            for result in results {
                context.delete(result)
            }
            try context.save()
            return true
        } catch {
            fatalError("Cannot delete card")
        }
        return false
    }
    
    func updateCard(cardID:UUID, updateData:[String:AnyObject]) -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        request.predicate = NSPredicate(format: "id = \(cardID)")
        do {
            let results = try context.fetch(request) as! [Card]
            if results.count > 0 {
                for (key,value) in updateData {
                    results[0].setValue(value, forKey: key)
                }
                try context.save()
                return true
            }
        } catch {
            fatalError("Cannot update card")
        }
        return false
    }
    
}
