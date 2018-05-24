//
//  Item.swift
//  Todoey
//
//  Created by J.Sim on 2018/05/23.
//  Copyright © 2018年 J.Sim. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: AnCategory.self, property: "items")
}
