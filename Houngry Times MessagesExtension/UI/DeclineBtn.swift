//
//  DeclineBtn.swift
//  Houngry Times MessagesExtension
//
//  Created by Malovic, Milos on 4/30/20.
//  Copyright © 2020 Malovic, Milos. All rights reserved.
//

import Foundation
import UIKit

class DeclineBtn: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    let shadowOffset = CGSize(width: 2, height: 5)
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = .black
        self.tintColor = .systemBackground
        self.layer.cornerRadius = self.frame.height / 2 - 10
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.systemBackground.cgColor
        self.layer.shadowRadius = 5
        self.layer.shadowColor = UIColor.systemBackground.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = shadowOffset
    }
}
