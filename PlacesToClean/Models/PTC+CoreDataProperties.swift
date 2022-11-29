//
//  PTC+CoreDataProperties.swift
//  PlacesToClean
//
//  Created by AGUS ROMERO on 27/11/22.
//
//

import Foundation
import CoreData


extension PTC {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PTC> {
        return NSFetchRequest<PTC>(entityName: "PTC")
    }

    @NSManaged public var deletedDate: Date?
    @NSManaged public var desc: String?
    @NSManaged public var id: Int32
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var title: String?
    @NSManaged public var type: Int16
    @NSManaged public var image: Data?

}

extension PTC : Identifiable {

}
