//
//  Place+CoreDataProperties.swift
//  HookahPlacesMoscow
//
//  Created by Евгений on 22.09.2018.
//  Copyright © 2018 Евгений. All rights reserved.
//
//

import Foundation
import CoreData


extension Place {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Place> {
        return NSFetchRequest<Place>(entityName: "Place")
    }

    @NSManaged public var address: String?
    @NSManaged public var countUsers: Int16
    @NSManaged public var distance: Double
    @NSManaged public var image: NSData?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var metroStation: String?
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var rating: Double
    @NSManaged public var id: Int16
    
    @NSManaged public var isLike: Bool
    
    @NSManaged public var restarting: Bool
    @NSManaged public var theirFoot: Bool
    @NSManaged public var theirDrink: Bool
    @NSManaged public var theirAlko: Bool
    @NSManaged public var tableGames: Bool
    @NSManaged public var gameConsole: Bool
    @NSManaged public var wifi: Bool
    @NSManaged public var bankCard: Bool
    
}
