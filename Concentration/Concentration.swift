//
//  Concentration.swift
//  Concentration
//
//  Created by Pavel Isaev on 10/11/2018.
//  Copyright © 2018 Pavel Isaev. All rights reserved.
//

import Foundation

class Concentration {
    
    private(set) var cards = [Card]()
    private var indexOfFaceUpCard: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    var flipCount = 0
    var matchCount = 0

    func chooseCard(at index: Int) {
        if !cards[index].isMatched && !cards[index].isFaceUp {
            if let matchIndex = indexOfFaceUpCard, matchIndex != index {
                // check if cards match
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    matchCount += 2
                }
                cards[index].isFaceUp = true
            } else {
                indexOfFaceUpCard = index
            }
            flipCount += 1
        }
    }
    
    func isOver() -> Bool {
        return matchCount == cards.count
    }
    
    init(numberOfPairsOfCards: Int) {
        newGame(numberOfPairsOfCards: numberOfPairsOfCards)
    }
    func newGame(numberOfPairsOfCards: Int) {
        cards = []
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        cards.shuffle()
        flipCount = 0
        matchCount = 0
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
