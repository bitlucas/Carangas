//
//  AddEditViewController.swift
//  Carangas
//
//  Created by Eric Brito.
//  Copyright © 2017 Eric Brito. All rights reserved.
//

import UIKit

class AddEditViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tfBrand: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var scGasType: UISegmentedControl!
    @IBOutlet weak var btAddEdit: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var car: Car!
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
       if car != nil {
            title = car.name
            tfBrand.text = car.brand
            tfName.text = car.name
            tfPrice.text = "\(car.price)"
            scGasType.selectedSegmentIndex = car.gasType
            btAddEdit.setTitle("Editar", for: .normal)
        }
        
    }
    
    // MARK: - IBActions
    @IBAction func addEdit(_ sender: UIButton) {
        if car == nil {
        car = Car()
        }
        if tfName.text?.isEmpty == true {
            car.name = "Empty"
            print("Nome vazio")
        } else {
            car.name = tfName.text!
        }
        
        if tfBrand.text?.isEmpty == true {
            car.brand = "Empty"
            print("Marca vazia")
        } else {
            car.brand = tfBrand.text!
        }
        
        if tfPrice.text?.isEmpty == true {
            car.price = 0
            print("Preço vazio")
        } else {
            car.price = Double(tfPrice.text!)!
        }
        
        car.gasType = scGasType.selectedSegmentIndex
        
        
        if car._id == nil {
        REST.save(car: car, onComplete: { (success) in
           goBack()
            
        }) {(error) in
                print(error)
            }
        } else {
            REST.update(car: car, onComplete: { (success) in
                goBack()
                
            }) { (error) in
                print(error)
            }
            
        }
    
    func goBack(){
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }

        
    }
    

}
}
