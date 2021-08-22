//
//  ViewController.swift
//  assignment3
//
//  Created by klioop on 2021/08/04.
//

import UIKit

class SetGameViewController: UIViewController {
    
    lazy var animator: UIDynamicAnimator = UIDynamicAnimator(referenceView: view)
    
    lazy var flyAwayBehavior = FlyAwayBehavior(in: animator)
    
    var numberOfTouchCard = 0
    
    var isDeal: Bool = false
    
    var count: Int = 0 {
        didSet {
            
        }
    }
    
    var engine: SetEngine?
    
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
        let plusImage = UIImage(systemName: "plus.circle")
        
        button.setImage(plusImage, for: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 20), forImageIn: .normal)
        button.addTarget(self,
                         action: #selector(touchNewGameButton),
                         for: .touchUpInside)
        button.tintColor = .systemIndigo
        
        return button
    }()
    
    var deal3CardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Deal 3 Card", for: .normal)
        button.addTarget(self,
                         action: #selector(touchDealButton),
                         for: .touchUpInside)
        button.contentEdgeInsets = .init(top: 5, left: 10, bottom: 5, right: 10)
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 5
        
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
        if let engine = engine, engine.remaingCardOnDeck == 0 {
            return
        }
        isDeal = true
        updateBoard()
    }
    
    // MARK: - functions
    
    func updateUI() {
        updateScoreLabelUI()
        updateRemainingDeckCardLabelUI()
        updateBoard()
    }
    
}

// MARK: - override functions

extension SetGameViewController {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        view.setNeedsUpdateConstraints()
        boardView.removeAllSubViews()
        boardView.setNeedsUpdateConstraints()
        updateBoard()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        [boardView].forEach { view.addSubview($0) }
        
        topStackViewConfigure()
        autoLayoutBoard()
        bottomStackViewConfigure()
        engine = SetEngine()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateUI()
    }
    
}


// MARK: - configure board view

extension SetGameViewController {
    
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
    
    /// There are 3 ways to divide frame size of a view into grid using grid file
    /// I first tried the way where rows and columns for grid have to be determined
    /// But, the way of deciding aspect ratio of the grid was chosen
    /// Note that the aspect ratio is for the whole area for the grid, not each grid cell
    /// And, with aspect ratio, you have to set cell count property of grid
    func getGrid() -> Grid? {
        
//        let tupleOfRowsAndColumnsOfBoard = getRowsAndColumnsForGrid()
//        var grid = Grid(layout: .dimensions(rowCount: tupleOfRowsAndColumnsOfBoard.0,
//                                            columnCount: tupleOfRowsAndColumnsOfBoard.1),
//                        frame: boardView.frame)
//        grid.frame.origin = boardView.frame.origin
        
        var grid = Grid(layout: .aspectRatio(1), frame: boardView.frame)
        grid.cellCount = engine?.cardsOnTable.count ?? 10
        
        return grid
    }
    
    func getCardView(card: Card) -> SetCardView {
        let card = SetCardView(
            number: card.number,
            shape: card.shape,
            shade: card.shade,
            color: card.color,
            isSelected: card.isSelected,
            isMatched: card.isMatched
        )
        
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
        guard let grid = getGrid() else { return }
        guard let cardsOnBoard = engine?.cardsOnTable else { return }
        
        if !isDeal {
            boardView.removeAllSubViews()
            
            cardsOnBoard.indices.forEach {
                let cardView = getCardView(card: cardsOnBoard[$0])
                if let cardFrame = grid[$0] {
                    boardView.addSubview(cardView)
                    cardView.frame = cardFrame.insetByScale(of: 0.01)
                }
                cardView.drawBorderDependingOnTapped()
                configureCardView(cardView)
            }
        } else {
            updateBoardUIWhenDeal()
            isDeal = false
        }
    }
    
    private func updateBoardUIWhenDeal() {
        guard let grid = getGrid() else { return }
        guard let cardsOnBoard = engine?.cardsOnTable else { return }
        let countOfCardsOnBoard = cardsOnBoard.count
        
        (0..<cardsOnBoard.count - 3).forEach { idx in
            if let newCardFrame = grid[idx]?.insetByScale(of: 0.01) {
                simpleAnimation {
                    self.boardView.subviews[idx].frame = newCardFrame
                }
            }
        }
        
        let lastThreeCardsIndices: [Int] = Array((countOfCardsOnBoard - 3..<countOfCardsOnBoard))
        updateUIForDealCardsIn(for: lastThreeCardsIndices)
    }
    
    private func updateUIForDealCardsIn(for indices: [Int]) {
        guard let grid = getGrid() else { return }
        guard let cardsOnBoard = engine?.cardsOnTable else { return }
        var tempNumber = 0
        
        indices.forEach { idx in
            
            tempNumber += 1
            let timeIntervalValue = Double(tempNumber) * 0.4
            let cardView = getCardView(card: cardsOnBoard[idx])
            
            if let isSet = engine?.findSet, isSet {
                boardView.insertSubview(cardView, at: idx)
                boardView.subviews[idx + 1].removeFromSuperview()
            } else {
                boardView.addSubview(cardView)
            }
            guard let cardFrame = grid[idx]?.insetByScale(of: 0.01) else { return }
            
            boardView.subviews[idx].frame = cardFrame
            boardView.subviews[idx].alpha = 0
            
            configureCardView(cardView)
            
            self.boardView.subviews[idx].frame.origin = CGPoint(x: 277, y: self.view.frame.height * 0.8)
            self.boardView.subviews[idx].frame.size = self.bottomStackView.arrangedSubviews[1].frame.size
            
            Timer.scheduledTimer(withTimeInterval: TimeInterval(timeIntervalValue),
                                 repeats: false) { [unowned self] _ in
                self.simpleAnimation {
                    self.boardView.subviews[idx].frame = cardFrame
                    self.boardView.subviews[idx].alpha = 1
                    self.boardView.subviews[idx].setNeedsDisplay()
                } completion: { fin in
                    self.boardView.subviews.forEach { $0.setNeedsDisplay() }
                }
            }
        }
    }
    
    /// update ui when set
    /// This function is called in the gesture selector
    private func updateBoardUIWhenSet() {
        
        if let isSet = engine?.findSet, isSet {
            guard let recentMatchedCardsIndices = engine?.lastMatchedCardsIndices else { return }
            
            flyAwayAnimation()
            
            engine?.replaceMatchedCards()
            
            updateUIForDealCardsIn(for: recentMatchedCardsIndices)
            
//            boardView.subviews.forEach { $0.setNeedsDisplay() }
            
            engine?.findSet = false
        }
    }
    
    private func flyAwayAnimation() {
        guard let engine = engine else { return }
        guard let recentMatchedCardsIndices = engine.lastMatchedCardsIndices else { return }
        var temp = 0
        guard let lastCardIndex = recentMatchedCardsIndices.last else { return }
        
        recentMatchedCardsIndices.forEach { idx in
            temp += 1
            let timeInterval = TimeInterval(Double(temp) * 0.5)
            
            let card = self.boardView.subviews[idx] as! SetCardView
            
            card.alpha = 0
            let cardViewCopy = getCardView(card: engine.cardsOnTable[idx])
            
            configureCardView(cardViewCopy)
            cardViewCopy.frame = card.frame
            boardView.addSubview(cardViewCopy)
            flyAwayBehavior.addItem(cardViewCopy)
            
            flyAwayBehavior.snapPoint = CGPoint(x: view.frame.maxX - 100, y: view.frame.maxY - 200)
            Timer.scheduledTimer(withTimeInterval: timeInterval,
                                 repeats: false,
                                 block: {_ in
//                                    self.flyAwayBehavior.addItemForSnap(cardViewCopy)
                                    self.animator.removeAllBehaviors()
                                    self.simpleAnimation {
                                        self.animator.addBehavior(UISnapBehavior(item: cardViewCopy, snapTo: self.flyAwayBehavior.snapPoint))
                                        cardViewCopy.frame.size.width = cardViewCopy.frame.width / 2
                                        cardViewCopy.frame.size.height = cardViewCopy.frame.height / 2
                                    } completion: { fin in
                                        if idx != lastCardIndex {
                                            cardViewCopy.alpha = 0
                                        }
                                        cardViewCopy.setNeedsDisplay()
                                    }
                                    
                                 })
            
        }
    }
    
    private func configureCardView(_ cardView: SetCardView) {
        cardView.makeRoundedCorner()
        cardView.backgroundColor = .systemBackground
    }
}

// MARK: - functions related to label and button UI

extension SetGameViewController {
    
    func updateScoreLabelUI() {
        guard let engine = engine else { return }
        
        scoreLabel.text = "Score: \(engine.score)"
    }
    
    func updateRemainingDeckCardLabelUI() {
        guard let engine = engine else { return }
        remainingDeckCardLabel.backgroundColor = .systemBackground
        
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
                                           left: view.frame.size.width * 0.03,
                                           bottom: 0,
                                           right:  view.frame.size.width * 0.03)
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
                                           left: view.frame.size.width * 0.03,
                                           bottom: 0,
                                           right:  view.frame.size.width * 0.03)
        boardView.layer.borderWidth = 2
        boardView.layer.borderColor = UIColor.systemYellow.cgColor
    }
}

// MARK: - gesture related

extension SetGameViewController {
    
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
                                            handlerWhenTapped(by:)
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
    
    @objc func handlerWhenTapped(by recognizer: UITapGestureRecognizer) {
        guard let cardView = recognizer.view as? SetCardView else { return }
        guard let indexOfCardTapped = boardView.subviews.firstIndex(of: cardView) else { return }
//        guard var engine = engine else { return }
        
        switch recognizer.state {
        case .ended:
            numberOfTouchCard += 1
            engine?.touchCard(at: indexOfCardTapped)
            updateBoard()
            updateBoardUIWhenSet()
        default:
            break
        }
    }
}

// MARK: - timer

extension SetGameViewController {
    
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

// MARK: - animation

extension SetGameViewController {
    
    func simpleAnimation(animation: @escaping () -> Void,
                         completion: ((_ position: UIViewAnimatingPosition) -> Void)? = nil ) {
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 1,
            delay: 0,
            options: [],
            animations: animation,
            completion: completion)
    }
    
    private func layoutSetCardsAnimation() {
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1,
                                                       delay: 0,
                                                       options: [],
                                                       animations: {
                                                        self.boardView.layoutIfNeeded()
                                                       })
    }
    
    private func dealCardsInAnimation() {
        let deck = UIView()
        deck.frame = deal3CardButton.frame
        view.addSubview(deck)
    }
}

// MARK: - UIDynamicAnimatorDelegate

extension SetGameViewController: UIDynamicAnimatorDelegate {
    
    var delegate: UIDynamicAnimatorDelegate {
        self
    }
    
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator, card: SetCardView) {
        
    }
    
}

extension UIView {
    
    func removeAllSubViews() {
        subviews.forEach { $0.removeFromSuperview() }
        setNeedsDisplay()
    }
}

extension CGRect {
    
    func insetByScale(of scale: CGFloat) -> CGRect {
        insetBy(dx: size.width * scale, dy: size.height * scale)
    }
}

