//
//  Category.swift
//  Todoey
//
//  Created by J.Sim on 2018/05/23.
//  Copyright © 2018年 J.Sim. All rights reserved.
//

import Foundation
import RealmSwift

class AnCategory: Object {
    @objc dynamic var name: String =  ""
    @objc dynamic var color: String = ""
    let items = List<Item>()
}
