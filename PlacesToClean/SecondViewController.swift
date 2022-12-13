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
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadView), name: NSNotification.Name(rawValue: "reload"), object: nil)
                
        print ("Reload Map1")
        AddMarkers()
        
        addNavBarImage()
        applyTheme()
    }

    func addNavBarImage() {
        let logo = UIImage(named: "navBarLogo")
        let imageView = UIImageView(frame: CGRect(x: 300, y: 0, width: 400, height: 150))
        imageView.contentMode = .scaleAspectFit
        imageView.image = logo
        navigationItem.titleView = imageView
 }
    
    @objc func reloadView() {
        print ("Reload Map2")
        self.RemoveMarkers()
        self.AddMarkers()
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
            let subtitle:String = item.description
            let type = "TYPE"
            //NSLocalizedString(ManagerPlaces.shared.listItemType[i], comment: "")
            let img:Data = item.image!
            let id:String = "\(item.id)"
            let lat:Double = item.latitude
            let lon:Double = item.longitude
            
            let annotation: MKMyPointAnnotation = MKMyPointAnnotation(coordinate:
                CLLocationCoordinate2D(latitude: lat, longitude: lon), title: title, subtitle: subtitle, type: type, img: img, place_id: id)
  
            self.m_map.addAnnotation(annotation)
        }
        
        m_map.showAnnotations(m_map.annotations, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{

        if annotation is MKUserLocation {
            return nil
        }
        else
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
                
                //Localizamos el place para usar información
                let place_id:String = annotation.place_id
                let place = m_places_manager.GetItemById(id: Int32(annotation.place_id) ?? 0)
                var pinType = "" // Default value

                //Calculamos la distancia entre el place y nuestra ubicación
                let current_loc_tmp:CLLocationCoordinate2D  = self.m_location_manager.GetLocation()
                let current_loc = CLLocation(latitude: current_loc_tmp.latitude, longitude: current_loc_tmp.longitude)
                let obj_loc:CLLocation = CLLocation(latitude: annotation.coordinate.latitude,longitude: annotation.coordinate.longitude)
                let distance:CLLocationDistance = (current_loc.distance(from: obj_loc))
                let dist = NSLocalizedString("distance", comment: "") + " %.2f m"

                // Left accessory
	            var accesoryImage = annotation.img
                //Creamos un botón en la imagen
                let leftAccessory = UIButton(type: .custom)
                leftAccessory.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                leftAccessory.setImage(accesoryImage, for: UIControl.State())

                // Right Accessory
                let rightAccessory = UITextView(frame: CGRect(x: 0,y: 0,width: 50,height: 40))
                rightAccessory.allowsEditingTextAttributes = false
                rightAccessory.backgroundColor = UIColor.clear
                rightAccessory.text = annotation.type
                rightAccessory.textAlignment = .center
                rightAccessory.font = UIFont(name: "HelveticaNeue", size: 10)
                rightAccessory.textColor = UIColor(named: "colorText1")
              
                //Draw Pin Annotation
                annotationView.image = UIImage(named:"greenpin")
                annotationView.canShowCallout = true
                annotationView.calloutOffset = CGPoint(x: -5, y: 5)
                annotationView.leftCalloutAccessoryView = leftAccessory
                annotation.title = place?.title
                annotation.subtitle = String(format: dist, distance)
                annotationView.rightCalloutAccessoryView = rightAccessory
            }
            return annotationView
        }
        self.ReplaceColorText(v:view)

        return nil
    }
    

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        
        if let annotation = view.annotation as? MKMyPointAnnotation
        {
            print("Place seleccionado == \(String(describing: view.annotation?.title!))")
            
            for v in view.subviews {
                if v.subviews.count > 0 {
                    //Annotation background color
                    v.subviews[0].backgroundColor = UIColor(named: "colorMain2")
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
                //Annotation Text Color
                (subview as? UILabel)?.textColor = UIColor(named: "colorText1")
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

