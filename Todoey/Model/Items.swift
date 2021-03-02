//
//  Item.swift
//  Todoey
//
//  Created by ahmed on 13/01/2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item :Object {
   @objc dynamic var title :String = ""
   @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated :Date?
    @objc dynamic var toDoColor:String = ""
    var parentCategory = LinkingObjects(fromType:Category.self, property: "items")
    // each item has a pernt category from type category and that item get from items 
}
