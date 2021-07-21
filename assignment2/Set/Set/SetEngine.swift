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
    var selectedCards: [Card]?
    
    mutating func touchCard(at cardNumber: Int) {
        let chosenCard = cardsOnTable[cardNumber]
        if !chosenCard.isMatched && !chosenCard.isSelected{
            
            guard var cardsInvolved = selectedCards else {
                selectedCards = [chosenCard]
                return
            }
            
            if cardsInvolved.count == 1 {
                selectedCards?.append(chosenCard)
            } else if cardsInvolved.count == 2 {
                cardsInvolved.append(chosenCard)
                
                if isSet(for: cardsInvolved) {
                    
                    for index in cardsInvolved.indices {
                        cardsInvolved[index].isMatched = true
                        
                        cardsOnTable = cardsOnTable.map{ cardOnTable -> Card in
                            if cardOnTable.identifier == cardsInvolved[index].identifier {
                                let randomIdx = Int.random(in: 0..<deck.count)
                                return deck.remove(at: randomIdx)
                            } else {
                                return cardOnTable
                            }
                        }
                    }
                } else {
                    _ = cardsInvolved.indices.map{ cardsInvolved[$0].isSelected = false }
                }
                
                selectedCards = nil
            }
        }
    }
    
    // return true if the selected cards of three form set
    func isSet(for cards: [Card]) -> Bool {
        return true
    }
    
    init(numberOfCards: Int = 81) {
        
        let colors: [Color] = [.green, .purple, .red]
        let shapes: [Shape] = [.circle, .rectangle, .triangle]
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
        
        for _ in 0..<12 {
            let randomIdx = Int.random(in: 0..<deck.count)
            cardsOnTable.append(deck[randomIdx])
            deck.remove(at: randomIdx)
        }
    }
}
