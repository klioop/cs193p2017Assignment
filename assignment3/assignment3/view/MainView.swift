//
//  MainView.swift
//  assignment3
//
//  Created by klioop on 2021/08/04.
//

import UIKit

class MainView: UIView {
    
    private lazy var grid = Grid(layout: .dimensions(rowCount: 3, columnCount: 3), frame: bounds)
    
    var setCard = SetCardView(number: .two,
                              shape: .squiggle,
                              shade: .stripped,
                              color: .green)
    var setCard2 = SetCardView(number: .three, shape: .diamond, shade: .open, color: .purple)
    var setCard3 = SetCardView(number: .three, shape: .oval, shade: .open, color: .red)
    
    var tempCards = [SetCardView]()
    
    private func configureSetCard() {
        tempCards += [setCard2, setCard3]
        (2..<10).forEach { _ in tempCards.append(setCard) }
        tempCards.indices.forEach {
            if let cardFrame = grid[$0] {
//                print(cardFrame)
                let newCardFrame = cardFrame.insetBy(dx: cardFrame.size.width * 0.01, dy: cardFrame.size.height * 0.01)
                addSubview(tempCards[$0])
                tempCards[$0].frame = newCardFrame
            
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
//        setCard.draw(bounds)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        setCard.frame = bounds
        configureSetCard()
        
    }
    
}
