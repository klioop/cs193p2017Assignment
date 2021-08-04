//
//  MainView.swift
//  assignment3
//
//  Created by klioop on 2021/08/04.
//

import UIKit

class MainView: UIView {
    
    let setCard = SetCardView(number: .two,
                              shape: .oval,
                              shade: .stripped,
                              color: .purple)
    
    private func configureSetCard() {
        setCard.frame = bounds
    }
    
    override func draw(_ rect: CGRect) {
        addSubview(setCard)
        setCard.draw(bounds)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureSetCard()
        
    }
    
}
