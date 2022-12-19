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
        
        // ens subscrivim al reload
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadView), name: NSNotification.Name(rawValue: "reload"), object: nil)
           
        applyTheme()
    }
    
    @objc
    func reloadView(notif: NSNotification) {
        onPlacesChange()
    }
    
    func applyTheme() {
        ThemeManager.applyTabControllerTheme(self.tabBarController)
        ThemeManager.applyNavBarControllerTheme(self.navigationController, navigationItem)

        //Apply TableView controller
        self.tableView.backgroundColor = UIColor(named: "colorMain1")
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        self.tableView.separatorColor = UIColor(named: "colorText1")
    }
    
    // Protocol Tabla
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        m_places_manager.places.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Serveix per a indicar subseccions de la llista. En el nostre cas retornem
        // 1 perque no hi ha subseccions.
        1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deseleccionem l'element triat
        tableView.deselectRow(at: indexPath, animated: true)

        // Detectem la polsació en un element.
        let place = m_places_manager.places[indexPath.row]
        performSegue(withIdentifier: "goToDetails", sender: place)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Tornem l'alçada de la fila de la taula
        80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let celda = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath) as? PlaceCell else { return UITableViewCell() }

        let place = m_places_manager.places[indexPath.row]
        
        celda.placeTitleLabel.text = place.title
        
        let typeName = NSLocalizedString(ManagerPlaces.shared.listItemType[Int(place.type)], comment: "")
        celda.placeSubtitleLabel.text = typeName
        celda.applyTheme()
        
        if let image = place.image {
            celda.placeImageView.image = UIImage(data: image)
        } else {
            celda.placeImageView.image = nil
        }

        return celda
        
    }
    
    func onPlacesChange() {
        ManagerPlaces.shared.loadData()
        let view: UITableView = (self.view as? UITableView)!
        view.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        if segue.identifier == "goToDetails",
           let viewController = segue.destination as? DetailController {
            viewController.place = sender as? PTC            
        }
    }
}
