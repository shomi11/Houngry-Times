//
//  InfoViewController.swift
//  Houngry Times MessagesExtension
//
//  Created by Malovic, Milos on 4/28/20.
//  Copyright © 2020 Malovic, Milos. All rights reserved.
//

import UIKit
import Messages

protocol InfoDelegate: class {
    func userDidChoseDate(_ controller: UIViewController, restaurant: Restaurant)
}

class InfoViewController: UIViewController {
    
    // MARK: IBOutlet's
    
    @IBOutlet weak var resName: UILabel!
    @IBOutlet weak var resAddress: UILabel!
    @IBOutlet weak var resPhoneNum: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var reservationDateLbl: UILabel!
    
    // MARK: Properties
    
    var date = Date()
    var restaurant: Restaurant?
    weak var delegate: MessagesViewController!
    weak var userDidChooseDateDelegate: InfoDelegate?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.minimumDate = Date()
        datePicker?.addTarget(self, action: #selector(self.dateChanged), for: .valueChanged)
        
        resName.text = restaurant?.name
        resAddress.text = restaurant?.address
        resPhoneNum.text = restaurant?.phoneNumber
        reservationDateLbl.text = DateFormatter.localizedString(from: datePicker.date, dateStyle: .medium, timeStyle: .short)
    }
 
    // MARK: IBAction's
    
    @IBAction func sendReservationBtn(_ sender: Any) {
        restaurant = Restaurant(name: restaurant?.name, address: restaurant?.address, phoneNumber: restaurant?.phoneNumber, resDate: date)
        guard restaurant != nil else { fatalError("restaurant is nil") }
        delegate.createMessage(with: restaurant!)
    }
    
    // MARK: Function's
    
    @objc private func dateChanged() {
        date = datePicker.date
        reservationDateLbl.text = DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .short)
    }
}


// <a href='https://pngtree.com/so/food'>food png from pngtree.com</a>

