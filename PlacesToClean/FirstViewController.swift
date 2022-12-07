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
        //Apply TableView controller
        self.view.backgroundColor =  .white //UIColor(named: "colorMain2")
        self.tableView.backgroundColor = UIColor(named: "colorMain2")
        self.tableView.separatorColor = UIColor(named: "colorText1")

         
        /* OLD DESIGN
         vc.navigationController?.navigationBar.isTranslucent = true
         vc.navigationController?.navigationBar.barStyle = .black
         vc.navigationController?.navigationBar.tintColor = .white
         vc.navigationItem.rightBarButtonItem?.image = UIImage(named: "pinplus1")

         let logo = UIImage(named: "myplaces_logo")
         let imageView = UIImageView(frame: CGRect(x: 300, y: 0, width: 400, height: 150))
         imageView.contentMode = .scaleAspectFit
         imageView.image = logo
         vc.navigationItem.titleView = imageView
        */

        // Apply TabBar controller
        self.tabBarController?.tabBar.barTintColor =  UIColor(named: "colorMain2") // Color Fondo
        self.tabBarController?.tabBar.isOpaque = true
        self.tabBarController?.tabBar.tintColor = UIColor(named: "colorText1") // Color Activo
        self.tabBarController?.tabBar.unselectedItemTintColor = UIColor(named: "colorText2") // Color inactivo

        //Apply external border
        self.tabBarController!.tabBar.layer.borderWidth = 0.50
        self.tabBarController!.tabBar.layer.borderColor = UIColor(named: "colorText1")?.cgColor
        self.tabBarController?.tabBar.clipsToBounds = true
        //Apply Separator between tabs
        let itemWidth = floor(self.tabBarController!.tabBar.frame.size.width / CGFloat(self.tabBarController!.tabBar.items!.count))
        let separatorWidth: CGFloat = 0.5
        let separator = UIView(frame: CGRect(x: itemWidth * CGFloat(1) - CGFloat(separatorWidth / 2), y: 0, width: CGFloat(separatorWidth), height: self.tabBarController!.tabBar.frame.size.height))
        separator.backgroundColor = UIColor(named: "colorText1")
        self.tabBarController!.tabBar.addSubview(separator)
        
        // Apply NavBar controller
        let appearance = UINavigationBarAppearance()
        // This will change the navigation bar background color
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor =  UIColor(named: "colorMain1")
        // This will alter the navigation bar title appearance
        appearance.titleTextAttributes = [NSAttributedString.Key.font:  UIFont.systemFont(ofSize: 18, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.init(named: "colorText1") as Any]

        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
 
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "colorText1")

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
