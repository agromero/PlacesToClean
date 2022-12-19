//
//  ManagerLocation.swift
//  MyPlaces
//
//  Created by AGUS ROMERO on 15/11/22.
//
import Foundation
import MapKit
import UserNotifications

class ManagerLocation: NSObject, CLLocationManagerDelegate
{
    var m_locationManager:CLLocationManager!
    
    var firstTime:Bool = true
    
    
    private static var sharedManagerLocation: ManagerLocation = {
        
        var singletonManager:ManagerLocation?
        
        if(singletonManager == nil) {
            singletonManager = ManagerLocation()
            
            singletonManager!.m_locationManager = CLLocationManager()
            
            singletonManager!.m_locationManager.delegate = singletonManager
            
            // Permetre updates en background
            singletonManager!.m_locationManager.allowsBackgroundLocationUpdates = true
            // Minima distancia per a que detecti cavi de posició = 500 metros
            singletonManager!.m_locationManager.distanceFilter = 500
            // Fem servir la forma més optima per a calcular la geolocalització.
            singletonManager!.m_locationManager.desiredAccuracy = kCLLocationAccuracyBest

            let status: CLAuthorizationStatus = singletonManager!.m_locationManager.authorizationStatus

            //Comprovar si l'aplicació te permiso per a obtenir la posició de l'usuari
            if (status == CLAuthorizationStatus.notDetermined){
                singletonManager!.m_locationManager.requestWhenInUseAuthorization()
            }
            else{
                singletonManager!.startLocation()
	            }

            //Demanem permis per a activar les notificacions locals
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound, .badge])
            { (granted, error) in
                // Habilitar o deshabilitar funcionalitats depenent del permis
            }
        }
        return singletonManager!
    }()


class func shared() -> ManagerLocation {
        return sharedManagerLocation
    }
    
    
    func startLocation() {
        self.m_locationManager.startUpdatingLocation()
    }

    
    public func GetLocation()->CLLocationCoordinate2D {
        return (self.m_locationManager!.location?.coordinate)!
    }


    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        
        if (status == .authorizedWhenInUse) {
            self.m_locationManager.startUpdatingLocation()
        }
    }
    
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
            
        if(firstTime){
            // Notificación de proximidad
            let content = UNMutableNotificationContent()
            content.title = NSLocalizedString("contentTitle", comment: "")
            content.subtitle = NSLocalizedString("contentSubtitle", comment: "")
            content.body = NSLocalizedString("contentBody", comment: "")
            content.badge = 1
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let requestIdentifier = "demoNotification"
            let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request,withCompletionHandler: { (error) in })
            // Handle error

            firstTime = true;
        }
    }
    
}
