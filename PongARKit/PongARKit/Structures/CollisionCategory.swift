//
//  CollisionCategory.swift
//  PongARKit
//
//  Created by Jones on 2018/1/28.
//  Copyright © 2018年 ssrh. All rights reserved.
//

struct CollisionCategory {
    let rawValue: Int
    
    static let bottom = CollisionCategory(rawValue: 1 << 0)
    static let character = CollisionCategory(rawValue: 1 << 1)
}
