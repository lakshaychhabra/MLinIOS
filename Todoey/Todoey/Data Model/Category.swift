//
//  Category.swift
//  Todoey
//
//  Created by Lakshay Chhabra on 17/01/18.
//  Copyright © 2018 Lakshay Chhabra. All rights reserved.
//

import Foundation
import RealmSwift


class Category : Object {
    
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
