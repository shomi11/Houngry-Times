//
//  ProposalViewController.swift
//  Houngry Times MessagesExtension
//
//  Created by Malovic, Milos on 4/28/20.
//  Copyright © 2020 Malovic, Milos. All rights reserved.
//

import UIKit


class ProposalViewController: UIViewController {
    
    // MARK: IBOutlet's
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var adressLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    // MARK: Properties

    var restaurant: Restaurant?
    weak var delegate: MessagesViewController!
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // set value for outlet's
        nameLbl.text = restaurant?.name
        adressLbl.text = restaurant?.address
        dateLbl.text = DateFormatter.localizedString(from: restaurant!.resDate!, dateStyle: .medium, timeStyle: .short)
        
    }
    
    // MARK: IBAction's

    @IBAction func confirmBtnPressed(_ sender: Any) {
        self.delegate.sendConfirmationMessage()
    }
    
    @IBAction func declineBtnPressed(_ sender: Any) {
        
    }
}
