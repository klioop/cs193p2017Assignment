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

enum Color {
    case green, red, purple
    
    func returnColor() -> UIColor {
        switch self {
        case .green:
            return #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        case .red:
            return #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        case .purple:
            return #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 1)
        }
    }
}

enum Shape {
    case circle, triangle, rectangle
    
    func returnShape() -> String {
        let shapes = ["●", "▲", "■"]
        
        switch self {
        case .circle:
            return shapes[0]
        case .triangle:
            return shapes[1]
        case .rectangle:
            return shapes[2]
        }
    }
}

enum Shade {
    case fill, open, stripped
    
    func returnShade() -> CGFloat {
        switch self {
        case .fill:
            return 1.0
        case .open:
            return 0.0
        case .stripped:
            return 0.15
        }
    }
}

enum Number {
    case one, two, three
}

extension Color: Equatable {
    static func == (lhs: Color, rhs: Color) -> Bool {
        return lhs.returnColor() == rhs.returnColor()
    }
}

extension Shape: Equatable {
    static func == (lhs: Shape, rhs: Shape) -> Bool {
        return lhs.returnShape() == rhs.returnShape()
    }
}
