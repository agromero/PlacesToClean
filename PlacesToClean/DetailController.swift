//
//  DetailController.swift
//  PlacesToClean
//
//  Created by AGUS ROMERO on 9/11/22.
//

import UIKit
import CoreData

class DetailController: UIViewController, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate
{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!

    @IBOutlet weak var viewPicker: UIPickerView!
    @IBOutlet weak var imagePicked: UIImageView!
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textDescription: UITextView!
 
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    var keyboardHeight:CGFloat!
    var activeField: UIView!
    var lastOffset:CGPoint!
    
    var place: PTC? = nil
    
    var handler: (() -> Void)?
    
    // Places types english
    //let pickerElems1 = ["General", "Sidewalk", "Grafitti/Pintura", "Window", "Furniture", "Debris", "Litter", "Weeding"]
    // Places types spanish
    let pickerElems1 = ["General", "Aceras", "Grafitti/Pintura", "Cristales", "Mobiliario", "Escombros", "Basura", "Maleza"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Sempre mostrem el Picker
        viewPicker.delegate = self
        viewPicker.dataSource = self
        
        if place == nil {
            creationMode()
        } else{
            updateMode()
        }
        
        initKeyboard()
        textName.delegate = self
        textDescription.delegate = self
    }
    
    fileprivate func updateMode() {
        //Quan és un place existent (UPDATE), mostrem:
        btnSave.setTitle("Save", for: .normal)
        btnSave.setTitle("Save", for: .highlighted)
                
        //Premen a la llsta
        textName.text = place!.title
        textDescription.text = place!.desc
        
        if let image = place!.image {
            imagePicked.image = UIImage(data: image)
        }
        
        //Temporalment afegim un border a la imatge mentre no disposem d'imatges
        imagePicked.layer.borderWidth = 1
    }
    
    fileprivate func creationMode() {
        //Es un place Nou (NEW), mostrem els camps a omplir
        btnSave.setTitle("Save", for: .normal)
        btnSave.setTitle("Save", for: .highlighted)
        
        //Ocultem el botó Delete perquè no hem creat encara el Place
        btnDelete.isHidden = true
        
        // Es nou
        textName.placeholder = "Enter Title here"
        textDescription.text = "Enter Description here"
    }
    
    @IBAction func SelectImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary;
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func onSaveButtonPressed(_ sender: Any) {
        saveData()
    }
    
    @IBAction func Delete(_ sender: Any) {
    }

    @IBAction func Cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return pickerElems1.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return pickerElems1[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        view.endEditing(true)
        guard let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as?
                UIImage else { return }
        imagePicked.contentMode = .scaleAspectFit
        imagePicked.image = image
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker:
                                        UIImagePickerController) {
        dismiss(animated:true, completion: nil)
    }
    
    
    @objc func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    {
        activeField = textView
        lastOffset = self.scrollView.contentOffset
        return true
    }
    
    @objc func textViewShouldEndEditing(_ textView: UITextView) -> Bool
    {
        if(activeField==textView) {
            activeField?.resignFirstResponder()
            activeField = nil
        }
        return true
    }
    
    @objc func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        activeField = textField
        lastOffset = self.scrollView.contentOffset
        return true
    }
    
    @objc func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        if(activeField==textField) {
            activeField?.resignFirstResponder()
            activeField = nil
        }
        return true
    }
    
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }

    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }

    
}

extension DetailController {
    
    func initKeyboard() {
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(DetailController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DetailController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
            // if keyboard size is not available for some reason, dont do anything
            return
        }
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height , right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        
        // reset back the content inset to zero after keyboard is gone
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    
}

extension DetailController {
   
    func deleteData() {
        var objectToDelete = place
            
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        objectToDelete?.deletedDate = Date()
        do
        {
            try context.save()
            dismiss(animated: true)
            handler?()
            print("context delete succesfully")
        }
        catch
        {
            print("context save error")
        }
    }
    
    func saveData() {
        let name = textName.text
        let descripcion = textDescription.text
        
        let selectedtype = viewPicker.selectedRow(inComponent: 0)
        let imgdata = imagePicked.image?.jpegData(compressionQuality: 0.75)
        
        let localizationLatitude = ManagerLocation.GetLocation().latitude
        let localizationLongitude = ManagerLocation.GetLocation().longitude
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        var objectToSave: PTC?
        
        if place == nil {
            let entity = NSEntityDescription.entity(forEntityName: "PTC", in: context)
            objectToSave = PTC(entity: entity!, insertInto: context)
        } else {
            objectToSave = place
        }
        
        objectToSave?.title = name
        objectToSave?.desc = descripcion
        objectToSave?.type = Int16(selectedtype)
        objectToSave?.image = imgdata
        objectToSave?.longitude = localizationLongitude
        objectToSave?.latitude = localizationLatitude
        do
        {
            try context.save()
            dismiss(animated: true)
            handler?()
            print("context save succesfully")
        }
        catch
        {
            print("context save error")
        }
    }
}

