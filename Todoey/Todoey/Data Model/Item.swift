//
//  Item.swift
//  Todoey
//
//  Created by Lakshay Chhabra on 17/01/18.
//  Copyright © 2018 Lakshay Chhabra. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
