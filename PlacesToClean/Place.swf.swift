//
//  Place.swf.swift
//  PlacesToClean
//
//  Created by AGUS ROMERO on 9/11/22.
//

import Foundation
import MapKit

class Place {
    
    enum PlacesTypes {
        case GenericPlace
        case TouristicPlace
        
    }
    
    var id:String = ""
    var type:PlacesTypes = .GenericPlace
    var name:String = ""
    var location: CLLocationCoordinate2D!
    var image:Data? = nil
    
    init()
    {
        
    }
    
    init(name:String, description:String, image_in:Data?)
    {
        self.id = UUID().uuidString
    }
    
    init(type:PlacesTypes, name:String, description:String, image_in:Data?)
    {
        self.id = UUID().uuidString
    }
    
}

class PlaceTourist: Place {
    
    var discount_tourist: String = ""
    
    override init()
    {
        super.init()
        type = .TouristicPlace
    }
    
    init(name:String, description:String, discount_tourist:String, image_in:Data?)
    {
        super.init(type:.TouristicPlace, name: name, description: description, image_in: image_in)
        self.discount_tourist = discount_tourist
    }
}
