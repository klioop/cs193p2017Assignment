//
//  ViewController.swift
//  cs193p2017Assignment
//
//  Created by klioop on 2021/07/16.
//

// cmd + \ is shortcut for setting debug

import UIKit

class ViewController: UIViewController {
    
    var game: Concentration! {
        didSet {
            updateUI()
        }
    }
    
//    var emojiChoice = ["🤐", "😵‍💫", "🤢", "🤮", "🤧", "😷", "👺", "💩"]
    var emojiChoice = EmojiCollection.returnEmojiSet(for: Theme.halloween)
    var emoji = [Card: String]()
    var flipCount: Int = 0
    
    // 위 hash 와 같은 이름을 갖는 함수지만 상관없다
    // swift 의 함수는 external parmeter name 을 갖기 때문에 함수의 인자가 있을 경우 쉽게 구별가능
    func emoji(for card: Card) -> String {
        if emoji[card] == nil {
            let randomIdx = Int.random(in: emojiChoice.indices)
            emoji[card] = emojiChoice.remove(at: randomIdx)
        }
        
        return emoji[card] ?? "?"
    }
    
    private func updateFlipCount() {
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeWidth: 0.5,
            .strokeColor: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    private func updateUI() {
        scoreLabel.text = "Score: \(game.score)"
        
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
    @IBOutlet private var cardButtons: [UIButton]!
    @IBOutlet private weak var newGameButton: UIButton!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var flipCountLabel: UILabel!
    
    
    // MARK: - IBAction
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.touchCard(at: cardNumber)
        }
        updateUI()
    }
    
    @IBAction func touchNewGameButton(_ sender: UIButton) {
        emojiChoice = EmojiCollection.returnRandomEmojiSet()
        game = Concentration(numberOfPairsOfCards: cardButtons.count / 2)
    }
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let numberOfButtons = cardButtons.count
        game = Concentration(numberOfPairsOfCards: (numberOfButtons % 2 == 0 ? numberOfButtons / 2 : (numberOfButtons / 2) + 1))
        
        newGameButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration.init(pointSize: 25), forImageIn: UIControl.State.normal)
//        newGameButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration.init(pointSize: 10), forImageIn: UIControl.State.highlighted)
        
        
        for idx in cardButtons.indices {
            let button = cardButtons[idx]

            button.layer.cornerRadius = 10
            button.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        }
        
    }
    
}


