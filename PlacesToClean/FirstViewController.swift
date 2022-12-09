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
        ThemeManager.applyTabControllerTheme(self.tabBarController)
        ThemeManager.applyNavBarControllerTheme(self.navigationController)

        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "colorText1")

        //Apply TableView controller
        self.tableView.backgroundColor = UIColor(named: "colorMain2")
        self.tableView.separatorColor = UIColor(named: "colorText1")
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
        80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let celda = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath) as? PlaceCell else { return UITableViewCell() }

        let listItemType = ["General", "Aceras", "Grafitti/Pintura", "Cristales", "Mobiliario", "Escombros", "Basura", "Maleza"]
        
        let place = m_places_manager.places[indexPath.row]
        
        celda.placeTitleLabel.text = place.title
        celda.placeSubtitleLabel.text = listItemType[Int(place.type)]
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
