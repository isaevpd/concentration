//
//  ViewController.swift
//  Concentration
//
//  Created by Pavel Isaev on 10/11/2018.
//  Copyright © 2018 Pavel Isaev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var game: Concentration!
    var flipCount = 0 {
        didSet {
            updateFlipCountLabel()
        }
    }
    private var currentTheme = ""
    private let gameThemes = [
        "halloween": #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1),
        "animals": #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1),
        "christmas": #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1),
        "breakfast": #colorLiteral(red: 0.9842674136, green: 0.4686774611, blue: 0.7542788386, alpha: 1),
        "faces": #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1),
        "instruments": #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
    ]
    private var emojiThemes = [String: [String]]()
    private var emoji = [Card: String]()
    
    private func emoji(for card: Card) -> String {
        var emojiChoices = emojiThemes[currentTheme]!
        if emoji[card] == nil {
            let randomIndex = Int.random(in: 0..<emojiChoices.count)
            emoji[card] = emojiChoices.remove(at: randomIndex)
        }
        emojiThemes[currentTheme] = emojiChoices
        return emoji[card] ?? "?"
    }
    
    private func updateFlipCountLabel() {
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeWidth: 5.0,
            .strokeColor: gameThemes[currentTheme]!
        ]
        flipCountLabel.attributedText = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributes)
    }
    

    @IBOutlet weak var gameResultLabel: UILabel!
    @IBOutlet weak var flipCountLabel: UILabel!
    @IBOutlet var cardButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        game = Concentration(numberOfPairsOfCards: cardButtons.count / 2)
        gameInit()
    }
    
    @IBOutlet weak var newGameButton: UIButton!
    @IBAction func newGame(_ sender: UIButton) {
        gameInit()
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        if !game.isOver() {
            if let cardNumber = cardButtons.index(of: sender) {
                game.chooseCard(at: cardNumber)
                flipCount = game.flipCount
                updateViewFromModel()
            } else {
                print("choosen card was not in cardButtons")
            }
        }
        if game.isOver() {
            gameResultLabel.text = "Congrats! You won! It took you \(flipCount) flips to finish the game! Press New Game to try again!"
            gameResultLabel.textColor = gameThemes[currentTheme]
        }
    }
    
    func gameInit() {
        currentTheme = gameThemes.keys.randomElement()!
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeWidth: 5.0,
            .strokeColor: gameThemes[self.currentTheme]!
        ]
        newGameButton.setAttributedTitle(NSAttributedString(string: "New Game", attributes: attributes), for: .normal)
        game.newGame(numberOfPairsOfCards: cardButtons.count / 2)
        flipCount = 0
        gameResultLabel.text = ""
        emojiThemes = [
            "halloween": ["🦇", "😱", "🙀", "😈", "🎃", "👻", "🍭", "🍬", "🍎"],
            "animals": ["🐶", "🦁", "🐫", "🐒", "🐙", "🐛", "🐡", "🐢"],
            "christmas": ["🎄", "☃️", "🦌", "🎅🏻", "🤶", "❄️"],
            "breakfast": ["🥣", "🥝", "🥜", "🍋", "🍌", "🍯"],
            "faces": ["😡", "😢", "😎", "😍", "🤗", "😳", "😴"],
            "instruments": ["🎸", "🎹", "🥁", "🎺", "🎻", "🎵"]
        ]
        emoji.removeAll()
        updateViewFromModel()
    }
    
    func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : gameThemes[currentTheme]
            }
        }
    }
}














