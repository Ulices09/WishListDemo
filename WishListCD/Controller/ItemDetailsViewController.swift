//
//  ItemDetailsViewController.swift
//  WishListCD
//
//  Created by Ulices Meléndez on 18/12/17.
//  Copyright © 2017 Ulices Meléndez Acosta. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var titleTextField: CustomTextField!
    @IBOutlet weak var priceTextField: CustomTextField!
    @IBOutlet weak var detailsTextField: CustomTextField!
    @IBOutlet weak var storePickerView: UIPickerView!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    var imagePicker: UIImagePickerController!
    
    var stores = [Store]()
    var itemToEdit: Item?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        setBackItemProperties()
        //setPlaceholdersStyle()
        
        storePickerView.delegate = self
        storePickerView.dataSource = self
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let singleTap = UITapGestureRecognizer(target: self, action: Selector("onTapItemImageView"))
        itemImageView.isUserInteractionEnabled = true
        itemImageView.addGestureRecognizer(singleTap)
        
        getStores()
        loadItemData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setBackItemProperties() {
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stores[row].name
    }
    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        <#code#>
//    }
    
    func generateStoreData() {
        let store = Store(context: context)
        store.name = "Amazon"
        let store1 = Store(context: context)
        store1.name = "eBay"
        let store2 = Store(context: context)
        store2.name = "AliExpress"
        let store3 = Store(context: context)
        store3.name = "Alibaba"
        let store4 = Store(context: context)
        store4.name = "Mercado Libre"
        let store5 = Store(context: context)
        store5.name = "Linio"
        
        ad.saveContext()
    }
    
    func getStores() {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            self.stores = try context.fetch(fetchRequest)
            
            if self.stores.count == 0 {
                generateStoreData()
                self.stores = try context.fetch(fetchRequest)
            }
            
            self.storePickerView.reloadAllComponents()
        } catch let error as NSError {
            print("Error: \(error)")
        }
    }
    
    func setPlaceholdersStyle() {
        titleTextField.attributedPlaceholder = NSAttributedString(string: "Title", attributes: [NSAttributedStringKey.foregroundColor: UIColor.yellow])
        priceTextField.attributedPlaceholder = NSAttributedString(string: "Price", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        detailsTextField.attributedPlaceholder = NSAttributedString(string: "Details", attributes: [NSAttributedStringKey.foregroundColor: UIColor.yellow])
    }
    
    @objc func onTapItemImageView() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            itemImageView.image = image
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtnPressed(_ sender: UIButton) {
        
        let title = titleTextField.text
        let price = priceTextField.text
        let details = detailsTextField.text
        
        if (title?.isEmpty)!, (price?.isEmpty)!, (details?.isEmpty)! {
            validationMessage()
        }
        else {
            var item: Item!
            
            if itemToEdit == nil {
                item = Item(context: context)
            }
            else {
                item = itemToEdit
            }
            
            item.title = title
            item.price = Double(price!)!
            item.detail = details
            item.store = stores[storePickerView.selectedRow(inComponent: 0)]
            
            let itemImage = Image(context: context)
            itemImage.image = itemImageView.image
            item.image = itemImage
            
            ad.saveContext()
            successMessage(message: "Item saved.")
        }
        
    }
    
    @IBAction func deleteBtnPressed(_ sender: UIBarButtonItem) {
        
        if itemToEdit != nil {
            context.delete(itemToEdit!)
            ad.saveContext()
            successMessage(message: "Item deleted.")
        }
    }
    
    func loadItemData() {
        if itemToEdit != nil {
            titleTextField.text = itemToEdit?.title
            priceTextField.text = "\(itemToEdit!.price)"
            detailsTextField.text = itemToEdit?.detail
            itemImageView.image = itemToEdit?.image?.image as? UIImage
            
            if let store = itemToEdit?.store {
                if let index = stores.index(of: store) {
                    storePickerView.selectRow(index, inComponent: 0, animated: true)
                }
//                if let index = stores.index(where: { $0.name! == store.name!}) {
//                    storePickerView.selectRow(index, inComponent: 0, animated: true)
//                }
            }
        }
        else {
            deleteButton.isEnabled = false
        }
    }
    
    func validationMessage() {
        let alert = UIAlertController(title: "Error", message: "Incorrect data.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func successMessage(message: String) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ -> Void in
            _ = self.navigationController?.popViewController(animated: true)
        })
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}









