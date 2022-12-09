//
//  SecondViewController.swift
//  MyPlaces
//
//  Created by user143154 on 9/20/18.
//  Copyright © 2018 user143154. All rights reserved.
//

import UIKit
import MapKit

class PlaceAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var image: UIImage?
    var eta: String?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}


class SecondViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var m_map: MKMapView!
    
    let m_location_manager: ManagerLocation = ManagerLocation.shared()
    let m_places_manager: ManagerPlaces = ManagerPlaces.shared
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
       
        self.m_map.mapType = MKMapType.standard
        self.m_map.delegate = self
        
        self.m_map.showsUserLocation = true

        m_places_manager.reload = {
            // TODO reload mapa
            print ("Reload Map2")
            self.RemoveMarkers()
            self.AddMarkers()
        }
  
        print ("Reload Map1")
        AddMarkers()
        
        applyTheme()
    }
        
    func applyTheme() {
        ThemeManager.applyTabControllerTheme(self.tabBarController)
        ThemeManager.applyNavBarControllerTheme(self.navigationController)
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "colorText1")
    }

    func RemoveMarkers(){

        let lista = self.m_map.annotations.filter { !($0 is MKUserLocation) }
        self.m_map.removeAnnotations(lista)
    }
    
    func AddMarkers(){
        
        for i in 0..<m_places_manager.places.count {
            print (m_places_manager.places.count)
            let item = m_places_manager.places[i]

            let title:String = item.title ?? ""
            let id:String = "\(item.id)"
            let lat:Double = item.latitude
            let lon:Double = item.longitude
            
            let annotation: MKMyPointAnnotation = MKMyPointAnnotation(coordinate:
                CLLocationCoordinate2D(latitude: lat, longitude: lon), title: title, place_id: id)
            
            self.m_map.addAnnotation(annotation)
        }
                
        m_map.showAnnotations(m_map.annotations, animated: true)
    }
/*
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if let annotation = annotation as? MKMyPointAnnotation {
            let identifier = "CustomPinAnnotationView"
            var annotationView: MKPinAnnotationView
            if let dequeuedView = self.m_map?.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                annotationView = dequeuedView
            }
            else
            {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier:identifier)
                annotationView.canShowCallout = true
                annotationView.calloutOffset = CGPoint(x: -5, y: 5)
                annotationView.rightCalloutAccessoryView = UIButton(type:.detailDisclosure) as UIView
                annotationView.setSelected(true,animated: true)
            }
            return annotationView
        }
        return nil
    }
    */
    
       func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

           guard annotation is MKMyPointAnnotation else { return nil }
           let identifier = "Annotation"
           var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
           if annotationView == nil {
               annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
               annotationView!.canShowCallout = true
           } else {
               annotationView!.annotation = annotation
           }
          return annotationView
       }
       		

    /*
     
     func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
         
         if annotation is MKUserLocation {
             return nil
         }
         else
         if let annotation = annotation as? MKMyPointAnnotation
         {
             let identifier = "CustomAnnotationView"
             var pinView =     MKAnnotationView(annotation: annotation, reuseIdentifier: "customannotation")

             if let dequeuedView =
                 self.m_map?.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
                 dequeuedView.annotation = annotation
                 pinView = dequeuedView
                 
             } else {
                 
                 //Localizamos el place para usar información
                 let place_id:String = annotation.place_id
                 let place = m_places_manager.GetItemById(id: Int32(annotation.place_id) ?? 0)
                 
                  // Left accessory
                 var pinImage = UIImage(named: "info") // Default value
                 var pinSubtitle = "" // Default value
                 //if ((place.type) == .GenericPlace){ pinImage = UIImage(named: "infoblue"); pinSubtitle = "Generic Place"}
                 //if ((place.type) == .TouristicPlace){ pinImage = UIImage(named: "infored"); pinSubtitle = "Touristic Place"}
                 
                 let pinButton = UIButton(type: .custom)
                 pinButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                 pinButton.setImage(pinImage, for: UIControl.State())
  
                 // Right Accessory
                 let pinAccessory = UITextView(frame: CGRect(x: 0,y: 0,width: 50,height: 40))
                 pinAccessory.backgroundColor = UIColor.black
                 pinAccessory.text = pinSubtitle
                 pinAccessory.textAlignment = .center
                 pinAccessory.font = UIFont(name: "HelveticaNeue", size: 10)
                 pinAccessory.textColor = .lightGray
                 
                 //Draw Pin Annotation
                 pinView.image = UIImage(named:"purplepin")
                 pinView.canShowCallout = true
                 pinView.calloutOffset = CGPoint(x: -5, y: 5)
                 pinView.leftCalloutAccessoryView = pinButton
                 pinView.rightCalloutAccessoryView = pinAccessory
                 //pinView.setSelected(true,animated: true)
                 
                 //annotation.subtitle = pinSubtitle
             }
             return pinView
         }
         return nil
     }

     */

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        
        if let annotation = view.annotation as? MKMyPointAnnotation
        {
            print("Place seleccionado == \(String(describing: view.annotation?.title!))")
            
            if(self.m_location_manager.GetLocation() != nil){
                let annotation:MKMyPointAnnotation  = view.annotation as! MKMyPointAnnotation
                let current_loc_tmp:CLLocationCoordinate2D  = self.m_location_manager.GetLocation()
                let current_loc = CLLocation(latitude: current_loc_tmp.latitude, longitude: current_loc_tmp.longitude)
                let obj_loc:CLLocation = CLLocation(latitude: annotation.coordinate.latitude,longitude: annotation.coordinate.longitude)
                let distance:CLLocationDistance = (current_loc.distance(from: obj_loc))
                annotation.subtitle = String(format: "distance: %.2f m", distance)
            }
            
            for v in view.subviews {
                if v.subviews.count > 0 {
                    v.subviews[0].backgroundColor = UIColor.green
                    v.subviews[0].alpha = 0.8
                }
            }
            
            self.ReplaceColorText(v:view)
        }
    }


    func mapView(_ mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let annotation:MKMyPointAnnotation = annotationView.annotation as! MKMyPointAnnotation
        
        // Mostrar el DetailController de ese Place
        let place = m_places_manager.GetItemById(id: Int32(annotation.place_id) ?? 0)

        let dc:DetailController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailController") as! DetailController
        dc.place = place
        
        present(dc, animated: true, completion: nil)
        }

    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        let zoom = 0.05
        let region = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: zoom, longitudeDelta: zoom))
        
        self.m_map.setRegion(region, animated: true)
    }
 

    func ReplaceColorText(v:UIView){

        for subview in v.subviews {
            if((subview as? UILabel) != nil) {
                
                (subview as? UILabel)?.textColor = UIColor.blue
            }
            else
            {
                ReplaceColorText(v:subview)
            }
        }
    }

      func onPlacesChange(){
        self.RemoveMarkers()
        self.AddMarkers()
    }
 }
