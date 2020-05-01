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
    @IBOutlet weak var randomIconToShow: UIImageView!
    
    // MARK: Properties

    var restaurant: Restaurant?
    var images = ["food1", "food2", "food3", "food4"]
    weak var delegate: MessagesViewController!
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // set value for outlet's
        nameLbl.text = restaurant?.name
        adressLbl.text = restaurant?.address
        dateLbl.text = DateFormatter.localizedString(from: restaurant!.resDate!, dateStyle: .medium, timeStyle: .short)
        let imageName = images.randomElement()
        randomIconToShow.image = UIImage(named: imageName ?? "food1")
    }
    
    // MARK: IBAction's

    // if user confirm proposal
    @IBAction func confirmBtnPressed(_ sender: Any) {
        self.delegate.sendConfirmationMessage()
    }
    
    // if user decline proposal
    @IBAction func declineBtnPressed(_ sender: Any) {
        self.delegate.sendDeclineMessage()
    }
}
