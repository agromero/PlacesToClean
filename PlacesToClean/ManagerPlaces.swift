//
//  ManagerPlaces.swift
//  PlacesToClean
//
//  Created by AGUS ROMERO on 9/11/22.
//

import Foundation
import CoreData
import UIKit

class ManagerPlaces {

    var places: [PTC] = []
    
    
    //******************************
    //Singleton
    //
    static var shared = ManagerPlaces()
    //******************************

    var reload: (() -> Void)?
    
    init() {
        loadData()
    }
    
    func loadData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        guard let data = fetchRecordsForEntity("PTC", inManagedObjectContext: context) as? [PTC] else { return }
        self.places = data
        reload?()
    }
    
    private func fetchRecordsForEntity(_ entity: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> [NSManagedObject] {
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
   
    func GetItemById(id: Int32) -> PTC {
        places.filter( { $0.id == id})[0]
    }
}

