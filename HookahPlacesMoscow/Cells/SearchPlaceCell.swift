//
//  SearchPlaceCell.swift
//  HookahPlacesMoscow
//
//  Created by Евгений on 05/10/2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import UIKit

class SearchPlaceCell: UITableViewCell {

    @IBOutlet weak var imageViewPlace: UIImageView! {
        didSet {
            self.imageViewPlace.layer.cornerRadius = 35
            self.imageViewPlace.layer.borderColor = UIColor.black.cgColor
            self.imageViewPlace.layer.borderWidth = 4
            self.imageViewPlace.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var distanceView: UIView! {
        didSet {
            self.distanceView.layer.cornerRadius = 5
            self.distanceView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var ratingView: UIView! {
        didSet {
            self.ratingView.layer.cornerRadius = 5
            self.ratingView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var distanceToPlaceLabel: UILabel!
    @IBOutlet weak var ratingPlaceLabel: UILabel!    
    @IBOutlet weak var namePlaceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
