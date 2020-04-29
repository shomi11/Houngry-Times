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
    
    @IBOutlet weak var resName: UILabel!
    @IBOutlet weak var resAddress: UILabel!
    @IBOutlet weak var resPhoneNum: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var numberOfGuestTxtField: UITextField!
    @IBOutlet weak var reservationDateLbl: UILabel!
    
    
    var name = String()
    var address = String()
    var phoneNumber = String()
    
    var date = Date()
    var numberOfGuest: Int?
    var restaurant: Restaurant?
    
    weak var delegate: MessagesViewController!
    weak var userDidChooseDateDelegate: InfoDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let toolbarDone = UIToolbar.init()
        toolbarDone.sizeToFit()
        let barBtnDone = UIBarButtonItem.init(barButtonSystemItem: .done,
                                              target: self, action: #selector(doneKeyboard))
        
        toolbarDone.items = [barBtnDone] // You can even add cancel button too
        numberOfGuestTxtField.inputAccessoryView = toolbarDone
        
        numberOfGuestTxtField.delegate = self
        
        datePicker.minimumDate = Date()
        
        datePicker?.addTarget(self, action: #selector(self.dateChanged), for: .valueChanged)
        
        resName.text = restaurant?.name
        resAddress.text = restaurant?.address
        resPhoneNum.text = restaurant?.phoneNumber
        reservationDateLbl.text = DateFormatter.localizedString(from: datePicker.date, dateStyle: .medium, timeStyle: .short)
    }
    
    @objc private func doneKeyboard() {
        numberOfGuestTxtField.resignFirstResponder()
    }
    
    @IBAction func sendReservationBtn(_ sender: Any) {
        numberOfGuest = Int(numberOfGuestTxtField.text ?? "")
        restaurant = Restaurant(name: restaurant?.name, address: restaurant?.address, phoneNumber: restaurant?.phoneNumber, resDate: date, numOfPeaple: numberOfGuest)
        guard restaurant != nil else { fatalError("restaurant is nil") }
        delegate.createMessage(with: restaurant!)
    }
    
    @objc private func dateChanged() {
        date = datePicker.date
        reservationDateLbl.text = DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .short)
    }
}

extension InfoViewController: UITextFieldDelegate { }
