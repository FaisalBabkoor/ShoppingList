//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Faisal Babkoor on 4/11/18.
//  Copyright © 2018 Faisal Babkoor. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //IBOutlet
    @IBOutlet weak var titleTextField: UITextFieldX!
    @IBOutlet weak var priceTextField: UITextFieldX!
    @IBOutlet weak var detailsTextField: UITextFieldX!
    @IBOutlet weak var storePickerView: UIPickerView!
    @IBOutlet weak var thumImage: UIImageView!
    @IBOutlet weak var chooseImageBtn: UIButton!
    @IBOutlet weak var selectStoreLabel: UILabel!
    
    //Variables
    var stors = [Store]()
    var mainVC: MainVC!
    var itemToEdit: Item!
    var imagePicker: UIImagePickerController!
    var itemType: [Type]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeTopItem()
        storePickerView.delegate = self
        storePickerView.dataSource = self
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        itemType = [Type]()
        getData()
        print("before: \(stors.count)", itemType.count)
        if stors.count != 0 && itemType.count != 0{
            getData()
            print("if: \(stors.count)", itemType.count)
        }else{
            putData()
            getData()
            print("else: \(stors.count)", itemType.count)
        }
        self.hideKeyboardWhenTappedAround()

        if itemToEdit != nil{
            loadData()
        }
        
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
            return stors.count
            
        }else{
            return itemType.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0{
            guard let name = stors[row].name else { return "" }
            return name
        }else{
            guard let type = itemType[row].type else { return "" }
            return type
        }
       
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let itemSelected = stors[storePickerView.selectedRow(inComponent: 0)].name else{return}
       guard let typeSelected = itemType[storePickerView.selectedRow(inComponent: 1)].type else{return}
        selectStoreLabel.text = itemSelected + ", " + typeSelected //"\(itemSelected), \(typeSelected)"
        // performSegue(withIdentifier: , sender: )
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    func putData(){
        let data1 = Store(entity: Store.entity(), insertInto: context)
        let data2 = Store(entity: Store.entity(), insertInto: context)
        let data3 = Store(entity: Store.entity(), insertInto: context)
        let data4 = Store(entity: Store.entity(), insertInto: context)
        let data5 = Store(entity: Store.entity(), insertInto: context)
        

        let type1 = Type(entity: Type.entity(), insertInto: context)
        let type2 = Type(entity: Type.entity(), insertInto: context)
        let type3 = Type(entity: Type.entity(), insertInto: context)
        let type4 = Type(entity: Type.entity(), insertInto: context)
        let type5 = Type(entity: Type.entity(), insertInto: context)

        data1.name = "امازون"
        data2.name = "جرير"
        data3.name = "اكسترا"
        data4.name = "بن داود"
        data5.name = "النوري"
        
        type1.type = "الكترونيات"
        type2.type = "اكسسوارات"
        type3.type = "مواد غذائية"
        type4.type = "حلويات"
        type5.type = "أخرى"

        
        do{
            try context.save()
        }catch{
            print(error)
        }
    }
    func getData(){
        do{
            let data = try context.fetch(Store.fetchRequest()) as [Store]
            let type = try context.fetch(Type.fetchRequest()) as [Type]
            
            stors = data
            itemType = type
            storePickerView.reloadAllComponents()
        }catch{
            print(error)
        }
    }
    
    
    func changeTopItem() {
        if let topItem =  navigationController?.navigationBar.topItem{
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
    }
    
    @IBAction func saveBtnWasPressed(_ sender: UIButton) {
        var item: Item!
        let images = Image(context: context)
        images.image = thumImage.image
        
        if itemToEdit == nil{
            item = Item(context: context)
        }else{
            item = itemToEdit
            //            images.image = thumImage.image
        }
        item.toImage = images
        
        if let title = titleTextField.text != nil ? titleTextField.text : ""{
            item.title = title
        }
        if let price = priceTextField.text != nil ? priceTextField.text : "0"{
            item.price = (price as NSString).doubleValue
        }
        if let details = detailsTextField.text != nil ? detailsTextField.text : ""{
            item.details = details
        }
        item.toStore = stors[storePickerView.selectedRow(inComponent: 0)]
        item.toItemType = itemType[storePickerView.selectedRow(inComponent: 1)]
       
        ad.saveContext()
        navigationController?.popViewController(animated: true)
    }
    func loadData() {
        titleTextField.text = itemToEdit.title
        priceTextField.text = "\(itemToEdit.price)"
        detailsTextField.text = itemToEdit.details
        thumImage.image = itemToEdit.toImage?.image as? UIImage
        var index = 0
        for _ in stors{
            if let name = itemToEdit.toStore?.name {
                if name == stors[index].name{
                    storePickerView.selectRow(index, inComponent: 0, animated: true)
                }
                
            }
                for _ in itemType{
                    if let type = itemToEdit.toItemType?.type {
                        if type == itemType[index].type{
                        storePickerView.selectRow(index, inComponent: 1, animated: true)
                        print("index: \(index)")
                        }
                        
                    }
            }
            index += 1
            }
    }
    
    @IBAction func deleteBtnWasPressed(_ sender: UIBarButtonItem) {
        if itemToEdit != nil{
            context.delete(itemToEdit)
            ad.saveContext()
            navigationController?.popViewController(animated: true)
        }else{
            navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func addImageBtnWasPressed(_ sender: UIButton) {
        present(imagePicker, animated: true)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let img = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage{
            thumImage.image = img
        }
        imagePicker.dismiss(animated: true)
        
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
