//
//  SetEngine.swift
//  Set
//
//  Created by klioop on 2021/07/21.
//

import Foundation

struct SetEngine {
    
    private var deck = [Card]()
    var cardsOnTable = Array<Card>()
    var selectedCardIndices = [Int]()
    var score = 0
    var remaingCardOnDeck: Int? {
        get {
            if deck.count < 0 {
                return nil
            } else {
                return deck.count
            }
        }
    }
    var lastMatchedCardsIndices: [Int]?
    var findSet: Bool = false
    
    mutating func dealThreeCard() {
        if deck.count > 0 {
            for _ in 0..<3 {
                let randomIdx = Int.random(in: 0..<deck.count)
                cardsOnTable.append(deck.remove(at: randomIdx))
            }
        }
    }
    
    mutating func touchCard(at cardNumber: Int) {
        
        if !cardsOnTable[cardNumber].isMatched && !cardsOnTable[cardNumber].isSelected {
            cardsOnTable[cardNumber].isSelected = true

            if selectedCardIndices.count == 0 {
                selectedCardIndices += [cardNumber]
            } else if selectedCardIndices.count == 1 {
                selectedCardIndices.append(cardNumber)
            } else if selectedCardIndices.count == 2 {
                selectedCardIndices.append(cardNumber)
                
                if isSet(for: selectedCardIndices) {
                    findSet = true
                    lastMatchedCardsIndices = selectedCardIndices
                    selectedCardIndices.forEach { cardsOnTable[$0].isMatched = true }
                    score += 3
                } else {
                    selectedCardIndices.forEach { cardsOnTable[$0].isSelected = false}
                }
                
                selectedCardIndices = []
            }
        }
    }
    
    mutating func replaceMatchedCards() {
        cardsOnTable.indices.forEach {
            if cardsOnTable[$0].isMatched {
                let randomIdx = Int.random(in: 0..<deck.count)
                cardsOnTable[$0] = deck.remove(at: randomIdx)
            }
        }
    }
    
    // return true if the selected cards of three form set
    private func isSet(for indicies: [Int]) -> Bool {
        var selectedCards = [Card]()
        indicies.forEach { selectedCards.append(cardsOnTable[$0]) }
        
        let color = Set(selectedCards.map{ $0.color }).count
        let shape = Set(selectedCards.map{ $0.shape }).count
        let number = Set(selectedCards.map{ $0.number }).count
        let shade = Set(selectedCards.map{ $0.shade }).count
        
        let result = color != 2 && shape != 2 && number != 2 && shade != 2
        
        return result
    }
    
    
    init(numberOfCards: Int = 81) {
        
        let colors: [Color] = [.green, .purple, .red]
        let shapes: [Shape] = [.oval, .squiggle, .diamond]
        let shades: [Shade] = [.fill, .open, .stripped]
        let numbers: [Number] = [.one, .two, .three]
        
        for color in colors {
            for shape in shapes {
                for shade in shades {
                    for number in numbers {
                        deck.append(Card(color: color, shape: shape, shade: shade, number: number))
                    }
                }
            }
        }
        
        deck.shuffle()
        
        for _ in 1..<13 {
            let randomIdx = Int.random(in: 0..<deck.count)
            cardsOnTable.append(deck.remove(at: randomIdx))
        }
        
    }
}
