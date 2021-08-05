//
//  ViewController.swift
//  assignment3
//
//  Created by klioop on 2021/08/04.
//

import UIKit

class ViewController: UIViewController {
    
    var engine: SetEngine?
    
    var scoreLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    var remainingDeckCardLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    var newGameButton: UIButton = {
        let button = UIButton(type: .system)
        button.imageView?.image = UIImage(systemName: "plus.circle.fill")
        
        return button
    }()
    
    var deal3CardButton: UIButton = {
        let button = UIButton(type: .system)
        
        return button
    }()
    
    var boardView: UIView = {
        let board = UIView()
        board.backgroundColor = .systemIndigo
        
        return board
    }()
    
    func updateUI() {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        engine = SetEngine()
        [boardView].forEach { view.addSubview($0) }
        autoLayoutBoard()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateBoard()
    }

}

// MARK: - configure board view

extension ViewController {
    
    func autoLayoutBoard() {
        boardView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         leading: view.leadingAnchor,
                         trailing: view.trailingAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         padding: .init(top: 0,
                                        left: 0,
                                        bottom: 100,
                                        right: 0)
                         )
        
    }
    
    func getGrid() -> Grid? {
        var grid = Grid(layout: .dimensions(rowCount: 3, columnCount: 3),
                        frame: boardView.frame)
        grid.frame.origin = boardView.frame.origin
        
        return grid
    }
    
    func getCardView(card: Card) -> SetCardView {
        SetCardView(number: card.number,
                    shape: card.shape,
                    shade: card.shade,
                    color: card.color)
    }
    
    func updateBoard() {
        guard let grid = getGrid() else { return }
        
        guard let cardsOnBoard = engine?.cardsOnTable else { return }
        cardsOnBoard.indices.forEach {
            let cardView = getCardView(card: cardsOnBoard[$0])
            if let cardFrame = grid[$0] {
                boardView.addSubview(cardView)
                cardView.frame = cardFrame.insetBy(dx: cardFrame.width * 0.01,
                                                   dy: cardFrame.height * 0.01)
            }
        }
    }
    
}
