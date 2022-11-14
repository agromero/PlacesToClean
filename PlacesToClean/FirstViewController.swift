//
//  FirstViewController.swift
//  PlacesToClean
//
//  Created by AGUS ROMERO on 9/11/22.
//

import UIKit

class FirstViewController: UITableViewController {
    
    let m_provider = ManagerPlaces.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view: UITableView = (self.view as? UITableView)!;
        view.delegate = self
        view.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    //Protocolo Tabla
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // Número de elmentos del manager
        
        return m_provider.GetCount()
        //return 2
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Sirve para indicar subsecciones de la lista. En nuestro caso devolvemos
        // 1 porque no hay subsecciones.
        return 1;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Detectar pulsación en un elemento.
        
        let place: Place = self.m_provider.GetItemAt(position: indexPath.row)
        
        let dc:DetailController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailController") as! DetailController
        dc.place = place
        present(dc, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Devolver la altura de la fila situada en una posición determinada.
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // devolver una instancia de la clase UITableViewCell que pinte la fila
        //seleccionada.
        
        let celda = UITableViewCell(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: tableView.frame.size.width, height: 100)))
        
        celda.textLabel?.text = m_provider.GetItemAt(position: indexPath.row).name
        
        //No funciona per pintar el subtítol
        //celda.detailTextLabel?.text =  m_provider.GetItemAt(position: indexPath.row).description

        return celda
    }
    
}

