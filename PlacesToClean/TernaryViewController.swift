//
//  TernaryViewController.swift
//  PlacesToClean
//
//  Created by AGUS ROMERO on 6/12/22.
//

import UIKit

class TernaryViewController: UIViewController {
    override func viewDidLoad() {

        view.backgroundColor = .yellow
        //applyTheme()
    }
    
    func applyTheme() {

        
        // Apply NavBar controller
        
        UINavigationBar.appearance().backgroundColor = .green // backgorund color with gradient
        // or
        UINavigationBar.appearance().barTintColor = .green  // solid color
        UIBarButtonItem.appearance().tintColor = .magenta
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.blue]
        
        
        // This will change the navigation bar background color
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.green
                
        // This will alter the navigation bar title appearance
        let titleAttribute = [NSAttributedString.Key.font:  UIFont.systemFont(ofSize: 25, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.purple] //alter to fit your needs
        appearance.titleTextAttributes = titleAttribute

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

    }
}
