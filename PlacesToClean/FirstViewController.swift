//
//  FirstViewController.swift
//  PlacesToClean
//
//  Created by AGUS ROMERO on 9/11/22.
//

import UIKit
import CoreData

class FirstViewController: UITableViewController {
    
    let m_places_manager: ManagerPlaces = ManagerPlaces.shared
    let m_display_manager: ManagerDisplay = ManagerDisplay.shared()
    let m_location_manager: ManagerLocation = ManagerLocation.shared()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view: UITableView = (self.view as? UITableView)!
        view.delegate = self
        view.dataSource = self
        
        // nos subscribimos al reload
        m_places_manager.reload = {
            self.onPlacesChange()
        }
        
        applyTheme()
    }
        
    func applyTheme() {
        tableView.backgroundColor = UIColor(named: "secondaryColor")
        tableView.separatorColor = UIColor(named: "greyPrimary")
        
        //self.navigationController?.navigationBar.isTranslucent = true
        //self.navigationController?.navigationBar.barStyle = .black
        //self.navigationController?.navigationBar.tintColor = UIColor(named: "primaryColor")

        // Apply NavBar controller
        let newNavBarAppearance = customNavBarAppearance()
        navigationController!.navigationBar.scrollEdgeAppearance = newNavBarAppearance
        navigationController!.navigationBar.compactAppearance = newNavBarAppearance
        navigationController!.navigationBar.standardAppearance = newNavBarAppearance
        if #available(iOS 15.0, *) {
            navigationController!.navigationBar.compactScrollEdgeAppearance = newNavBarAppearance
        }
        
        // Apply TabBar controller
        self.tabBarController?.tabBar.barTintColor = UIColor(named: "secondaryColor")
        self.tabBarController?.tabBar.tintColor = .white
    }

    func customNavBarAppearance() -> UINavigationBarAppearance {
        let customNavBarAppearance = UINavigationBarAppearance()
        
        // Apply background
        customNavBarAppearance.backgroundColor = UIColor(named: "tertiaryColor")
        // Apply white colored normal and large titles.
        customNavBarAppearance.titleTextAttributes = [.foregroundColor: UIColor(named: "secondaryInvColor")!]
        customNavBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "secondaryInvColor")!]

        // Apply white color to all the nav bar buttons.
        let barButtonItemAppearance = UIBarButtonItemAppearance(style: .plain)
        barButtonItemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
        barButtonItemAppearance.disabled.titleTextAttributes = [.foregroundColor: UIColor.lightText]
        barButtonItemAppearance.highlighted.titleTextAttributes = [.foregroundColor: UIColor.label]
        barButtonItemAppearance.focused.titleTextAttributes = [.foregroundColor: UIColor.white]
        customNavBarAppearance.buttonAppearance = barButtonItemAppearance
        customNavBarAppearance.backButtonAppearance = barButtonItemAppearance
        customNavBarAppearance.doneButtonAppearance = barButtonItemAppearance
        
        return customNavBarAppearance
    }
    
    
    //Protocolo Tabla
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        m_places_manager.places.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Sirve para indicar subsecciones de la lista. En nuestro caso devolvemos
        // 1 porque no hay subsecciones.
        1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Detectar pulsación en un elemento.
        let place = m_places_manager.places[indexPath.row]
        performSegue(withIdentifier: "goToDetails", sender: place)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Devolver la altura de la fila situada en una posición determinada.
        100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let celda = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath) as? PlaceCell else { return UITableViewCell() }
        
        let place = m_places_manager.places[indexPath.row]
        
        celda.placeTitleLabel.text = place.title
        celda.placeSubtitleLabel.text = place.desc
        celda.applyTheme()
        
        if let image = place.image {
            celda.placeImageView.image = UIImage(data: image)
        } else {
            celda.placeImageView.image = nil
        }
        
        return celda
        
    }
    
    func onPlacesChange() {
        let view: UITableView = (self.view as? UITableView)!
        view.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        if segue.identifier == "goToDetails",
           let viewController = segue.destination as? DetailController {
            viewController.place = sender as? PTC
            viewController.handler = {
                self.m_places_manager.loadData()
            }
        }
    }
}
