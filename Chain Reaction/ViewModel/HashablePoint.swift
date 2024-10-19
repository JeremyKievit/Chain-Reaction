//
//  HashablePoint.swift
//  Chain Reaction
//
//  Created by admin on 10/11/24.
//

import SwiftUI

// Creating a hashable CGPoint (to use in dictionary objects in the GameVM)

struct HashablePoint: Hashable {
    let point: CGPoint
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(point.x)
        hasher.combine(point.y)
    }
    
    static func == (lhs: HashablePoint, rhs: HashablePoint) -> Bool {
        return lhs.point == rhs.point
    }
}
