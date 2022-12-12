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
 
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var textDescription: UITextView!
        
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnImage: UIButton!

    var keyboardHeight:CGFloat!
    var activeField: UIView!
    var lastOffset:CGPoint!
    var editMode:Int!
    
    var place: PTC? = nil
    
   
    let m_location_manager: ManagerLocation = ManagerLocation.shared()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        labelName.text = NSLocalizedString("name", comment: "")
        labelDescription.text = NSLocalizedString("desc", comment: "")

        //Sempre mostrem el Picker
        viewPicker.delegate = self
        viewPicker.dataSource = self
        
        btnCancel.setTitle(NSLocalizedString("cancel", comment: ""), for: .normal)
        btnCancel.setTitle(NSLocalizedString("cancel", comment: ""), for: .highlighted)
        btnDelete.setImage(UIImage(named: "trash.fill"), for: .normal)
        
        btnSave.setTitle(NSLocalizedString("save", comment: ""), for: .normal)
        btnSave.setTitle(NSLocalizedString("save", comment: ""), for: .highlighted)
        
        if place == nil {
            //Cuando es un nuevo place (CREATE), mostramos:
            btnImage.setTitle(NSLocalizedString("addImage", comment: ""), for: .normal)
            btnImage.setTitle(NSLocalizedString("addImage", comment: ""), for: .highlighted)
            
            //Ocultamos el botón Delete
            btnDelete.isHidden = true

            //Mostramos el PickerView con la fila seleccionada
            viewPicker.selectRow(0, inComponent: 0, animated: false)

            editMode = 0
            creationMode()
        } else{
            //Cuando es un place ya existente (UPDATE), mostramos:
            btnImage.setTitle(NSLocalizedString("changeImage", comment: ""), for: .normal)
            btnImage.setTitle(NSLocalizedString("changeImage", comment: ""), for: .highlighted)
            
            //Mostramos el PickerView con la fila seleccionada
            viewPicker.selectRow(Int(place!.type), inComponent: 0, animated: false)
            
            editMode = 1
            updateMode()
        }

        initKeyboard()
        initImgMenu()
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

        btnImage.layer.cornerRadius = 10.0
        btnImage.backgroundColor = UIColor(named: "colorMain1")
        btnImage.setTitleColor(UIColor(named: "colorText1"), for: .normal)
        btnImage.setTitleColor(UIColor(named: "colorGrey"), for: .highlighted)
        
        //Colores de los textos
        textName.layer.cornerRadius = 10.0
        textName.backgroundColor = (UIColor(named: "colorMain1"))
        textName.textColor = (UIColor(named: "colorText1"))
        
        textDescription.layer.cornerRadius = 10.0
        textDescription.backgroundColor = (UIColor(named: "colorMain1"))
        textDescription.textColor = (UIColor(named: "colorText1"))

        imagePicked.layer.cornerRadius = 10.0
        imagePicked.layer.borderWidth = 0.5
        imagePicked.layer.borderColor = UIColor(named: "colorText1")?.cgColor
        imagePicked.contentMode = UIView.ContentMode.scaleToFill
        if imagePicked.image == nil
        {
            imagePicked.image = UIImage(systemName: "photo.fill")
        }
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
        textName.attributedPlaceholder = NSAttributedString(
            string: NSLocalizedString("namePlaceholder", comment: ""),
            attributes:[
                    NSAttributedString.Key.foregroundColor: UIColor(named: "colorText1")!,
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)
                ])
        textDescription.text = NSLocalizedString("descPlaceholder", comment: "")
    }
    
    
    func initImgMenu() {
        // Do any additional setup after lActionoading the view.
        let takePhoto = NSLocalizedString("takePhoto", comment: "")
        let selectImage = NSLocalizedString("selectImage", comment: "")

        let pictureItem = UIAction(title: takePhoto, image: UIImage(systemName: "camera.fill")) { (action) in
             print("Users action was tapped")
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let imageItem = UIAction(title: selectImage, image: UIImage(systemName: "photo.on.rectangle")) { (action) in
            print("Add User action was tapped")
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }

       let menu = UIMenu(title: "", options: .displayInline, children: [pictureItem , imageItem])
                
        btnImage.menu = menu
        btnImage.showsMenuAsPrimaryAction = true
    }
    
    @IBAction func selectImage(_ sender: Any) {

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
        return ManagerPlaces.shared.listItemType.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return NSLocalizedString( ManagerPlaces.shared.listItemType[row], comment: "")
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let labelData = NSLocalizedString( ManagerPlaces.shared.listItemType[row], comment: "")
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
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
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
        
        objectToSave?.id = Int32(Date().timeIntervalSince1970)
        objectToSave?.title = name
        objectToSave?.desc = descripcion
        objectToSave?.type = Int16(selectedtype)
        objectToSave?.image = imgdata
        
        //Si estamos en modo Update no actualizamos ubiación
        if editMode==1 {
            objectToSave?.longitude = localizationLongitude
            objectToSave?.latitude = localizationLatitude
        }

        print("new object location id \(objectToSave?.id ?? 0) long \(localizationLongitude) lat \(localizationLatitude)")
        
        do
        {
            try context.save()
            dismiss(animated: true)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
            print("context save succesfully")
        }
        catch
        {
            print("context save error")
        }
    }
    

}

