//
//  ViewController.swift
//  assignment3
//
//  Created by klioop on 2021/08/04.
//

import UIKit

class ViewController: UIViewController {
    
    var count: Int = 0 {
        didSet {
            
        }
    }
    
    var engine: SetEngine? {
        didSet { updateUI() }
    }
    
    var timerLabel: UILabel = {
        let label = UILabel()

        return label
    }()
    
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
        let plusImage = UIImage(systemName: "plus.circle.fill")
        
        button.setImage(plusImage, for: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 20), forImageIn: .normal)
        button.addTarget(self,
                         action: #selector(touchNewGameButton),
                         for: .touchUpInside)
        
        return button
    }()
    
    var deal3CardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Deal 3 Card", for: .normal)
        button.addTarget(self,
                         action: #selector(touchDealButton),
                         for: .touchUpInside)
        return button
    }()
    
    var boardView: UIView = {
        let board = UIView()
//        board.backgroundColor = .systemIndigo
        
        return board
    }()
    
    let topStackView = UIStackView()
    let bottomStackView = UIStackView()
    
    // MARK: - button selector functions
    
    @objc func touchNewGameButton() {
        engine = SetEngine()
    }
    
    @objc func touchDealButton() {
        engine?.dealThreeCard()
        updateUI()
    }
    
    // MARK: - functions
    
    func updateUI() {
        updateScoreLabelUI()
        updateRemainingDeckCardLabelUI()
        updateBoard()
    }
    
}

// MARK: - override functions

extension ViewController {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        view.setNeedsUpdateConstraints()
        boardView.removeAllSubViews()
        boardView.setNeedsUpdateConstraints()
        updateBoard()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        engine = SetEngine()
        [boardView].forEach { view.addSubview($0) }
        
        topStackViewConfigure()
        autoLayoutBoard()
        bottomStackViewConfigure()
        updateUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateBoard()
    }
}


// MARK: - configure board view

extension ViewController {
    
    func autoLayoutBoard() {
        boardView.anchor(top: topStackView.bottomAnchor,
                         leading: view.safeAreaLayoutGuide.leadingAnchor,
                         trailing: view.safeAreaLayoutGuide.trailingAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         padding: .init(top: 0,
                                        left: 0,
                                        bottom: view.frame.size.height * 0.2,
                                        right: 0)
                         )
        
        addPinchGestureToBoard(for: boardView)
        
    }
    
    func getGrid() -> Grid? {
        
        let tupleOfRowsAndColumnsOfBoard = getRowsAndColumnsForGrid()
        var grid = Grid(layout: .dimensions(rowCount: tupleOfRowsAndColumnsOfBoard.0,
                                            columnCount: tupleOfRowsAndColumnsOfBoard.1),
                        frame: boardView.frame)
        grid.frame.origin = boardView.frame.origin
        
        return grid
    }
    
    func getCardView(card: Card) -> SetCardView {
        let card = SetCardView(number: card.number,
                    shape: card.shape,
                    shade: card.shade,
                    color: card.color,
                    isSelected: card.isSelected)
        
        addTapGesture(for: card)

        return card
    }
    
    func getRowsAndColumnsForGrid() -> (Int, Int) {
        guard let engine = engine else { return (0, 0) }
        
        let numberOfCardsOnBoard: Double = Double(engine.cardsOnTable.count)
        var rows = Int(sqrt(numberOfCardsOnBoard))
        var columns = rows
        
        if view.frame.size.width < view.frame.size.height {
            
            if (rows * rows) < Int(numberOfCardsOnBoard) {
                rows += 1
            }
            columns = rows
            if rows * (columns - 1) >= Int(numberOfCardsOnBoard) {
                columns -= 1
            }
            
        } else {
            columns += 1
            if (rows * columns) <= Int(numberOfCardsOnBoard) {
                columns += 1
            }
        }
        
        return (rows, columns)
    }
    
    func updateBoard() {
        boardView.removeAllSubViews()
        
        guard let grid = getGrid() else { return }
        guard let cardsOnBoard = engine?.cardsOnTable else { return }
        
        cardsOnBoard.indices.forEach {
            let cardView = getCardView(card: cardsOnBoard[$0])
            if let cardFrame = grid[$0] {
                boardView.addSubview(cardView)
                if view.frame.size.width > view.frame.size.height {
                    let newFrame = CGRect(origin: cardFrame.origin,
                                          size: CGSize(width: cardFrame.height * 0.8,
                                                       height: cardFrame.height))
                    cardView.frame = newFrame.insetBy(dx: newFrame.width * 0.01,
                                                      dy: newFrame.height * 0.01)
                } else {
                    cardView.frame = cardFrame.insetBy(dx: cardFrame.width * 0.01,
                                                       dy: cardFrame.height * 0.01)
                }
            }
            
            cardView.makeRoundedCorner()
            cardView.drawBorderDependingOnTapped()
            cardView.backgroundColor = .systemBackground
        }
    }
}

// MARK: - functions related to label and button UI

extension ViewController {
    
    func updateScoreLabelUI() {
        guard let engine = engine else { return }
        
        scoreLabel.text = "Score: \(engine.score)"
    }
    
    func updateRemainingDeckCardLabelUI() {
        guard let engine = engine else { return }
        
        remainingDeckCardLabel.text = "Deck: \(engine.remaingCardOnDeck ?? 0)"
    }
    
    func topStackViewConfigure() {
        [scoreLabel, newGameButton].forEach { topStackView.addArrangedSubview($0) }
        view.addSubview(topStackView)
        
        topStackView.axis = .horizontal
        topStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                            leading: view.leadingAnchor,
                            trailing: view.trailingAnchor,
                            bottom: nil,
                            padding: .init(top: 0,
                                           left: 0,
                                           bottom: 0,
                                           right: 0))
        topStackView.distribution = .equalSpacing
        topStackView.isLayoutMarginsRelativeArrangement = true
        topStackView.layoutMargins = .init(top: 0,
                                           left: view.frame.size.width * 0.05,
                                           bottom: 0,
                                           right:  view.frame.size.width * 0.05)
    }
    
    func bottomStackViewConfigure() {
        [remainingDeckCardLabel, deal3CardButton].forEach { bottomStackView.addArrangedSubview($0) }
        view.addSubview(bottomStackView)
        
        bottomStackView.axis = .horizontal
        bottomStackView.anchor(top: nil,
                               leading: view.leadingAnchor,
                               trailing: view.trailingAnchor,
                               bottom: view.safeAreaLayoutGuide.bottomAnchor,
                               padding: .init(top: 0,
                                              left: 0,
                                              bottom: view.frame.height * 0.05,
                                              right: 0))
        bottomStackView.distribution = .equalSpacing
        bottomStackView.isLayoutMarginsRelativeArrangement = true
        bottomStackView.layoutMargins = .init(top: 0,
                                           left: view.frame.size.width * 0.05,
                                           bottom: 0,
                                           right:  view.frame.size.width * 0.05)
        boardView.layer.borderWidth = 2
        boardView.layer.borderColor = UIColor.systemYellow.cgColor
    }
}

// MARK: - gesture related

extension ViewController {
    
    func addPinchGestureToBoard(for boardView: UIView) {
        let pinch = UIPinchGestureRecognizer(target: self,
                                             action: #selector(
                                                pinchHandler(recognizer:)
                                                ))
        boardView.addGestureRecognizer(pinch)
    }
    
    func addTapGesture(for cardView: SetCardView) {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(
                                            handlerWhenTapped(byHandlingTapGestureRecognizer:)
                                            ))
        cardView.addGestureRecognizer(tap)
    }
    
    @objc func pinchHandler(recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            engine?.cardsOnTable.shuffle()
            updateUI()
            recognizer.scale = 1.0
        default:
            break
        }
    }
    
    @objc func handlerWhenTapped(byHandlingTapGestureRecognizer recognizer: UITapGestureRecognizer) {
        guard let cardView = recognizer.view as? SetCardView else { return }
        guard let tempNum = boardView.subviews.firstIndex(of: cardView) else { return }
        
        switch recognizer.state {
        case .ended:
            engine?.touchCard(at: tempNum)
            updateUI()
        default:
            break
        }
    }
}

// MARK: - timer

extension ViewController {
    
    var timer: Timer {
        get {
            let interval: TimeInterval = 1
            
            return Timer.scheduledTimer(withTimeInterval: interval,
                                 repeats: true) { [unowned self] _ in
                self.count += 1
            }
        }
    }
    
}


extension UIView {
    
    func removeAllSubViews() {
        subviews.forEach { $0.removeFromSuperview() }
        setNeedsDisplay()
    }
}
