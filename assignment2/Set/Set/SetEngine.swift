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
    
    mutating func touchCard(at cardNumber: Int) {
        
        if !cardsOnTable[cardNumber].isMatched && !cardsOnTable[cardNumber].isSelected {
            cardsOnTable[cardNumber].isSelected = true

            if selectedCardIndices.count == 0 {
                selectedCardIndices += [cardNumber]
            } else if selectedCardIndices.count == 1 {
                selectedCardIndices.append(cardNumber)
            } else if selectedCardIndices.count == 2 {
                selectedCardIndices.append(cardNumber)
                print(selectedCardIndices)
                
                if isSet(for: selectedCardIndices) {
                    selectedCardIndices.forEach {
                        cardsOnTable[$0].isMatched = true
                        let randomIdx = Int.random(in: 0..<deck.count)
                        cardsOnTable[$0] = deck.remove(at: randomIdx)
                    }
                    score += 3
                } else {
                    selectedCardIndices.forEach { cardsOnTable[$0].isSelected = false}
                }
                
                selectedCardIndices = []
            }
        }
        
    }
    
    // return true if the selected cards of three form set
    private func isSet(for indicies: [Int]) -> Bool {
        var selectedCards = [Card]()
        indicies.forEach { selectedCards.append(cardsOnTable[$0]) }
        selectedCards.forEach{ print( "id: \($0.identifier)" )}
        
        let color = Set(selectedCards.map{ $0.color }).count
        let shape = Set(selectedCards.map{ $0.shape }).count
        let number = Set(selectedCards.map{ $0.number }).count
        let shade = Set(selectedCards.map{ $0.shade }).count
        
        print("color: \(color), shape: \(shape), shade: \(shade), number: \(number)")
        
        let result = color != 2 && shape != 2 && number != 2 && shade != 2
        
        return result
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
        
        for _ in 0..<24 {
            let randomIdx = Int.random(in: 0..<deck.count)
            cardsOnTable.append(deck[randomIdx])
            deck.remove(at: randomIdx)
        }
    }
}
