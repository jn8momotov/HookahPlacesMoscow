//
//  MainPlaceCell.swift
//  HookahPlacesMoscow
//
//  Created by Евгений on 21.09.2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import UIKit

class MainPlaceCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceToPlaceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var imagePlaceView: UIImageView! 
    
    @IBOutlet weak var distanceView: UIView! {
        didSet {
            self.distanceView.layer.cornerRadius = 5
            self.distanceView.layer.borderWidth = 2
            self.distanceView.layer.borderColor = UIColor.white.cgColor
            self.distanceView.clipsToBounds = true
        }
    }
    @IBOutlet weak var ratingView: UIView! {
        didSet {
            self.ratingView.layer.cornerRadius = 5
            self.ratingView.layer.borderWidth = 2
            self.ratingView.layer.borderColor = UIColor.white.cgColor
            self.ratingView.clipsToBounds = true
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
