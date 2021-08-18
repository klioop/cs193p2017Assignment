//
//  CardBehaviors.swift
//  assignment3
//
//  Created by klioop on 2021/08/14.
//

import UIKit

class CardBehaviors: UIDynamicBehavior {
    
    
    override init() {
        super.init()
    }
    
    convenience init(in animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }


}
