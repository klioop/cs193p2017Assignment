//
//  Card.swift
//  cs193p2017Assignment
//
//  Created by klioop on 2021/07/16.
//

import Foundation

struct Card: Hashable {
    
//    var hashValue: Int { identifier } deprecated
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    var isFaceUp: Bool = false
    var isMatched = false
    private var identifier: Int
    var count = 0
    
    static var identifierFactory = 0
    
    static func getUniqueId() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueId()
    }
    
    static func == (lhs: Card, right: Card) -> Bool{
        return lhs.identifier == right.identifier
    }
}
