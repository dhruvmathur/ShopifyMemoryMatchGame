//
//  Card.swift
//  ShopifyMemoryMatchGame
//
//  Created by Dhruv Mathur on 2019-09-16.
//  Copyright © 2019 Dhruv Mathur. All rights reserved.
//

import Foundation

struct Card: Hashable {
    var hashValue: Int {
        return identifier
    }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var isFaceUp = false
    var isMatched = false
    private var identifier: Int
    
    private static var identifierCreator = 0
    
    private static func getUniqueIdentifer() -> Int {
        identifierCreator += 1
        return identifierCreator
    }
    
    init () {
        self.identifier = Card.getUniqueIdentifer()
    }
}
