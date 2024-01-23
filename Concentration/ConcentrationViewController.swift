//
//  ConcentrationViewController.swift
//  Concentration
//
//  Created by nadya on 26.09.2023.
//

import UIKit

class ConcentrationViewController: UIViewController {
    
    private var hintTimer: Timer?
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairesOfCards)
    
    private (set) var flipCount = 0 {
        didSet {
            updateFlipCountLabel()
        }
    }
    
    private func updateFlipCountLabel() {
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeWidth: 5.0,
            .strikethroughColor: #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    private (set) var scoreCount = 0 {
        didSet {
            updateScoreCountLabel()
        }
    }
    
    private func updateScoreCountLabel() {
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeWidth: 5.0,
        ]
        let attributedString = NSAttributedString(string: "Score: \(scoreCount)", attributes: attributes)
        scoreCountLabel.attributedText = attributedString
    }
    
    var numberOfPairesOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    @IBOutlet private var cardButtons: [UIButton]!
    @IBOutlet private weak var cardButtonsStack: UIStackView!
    @IBOutlet private weak var restartButton: UIButton!
    @IBOutlet private weak var shuffleCardsButton: UIButton!
    @IBOutlet weak var hintButton: UIButton!
    
    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet {
            updateFlipCountLabel()
        }
    }
        
    @IBOutlet private weak var scoreCountLabel: UILabel! {
        didSet {
            updateScoreCountLabel()
        }
    }
    
    private var emojiChoices = "🍓🍇🍑🍎🍉🍋🫐🍒🍏🥭🍌🥥🍍🥝🍐🍊🍈🥑🫑🥒🌶🌽🥕🥬"
    
    private var emoji = [Card: String]()
    
    private var numberOfCards = 8
    
    var theme: String? {
        didSet {
            emojiChoices = theme ?? ""
            emoji = [:]
            updateViewFromModel()
        }
    }
    
    var difficultyLevel: Difficulty? {
        didSet {
            switch difficultyLevel {
            case .beginner:
                numberOfCards = 8
            case .medium:
                numberOfCards = 12
            case .master:
                numberOfCards = 24
            default:
                numberOfCards = 12
            }
            if cardButtons != nil {
                updateNumberOfCardButtons()
                game = Concentration(numberOfPairsOfCards: numberOfPairesOfCards)
                updateViewFromModel()
            }
        }
    }
    
    func updateNumberOfCardButtons() {
        if cardButtons != nil {
            cardButtons.removeAll()
        }
        cardButtonsStack.arrangedSubviews.forEach {
            buttonView in cardButtonsStack.removeArrangedSubview(buttonView)
            buttonView.removeFromSuperview()
        }
        let rows = Int(numberOfCards / 4)
        let cols = Int(numberOfCards / rows)
        
        for _ in 1...rows {
            let rowCardStack = UIStackView()
            rowCardStack.spacing = 10
            rowCardStack.distribution = UIStackView.Distribution.fillEqually
            for _ in 1...cols {
                let cardButton = UIButton()
                cardButton.layer.cornerRadius = 8
                cardButton.layer.borderWidth = 2
                cardButton.layer.borderColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
                cardButton.addTarget(self, action: #selector(touchCard(_:)), for: .touchUpInside)
                cardButtons.append(cardButton)
                rowCardStack.addArrangedSubview(cardButton)
            }
            cardButtonsStack.addArrangedSubview(rowCardStack)
        }
    }
    
    override func viewDidLoad() {
        updateNumberOfCardButtons()
        for card in cardButtons {
            card.layer.cornerRadius = 8
        }
        restartButton.layer.cornerRadius = 10
        hintButton.layer.cornerRadius = 10
        shuffleCardsButton.layer.cornerRadius = 10
        updateViewFromModel()
    }
    
    @IBAction private func touchRestartGame(_ sender: UIButton) {
        game = Concentration(numberOfPairsOfCards: numberOfPairesOfCards)
        emojiChoices = theme ?? "🍓🍇🍑🍎🍉🍋🫐🍒🍏🥭🍌🥥🍍🥝🍐🍊🍈🥑🫑🥒🌶🌽🥕🥬"
        flipCount = 0
        scoreCount = 0
        emoji = [:]
        hintButton.layer.backgroundColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
        updateViewFromModel()
    }
    
    @IBAction func touchShowHint(_ sender: Any) {
        if !game.isHintUsed {
            game.useHint()
            game.flipAllCardsFaceUp()
            updateViewFromModel()
            hintTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
                self.game.flipAllCardsFaceDown()
                self.updateViewFromModel()
                timer.invalidate()
            }
        }
        hintButton.layer.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    }
    
    @IBAction private func touchShuffleCards(_ sender: UIButton) {
        game.shuffleCards()
        updateViewFromModel()
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("choosen card was not in cardButtons")
        }
    }
    
    private func updateViewFromModel() {
        if cardButtons != nil {
            for index in cardButtons.indices {
                let button = cardButtons[index]
                let card = game.cards[index]
                if card.isFaceUp {
                    button.setTitle(emoji(for: card), for: UIControl.State.normal)
                    button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                } else {
                    button.setTitle("", for: UIControl.State.normal)
                    button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1)
                }
            }
            scoreCountLabel.text = "Score: \(game.score)"
        }
    }
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        return emoji[card] ?? "?"
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
