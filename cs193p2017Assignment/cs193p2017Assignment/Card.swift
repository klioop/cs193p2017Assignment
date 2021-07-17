//
//  Card.swift
//  cs193p2017Assignment
//
//  Created by klioop on 2021/07/16.
//

import Foundation

struct Card {
    
    var isFaceUp: Bool = false
    var isMatched = false
    var identifier: Int
    var count = 0
    
    static var identifierFactory = 0
    
    static func getUniqueId() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueId()
    }
}
