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
    var score = 0
    
    func touchCard(at cardNumber: Int) {
        if !cards[cardNumber].isMatched {
            if let potentialMatch = indexOfOneAndOnlyOneFaceUp, !cards[cardNumber].isFaceUp {
                if cards[potentialMatch].identifier == cards[cardNumber].identifier {
                    cards[potentialMatch].isMatched = true
                    cards[cardNumber].isMatched = true
                    
                    score += 2
                }
                cards[cardNumber].isFaceUp = true
                
                discountScoreAndUpdateCount(for: cardNumber)
                discountScoreAndUpdateCount(for: potentialMatch)
            } else {
                indexOfOneAndOnlyOneFaceUp = cardNumber
//                for idx in cards.indices {
//                    cards[idx].isFaceUp = false
//                }
//                cards[cardNumber].isFaceUp = true
                
            }
        }
    }
    
    func discountScoreAndUpdateCount(for cardNumber: Int) {
        if !cards[cardNumber].isMatched && cards[cardNumber].count >= 1 {
            score -= 1
        }
        cards[cardNumber].count += 1
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
