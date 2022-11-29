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
        case General
        case Sidewalk
        case Grafitti
        case Window
        case Furniture
        case Debris
        case Litter
        case Weeding
    }
    
    var id:String = ""
    var type:PlacesTypes = .General
    var name:String = ""
    var description:String = ""
    var location: CLLocationCoordinate2D!
    var image:Data? = nil
    
    init()
    {
        
    }
    
    init(name:String, description:String, image_in:Data?)
    {
        self.id = UUID().uuidString
        self.name = name
        self.description = description
        self.image = image_in
    }
    
    init(type:PlacesTypes, name:String, description:String, image_in:Data?)
    {
        self.id = UUID().uuidString
    }
    
}
