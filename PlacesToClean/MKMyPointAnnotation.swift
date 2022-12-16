//
//  MKMyPointAnnotation.swift
//  PlacesToClean
//
//  Created by AGUS ROMERO on 26/11/22.
//

import UIKit
import Foundation
import MapKit

class MKMyPointAnnotation: NSObject,MKAnnotation
{
    public var coordinate: CLLocationCoordinate2D
    public var title:String?
    public var subtitle:String?
    public var type:String?
    public var img:UIImage
    public var place_id:String = ""
    
    
    init(coordinate: CLLocationCoordinate2D,title:String,subtitle:String, type:String, img:Data, place_id:String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.type = type
        self.img = UIImage(data: img)!
        self.place_id = place_id
    }
}
