//
//  CardBehaviors.swift
//  assignment3
//
//  Created by klioop on 2021/08/14.
//

import UIKit

class FlayAwayBehavior: UIDynamicBehavior {
    
    lazy var collisionBehavior: UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        
        return behavior
    }()
    
    lazy var itemBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = true
        behavior.elasticity = 1.0
        behavior.resistance = 0
        
        return behavior
    }()
    
    private func push(_ item: UIDynamicItem) {
        let push = UIPushBehavior(items: [item], mode: .instantaneous)
        if let referenceBounds = dynamicAnimator?.referenceView?.bounds {
            let center = CGPoint(x: referenceBounds.midX, y: referenceBounds.midY)
            switch (item.center.x, item.center.y) {
            case let (x, y) where x < center.x && y < center.y:
                push.angle = (CGFloat.pi/2) * CGFloat.random(in: 0.2..<1)
            case let (x, y) where x > center.x && y < center.y:
                push.angle = CGFloat.pi-(CGFloat.pi/2) * CGFloat.random(in: 0.2..<1)
            case let (x, y) where x < center.x && y > center.y:
                push.angle = (-CGFloat.pi/2) * CGFloat.random(in: 0.2..<1)
            case let (x, y) where x > center.x && y > center.y:
                push.angle = CGFloat.pi+(CGFloat.pi/2) * CGFloat.random(in: 0.2..<1)
            default:
                push.angle = (CGFloat.pi*2) * CGFloat.random(in: 0.2..<1)
            }
        }
        push.magnitude = CGFloat(5.0) + CGFloat(2.0) * CGFloat.random(in: 0.2..<1)
        push.action = { [unowned push, weak self] in
            self?.removeChildBehavior(push)
        }
        addChildBehavior(push)
    }
    
    func addItem(_ item: UIDynamicItem) {
        collisionBehavior.addItem(item)
        itemBehavior.addItem(item)
        push(item)
    }
    
    func removeItem(_ item: UIDynamicItem) {
        collisionBehavior.removeItem(item)
        itemBehavior.removeItem(item)
    }
    
    
    override init() {
        super.init()
        addChildBehavior(collisionBehavior)
        addChildBehavior(itemBehavior)
    }
    
    convenience init(in animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }


}
