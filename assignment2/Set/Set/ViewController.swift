//
//  ViewController.swift
//  Set
//
//  Created by klioop on 2021/07/21.
//

import UIKit

class ViewController: UIViewController {
    
    var engine: SetEngine? {
        didSet { updateUI() }
    }
    
    func buttonTitle(of card: Card) -> NSAttributedString{
        var result = ""
        let shape = card.shape.returnShape()
        let color = card.color.returnColor()
        let shade = card.shade.returnShade()
        
        switch card.number {
        case .one:
            result = "\(shape)"
        case .two:
            result = "\(shape)\n\(shape)"
        case .three:
            result = "\(shape)\n\(shape)\n\(shape)"
        }
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color.withAlphaComponent(shade),
            .strokeColor: color,
            .strokeWidth: -3
        ]
        let attributedString = NSAttributedString(string: result, attributes: attributes)
        
        return attributedString
    }
    
    func updateUI() {
        guard let numberOfCardsOnTable = engine?.cardsOnTable.count else { return }
        
        engine?.cardsOnTable.indices.forEach{
            
            let button = cardButtons[$0]
            guard let card = engine?.cardsOnTable[$0] else { return }
            
            button.backgroundColor = nil
            button.setAttributedTitle(buttonTitle(of: card), for: UIControl.State.normal)
            
            button.layer.cornerRadius = 10
            button.layer.borderWidth = card.isSelected ? 3 : 0
            button.layer.borderColor = card.isSelected ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            
            let fontSelected = UIFont.systemFont(ofSize: 20.0)
            let fontNormal = UIFont.systemFont(ofSize: 25.0)
            button.titleLabel?.font = card.isSelected ? fontSelected : fontNormal
        }
        
        (numberOfCardsOnTable..<cardButtons.count).forEach {
            let button = cardButtons[$0]
            button.isEnabled = false
            button.setTitle("", for: UIControl.State.disabled)
            button.backgroundColor = nil
        }
        
        scoreLabel.text = "Score: \(engine!.score)"
    }
    
    // MARK: - Outlets
    
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var newGameButton: UIButton!
    
    // MARK: - IBActions
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            engine?.touchCard(at: cardNumber)
        }
        updateUI()
    }
    
    @IBAction func touchNewGame(_ sender: UIButton) {
    }
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        engine = SetEngine()
    }
}

