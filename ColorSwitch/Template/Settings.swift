//
//  Settings.swift
//  ColorSwitch
//
//  Created by Javed Siddique on 03/04/20.
//  Copyright © 2020 Javed. All rights reserved.
//

import SpriteKit

enum PhysicsCatgories{
    static let none : UInt32 = 0
    static let ballCategory : UInt32 = 0x1
    static let switchCategory : UInt32 = 0x1 << 1
}
enum ZPositions{
    static let label : CGFloat = 0
    static let ball : CGFloat = 1
    static let colorSwitch : CGFloat = 2
}
