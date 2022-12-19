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
        
        tabController?.tabBar.isOpaque = false
        tabController?.tabBar.barTintColor =  UIColor(named: "colorMain2") // Color de Fons
        
        // TabBar Items colors
        tabController?.tabBar.tintColor = UIColor(named: "colorText1") // Color Item Actiu
        tabController?.tabBar.unselectedItemTintColor = UIColor(named: "colorText2") // Color Item inactiu
    }
    
    static func applyNavBarControllerTheme(_ navController: UINavigationController?, _ navigationItem: UINavigationItem?) {
        // Appliquem el NavBar controller
        let appearance = UINavigationBarAppearance()
        // Això canviarà el color de fons de la navigation bar
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor =  UIColor(named: "colorMain1")
        
        // Això canviarà l'aparença del titol de la navigation bar
        appearance.titleTextAttributes = [NSAttributedString.Key.font:  UIFont.systemFont(ofSize: 18, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.init(named: "colorText1") as Any]
        navController?.navigationBar.standardAppearance = appearance
        navController?.navigationBar.scrollEdgeAppearance = appearance
        navController?.navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "colorText1")
        navController?.navigationController?.navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "colorText1")
        
        addNavBarImage(navigationItem)
    }

    static private func addNavBarImage(_ navigationItem: UINavigationItem?){
        let logo = UIImage(named: "navBarLogo")
        let imageView = UIImageView(frame: CGRect(x: 300, y: 0, width: 400, height: 150))
        imageView.contentMode = .scaleAspectFit
        imageView.image = logo
        navigationItem?.titleView = imageView

        navigationItem?.rightBarButtonItem?.tintColor = UIColor(named: "colorText1")

    }
}



