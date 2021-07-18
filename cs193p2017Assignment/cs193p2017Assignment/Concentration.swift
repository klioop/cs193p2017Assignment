//
//  Concentration.swift
//  cs193p2017Assignment
//
//  Created by klioop on 2021/07/16.
//

import Foundation

// Model for a game
class Concentration {
    
    var cards = [Card]()
    var indexOfOneAndOnlyOneFaceUp: Int? {
        get { cards.indices.filter({ cards[$0].isFaceUp }).oneAndOnlyOne }
        set { cards.indices.forEach{ cards[$0].isFaceUp = ($0 == newValue)} }
    }
    
    func touchCard(at cardNumber: Int) {
        if !cards[cardNumber].isMatched {
            if let potentialMatch = indexOfOneAndOnlyOneFaceUp, !cards[cardNumber].isFaceUp {
                if cards[potentialMatch].identifier == cards[cardNumber].identifier {
                    cards[potentialMatch].isMatched = true
                    cards[cardNumber].isMatched = true
                }
                cards[cardNumber].isFaceUp = true
            } else {
                indexOfOneAndOnlyOneFaceUp = cardNumber
//                for idx in cards.indices {
//                    cards[idx].isFaceUp = false
//                }
//                cards[cardNumber].isFaceUp = true
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        
        cards.shuffle()
    }
}

extension Array {
    var oneAndOnlyOne: Element? {
        if self.count == 1 {
            return self.first
        } else {
            return nil
        }
    }
}
