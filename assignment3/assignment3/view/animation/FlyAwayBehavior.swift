//
//  CardBehaviors.swift
//  assignment3
//
//  Created by klioop on 2021/08/14.
//

import UIKit

class FlyAwayBehavior: UIDynamicBehavior {
    
    var snapPoint: CGPoint = .zero
    
    var snapPhase: Bool = false
    
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
    
    private func snap(_ item: UIDynamicItem) {
        let snap = UISnapBehavior(item: item, snapTo: snapPoint)
        snapPhase = true
        
        snap.damping = 2.0
        self.dynamicAnimator?.removeBehavior(self.collisionBehavior)
        
        Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false) { _ in
            self.addChildBehavior(snap)
        }
    }
    
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
        
        push.magnitude = CGFloat(10.0) + CGFloat(10.0) * CGFloat.random(in: 0.2..<1)
        push.action = { [unowned push, weak self] in
            self?.removeChildBehavior(push)
        }
        addChildBehavior(push)
    }
    
    func addItem(_ item: UIDynamicItem) {
        collisionBehavior.addItem(item)
        itemBehavior.addItem(item)
        push(item)
        snap(item)
    }
    
    func addItemForSnap(_ item: UIDynamicItem) {
        dynamicAnimator?.removeBehavior(collisionBehavior)
        
        snap(item)
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
