//
//  ManagerPlaces.swift
//  PlacesToClean
//
//  Created by AGUS ROMERO on 9/11/22.
//

import Foundation
import CoreData
import UIKit

public class ManagerPlaces {

    //PlacesType Name
    public let listItemType = [
        NSLocalizedString("pvElem1", comment: ""),
        NSLocalizedString("pvElem2", comment: ""),
        NSLocalizedString("pvElem3", comment: ""),
        NSLocalizedString("pvElem4", comment: ""),
        NSLocalizedString("pvElem5", comment: ""),
        NSLocalizedString("pvElem6", comment: ""),
        NSLocalizedString("pvElem7", comment: ""),
        NSLocalizedString("pvElem8", comment: "")]

    public var places: [PTC] = []
    
    
    //******************************
    //Singleton
    //
    static public var shared = ManagerPlaces()
    //******************************

    
    public init() {
        loadData()
    }
    
    public func loadData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        guard let data = fetchRecordsForEntity("PTC", inManagedObjectContext: context) as? [PTC] else { return }
        self.places = data
    }
    
    public func fetchRecordsForEntity(_ entity: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> [NSManagedObject] {
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)

        // Helpers
        var result = [NSManagedObject]()

        do {
            // Execute Fetch Request
            let records = try managedObjectContext.fetch(fetchRequest)

            if let records = records as? [NSManagedObject] {
                result = records
            }

        } catch {
            print("Unable to fetch managed objects for entity \(entity).")
        }

        return result
    }
   
    public func GetItemById(id: Int32) -> PTC? {
        places.first( where: { $0.id == id})
    }
}

