//
//  ViewController.swift
//  cs193p2017Assignment
//
//  Created by klioop on 2021/07/16.
//

// cmd + \ is shortcut for setting debug

import UIKit

class ViewController: UIViewController {

    
    lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count % 2 == 0 ? cardButtons.count / 2 : (cardButtons.count / 2) + 1))
    
    var emojiChoice = ["🤐", "😵‍💫", "🤢", "🤮", "🤧", "😷", "👺", "💩"]
    var emoji = [Int: String]()
    
    // 위 hash 와 같은 이름을 갖는 함수지만 상관없다
    // swift 의 함수는 external parmeter name 을 갖기 때문에 함수의 인자가 있을 경우 쉽게 구별가능
    func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil {
            let randomIdx = Int.random(in: emojiChoice.indices)
            emoji[card.identifier] = emojiChoice.remove(at: randomIdx)
        }
        
        return emoji[card.identifier] ?? "?"
    }
    
    func updateUI() {
        for idx in cardButtons.indices {
            let button = cardButtons[idx]
            let card = game.cards[idx]
            
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = nil
                button.layer.borderColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
                button.layer.borderWidth = 2
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
                button.layer.borderWidth = 0
            }
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var newGameButton: UIButton!
    
    
    // MARK: - IBAction
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.touchCard(at: cardNumber)
        }
        updateUI()
    }
    @IBAction func touchNewGameButton(_ sender: UIButton) {
    }
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newGameButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        for idx in cardButtons.indices {
            let button = cardButtons[idx]
            button.layer.cornerRadius = 10
            button.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        }
        
    }
}

