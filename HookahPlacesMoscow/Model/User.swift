//
//  User.swift
//  HookahPlacesMoscow
//
//  Created by Евгений on 18/10/2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import Foundation

class User {
    
    var name: String!
    var phone: String!
    var imageData: Data?
    
    init(name: String, phone: String, imageData: Data?) {
        self.name = name
        self.phone = phone
        self.imageData = imageData
    }
}
