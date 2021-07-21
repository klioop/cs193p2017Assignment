//
//  Card.swift
//  Set
//
//  Created by klioop on 2021/07/21.
//

import UIKit

struct Card {
    
    var isSelected = false
    var isMatched = false
    var identifier: Int
    
    var color: Color
    var shape: Shape
    var shade: Shade
    var number: Number
    
    static var identifierFactory = 0
    
    static func generateID() -> Int {
        identifierFactory += 1
        
        return identifierFactory
    }
    
    init(color: Color, shape: Shape, shade: Shade, number: Number) {
        self.identifier = Card.generateID()
        
        self.color = color
        self.shape = shape
        self.shade = shade
        self.number = number
    }
}

enum Color: String {
    case green, red, purple
    
    func returnColor() -> UIColor {
        switch self {
        case .green:
            return #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        case .red:
            return #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        case .purple:
            return #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 1)
        }
    }
}

enum Shape {
    case circle, triangle, rectangle
}

enum Shade {
    case fill, open, stripped
}

enum Number {
    case one, two, three
}

