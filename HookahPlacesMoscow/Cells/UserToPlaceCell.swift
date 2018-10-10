//
//  UserToPlaceCell.swift
//  HookahPlacesMoscow
//
//  Created by Евгений on 10/10/2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import UIKit

class UserToPlaceCell: UITableViewCell {
    
    @IBOutlet weak var nameUserLabel: UILabel!
    
    @IBOutlet weak var imageUserView: UIImageView! {
        didSet {
            self.imageUserView.layer.cornerRadius = 35
            self.imageUserView.layer.borderColor = UIColor.black.cgColor
            self.imageUserView.layer.borderWidth = 4
            self.imageUserView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var sendMessageToUserButton: UIButton! {
        didSet {
            self.sendMessageToUserButton.layer.cornerRadius = 5
            self.sendMessageToUserButton.clipsToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
