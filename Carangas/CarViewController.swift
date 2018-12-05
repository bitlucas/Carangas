//
//  CarViewController.swift
//  Carangas
//
//  Created by Eric Brito on 21/10/17.
//  Copyright © 2017 Eric Brito. All rights reserved.
//

import UIKit

class CarViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var lbBrand: UILabel!
    @IBOutlet weak var lbGasType: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    //MARK : - Properties
    var car: Car!
    let formatter = NumberFormatter()
    
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
   override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
      
        title = car.name
        lbBrand.text = car.brand
        lbGasType.text = car.gas
        lbPrice.text = getFormattedValue(of: car.price, withCurrency: "R$")
    }
    
    func getFormattedValue(of value: Double, withCurrency currency: String) -> String{
        formatter.numberStyle = .currency
        formatter.currencySymbol = currency
        formatter.alwaysShowsDecimalSeparator = true
        return formatter.string(for: value)!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let vc = segue.destination as! AddEditViewController
            vc.car = car
    }

}
