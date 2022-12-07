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
    @IBOutlet weak var scrollViewInnerView: UIView!
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!

    @IBOutlet weak var viewPicker: UIPickerView!
    @IBOutlet weak var imagePicked: UIImageView!
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textDescription: UITextView!

    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnImage: UIButton!
    @IBOutlet weak var btnPhoto: UIButton!
    
    var keyboardHeight:CGFloat!
    var activeField: UIView!
    var lastOffset:CGPoint!
    
    var place: PTC? = nil
    
    var handler: (() -> Void)?
    
    // Places types english
    //let pickerElems1 = ["General", "Sidewalk", "Grafitti/Pintura", "Window", "Furniture", "Debris", "Litter", "Weeding"]
    // Places types spanish
    let pickerElems1 = ["General", "Aceras", "Grafitti/Pintura", "Cristales", "Mobiliario", "Escombros", "Basura", "Maleza"]
    
    let m_location_manager: ManagerLocation = ManagerLocation.shared()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Sempre mostrem el Picker
        viewPicker.delegate = self
        viewPicker.dataSource = self

        btnCancel.setTitle("Cancel", for: .normal)
        btnCancel.setTitle("Cancel", for: .highlighted)
        btnDelete.setImage(UIImage(named: "trash.fill"), for: .normal)
        
        btnSave.setTitle("Save", for: .normal)
        btnSave.setTitle("Save", for: .highlighted)
        btnPhoto.setTitle("Take Picture", for: .normal)
        btnPhoto.setTitle("Take Picture", for: .highlighted)
        
        if place == nil {
            //Cuando es un nuevo place (CREATE), mostramos:
            btnImage.setTitle("Add Image", for: .normal)
            btnImage.setTitle("Add Image", for: .highlighted)
            //Ocultamos el botón Delete
            btnDelete.isHidden = true
            creationMode()
        } else{
            //Cuando es un place ya existente (UPDATE), mostramos:
            btnImage.setTitle("Change Image", for: .normal)
            btnImage.setTitle("Change Image", for: .highlighted)
            updateMode()
        }
        
        initKeyboard()
        textName.delegate = self
        textDescription.delegate = self
        
        applyTheme()
    }
        
    func applyTheme() {
        //Color de fondo
        scrollViewInnerView.backgroundColor =  UIColor(named: "colorMain2")

        //Colores de los botones
        btnCancel.setTitleColor(UIColor(named: "colorText1"), for: .normal)
        btnDelete.tintColor = (UIColor(named: "colorText1"))
        btnSave.setTitleColor(UIColor(named: "colorText1"), for: .normal)
        btnPhoto.backgroundColor = UIColor(named: "colorText1")
        btnPhoto.setTitleColor(UIColor(named: "colorMain2"), for: .normal)
        btnImage.backgroundColor = UIColor(named: "colorText1")
        btnImage.setTitleColor(UIColor(named: "colorMain2"), for: .normal)

        //Colores de los textos
        textName.backgroundColor = (UIColor(named: "colorText1"))
        textName.textColor = (UIColor(named: "colorMain1"))
        textDescription.backgroundColor = (UIColor(named: "colorText1"))
        textDescription.textColor = (UIColor(named: "colorMain1"))

        imagePicked.layer.borderWidth = 0.5  //Imatge: Temporalment afegim un border
        imagePicked.layer.borderColor = UIColor(named: "colorText1")?.cgColor
    }
        
    fileprivate func updateMode() {
         //Mostramos el Place existente
        textName.text = place!.title
        textDescription.text = place!.desc

        if let image = place!.image {
            imagePicked.image = UIImage(data: image)
        }
    }
    
    fileprivate func creationMode() {
        //Creamos un nuevo Place
        textName.placeholder = "Enter Title here"
        textDescription.text = "Enter Description here"
    }
    
    @IBAction func selectImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary;
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func takePhoto(_ sender: Any){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera;
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func onSaveButtonPressed(_ sender: Any) {
        saveData()
    }
    
    @IBAction func onDeleteButtonPressed(_ sender: Any) {
        deleteData()
    }

    @IBAction func onCancelButtonPressed(_ sender: Any) {
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
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let labelData = pickerElems1[row]
        let myTitle = NSAttributedString(string: labelData, attributes: [NSAttributedString.Key.foregroundColor:UIColor(named: "colorText1")!])
         return myTitle
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
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
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
        guard let objectToDelete = place else { return }
            
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        context.delete(objectToDelete)
        
        do
        {
            try context.save()
            dismiss(animated: true)
            handler?()
            print("context delete succesfully")
        }
        catch
        {
            print("context delete error")
        }
    }
    
    func saveData() {
        let name = textName.text
        let descripcion = textDescription.text
        
        let selectedtype = viewPicker.selectedRow(inComponent: 0)
        let imgdata = imagePicked.image?.jpegData(compressionQuality: 0.75)
        
        let localizationLatitude = ManagerLocation.shared().GetLocation().latitude
        let localizationLongitude = ManagerLocation.shared().GetLocation().longitude
        
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

