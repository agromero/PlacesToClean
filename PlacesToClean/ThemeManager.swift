//
//  ThemeManager.swift
//  PlacesToClean
//
//  Created by AGUS ROMERO on 8/12/22.
//

import UIKit

class ThemeManager {
    static func applyTabControllerTheme(_ tabController: UITabBarController?) {
        // Apply TabBar controller
        tabController?.tabBar.items?[0].title = NSLocalizedString("list", comment: "")
        tabController?.tabBar.items?[1].title = NSLocalizedString("map", comment: "")
        
        tabController?.tabBar.barTintColor =  UIColor(named: "colorMain2") // Color Fondo
        tabController?.tabBar.isOpaque = true
        tabController?.tabBar.tintColor = UIColor(named: "colorText1") // Color Activo
        tabController?.tabBar.unselectedItemTintColor = UIColor(named: "colorText2") // Color inactivo
    }
    
    static func applyNavBarControllerTheme(_ navController: UINavigationController?){
        // Apply NavBar controller
        let appearance = UINavigationBarAppearance()
        // This will change the navigation bar background color
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor =  UIColor(named: "colorMain1")
        
        // This will alter the navigation bar title appearance
        appearance.titleTextAttributes = [NSAttributedString.Key.font:  UIFont.systemFont(ofSize: 18, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.init(named: "colorText1") as Any]
        navController?.navigationBar.standardAppearance = appearance
        navController?.navigationBar.scrollEdgeAppearance = appearance
        navController?.navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "colorText1")
        navController?.navigationController?.navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "colorText1")
    }
    
}


