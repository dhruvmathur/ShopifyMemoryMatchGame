//
//  ViewController.swift
//  ShopifyMemoryMatchGame
//
//  Created by Dhruv Mathur on 2019-09-16.
//  Copyright © 2019 Dhruv Mathur. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var game = MatchingGame(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var scoreCountLabel: UILabel!
    @IBOutlet weak var flipCountLabel: UILabel!
    @IBOutlet weak var stepperButton: UIStepper!
    
    var flips: Int = 0
    var scores: Int = 0
    
    var currentStepperValue = 4
    
    
    @IBAction func stepperValueChanged(_ sender: Any) {
        for view in buttonStackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        for view in buttonStackView.subviews {
            view.removeFromSuperview()
        }
        setupGrid()
        setupNewGame()
        
        currentStepperValue = Int(stepperButton.value)
        let counter = String(Int(stepperButton.value))
        countLabel.text = "4 x \(counter)"
    }
    
    func setupGrid() {
        cardButtons = []
        for _ in 0..<Int(stepperButton.value) {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.alignment = .fill
            stackView.distribution = .fillEqually
            stackView.spacing = 5
            
            for _ in 0...3 {
                let button = UIButton(frame: CGRect(x: 0, y: 0, width: 79, height: 200))
                button.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                button.layer.cornerRadius = 8
                
                stackView.addArrangedSubview(button)
                cardButtons.append(button)
            }
            
            buttonStackView.addArrangedSubview(stackView)
        }

    }
    
    @objc func buttonAction(sender: UIButton!) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
    }
    
    
    private var flipCount = 0 {
        didSet {
            flipCountLabel.text = "Flips: \(flipCount)"
            flips = flipCount
        }
    }
    
    private var scoreCount = 0 { didSet {
        scoreCountLabel.text = "Score: \(scoreCount)"
        scores = scoreCount
        }
    }
    
    var cardButtons: [UIButton] = []
    @IBOutlet weak var buttonStackView: UIStackView!
    
    @IBAction func touchNewGame(_ sender: UIButton) {
        setupNewGame()
    }
    
    func setupNewGame(){
        // reset game
        game = MatchingGame(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
        imageChoices = imagesCache.getImages()
        
        // update view
        updateViewFromModel()
    }
    
    override func viewDidLoad() {
        stepperButton.wraps = true
        stepperButton.autorepeat = true
        stepperButton.maximumValue = 8
        stepperButton.minimumValue = 4
        stepperButton.value = 4
        let counter = String(Int(stepperButton.value))
        countLabel.text = "4 x \(counter)"
        
        NotificationCenter.default.addObserver(self, selector: #selector(newGameCreate(_:)), name: .newGameNotif, object: nil)
        
        setupGrid()
    }
    
    @objc func newGameCreate(_ notification:Notification) {
        setupNewGame()
    }
    
    private func updateViewFromModel() {
        flipCount = game.flipCount
        scoreCount = game.score
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setImage(image(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setImage(nil, for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            }
        }
        
        if game.allCardsHaveBeenMatched {
            if let presentedViewController = self.storyboard?.instantiateViewController(withIdentifier: "final") as? CompleteWinViewController {
                presentedViewController.providesPresentationContextTransitionStyle = true
                presentedViewController.definesPresentationContext = true
                presentedViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext;
                presentedViewController.view.backgroundColor = UIColor.init(white: 0, alpha: 0)
                presentedViewController.score = scores
                presentedViewController.flips = flips
                presentedViewController.updateScores()
                self.present(presentedViewController, animated: true, completion: nil)
            }
        }
    }
    private var imagesCache = Images()
    
    private lazy var imageChoices = imagesCache.getImages()
    
    private var images = [Card: UIImage]()
    
    private func image(for card: Card) -> UIImage {
        if images[card] == nil, imageChoices.count > 0 {
            images[card] = imageChoices.remove(at: imageChoices.count.arc4random)
        }
        return images[card] ?? UIImage()
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        }else {
            return 0
        }
    }
}

extension Notification.Name {
    static let newGameNotif = Notification.Name("newGameNotif")
}
