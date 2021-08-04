//
//  ViewController.swift
//  Set
//
//  Created by klioop on 2021/07/21.
//

import UIKit

class ViewController: UIViewController {
    
    var engine: SetEngine? {
        didSet {
            updateUI()
        }
    }
    
    func buttonTitle(of card: Card) -> NSAttributedString {
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
        
        (numberOfCardsOnTable..<cardButtons.count).forEach {
            let button = cardButtons[$0]
            button.setTitle("", for : UIControl.State.normal)
            print(button.title(for: .normal)!)
            button.backgroundColor = nil
            button.isEnabled = false
            button.isHidden = true
        }
        
        engine?.cardsOnTable.indices.forEach{
            
            let button = cardButtons[$0]
            guard let card = engine?.cardsOnTable[$0] else { return }
            
            button.isEnabled = true
            button.isHidden = false
            button.backgroundColor = nil
            button.setAttributedTitle(buttonTitle(of: card), for: UIControl.State.normal)
            
            button.layer.cornerRadius = 10
            button.layer.borderWidth = card.isSelected ? 3 : 0
            button.layer.borderColor = card.isSelected ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            
            let fontSizeSelected = UIFont.systemFont(ofSize: 20.0)
            let fontSizeNormal = UIFont.systemFont(ofSize: 25.0)
            button.titleLabel?.font = card.isSelected ? fontSizeSelected : fontSizeNormal
        }
        
        scoreLabel.text = "Score: \(engine!.score)"
        deal3CardsButton.setTitle("Deal 3 Cards", for: .normal)
        numOfCardsOnDeckLabel.text = "Deck: \(engine?.remaingCardOnDeck ?? 0)"
    }
    
    // MARK: - Outlets
    
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var numOfCardsOnDeckLabel: UILabel!
    @IBOutlet weak var deal3CardsButton: UIButton!
    
    // MARK: - IBActions
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            engine?.touchCard(at: cardNumber)
        }
        updateUI()
    }
    
    @IBAction func touchNewGame(_ sender: UIButton) {
        engine = SetEngine()
    }
   
    @IBAction func touchDeal(_ sender: UIButton) {
        engine?.dealThreeCard()
        updateUI()
    }
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        engine = SetEngine()
    }
}

