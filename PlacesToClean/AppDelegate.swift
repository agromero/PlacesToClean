//
//  AppDelegate.swift
//  PlacesToClean
//
//  Created by AGUS ROMERO on 1/11/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let manager: ManagerPlaces = ManagerPlaces.shared

        let pl1 = Place(name: "Title Place1", description: "Esta es la descipción del Place 1, todavía falta contenido, pero por ahora es suficiente con este texto de prueba para comprobar que se visualiza correctamente por pantalla", image_in: nil)
        let pl2 = Place(name: "Title Place2", description: "Aqui se tiene que poner la descripción del Place 2, ya que es un lugar increíble que nadie debe perderse, os lo recomiendo 100% si tenéis la oportunidad de visitarlo", image_in: nil)
        let pl3 = Place(name: "Title Place3", description: "El Place 3 es sin duda uno de los mejores lugares que podéis encontrar en esta app, aunque de momento solamente está disponible este texto de prueba.", image_in: nil)
        let pl4 = Place(name: "Title Place4", description: "Aqui está el Place 4, con su texto de prueba y unas pocas palabras para rellenar este espacio provisional donde irá la descripción real del sitio.", image_in: nil)
        manager.append(pl1)
        manager.append(pl2)
        manager.append(pl3)
        manager.append(pl4)
                
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


