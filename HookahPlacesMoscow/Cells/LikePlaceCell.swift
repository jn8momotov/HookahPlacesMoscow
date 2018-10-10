//
//  LikePlaceCell.swift
//  HookahPlacesMoscow
//
//  Created by Евгений on 01/10/2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import UIKit

class LikePlaceCell: UICollectionViewCell {
    
    @IBOutlet weak var namePlaceLabel: UILabel!
    @IBOutlet weak var metroStationPlaceLabel: UILabel!
    @IBOutlet weak var imagePlaceView: UIImageView! {
        didSet {
            self.imagePlaceView.layer.cornerRadius = 40
            self.imagePlaceView.layer.borderWidth = 4
            self.imagePlaceView.layer.borderColor = UIColor.black.cgColor
            self.imagePlaceView.clipsToBounds = true
        }
    }
}
