//
//  MatchingGame.swift
//  ShopifyMemoryMatchGame
//
//  Created by Dhruv Mathur on 2019-09-16.
//  Copyright © 2019 Dhruv Mathur. All rights reserved.
//

import Foundation

struct MatchingGame {
    private(set) var cards = [Card]()
    private(set) var score = 0
    private(set) var flipCount = 0
    
    private var indexOfOneAndOnlyFaceUp: Int? {
        get {
            return cards.indices.filter({cards[$0].isFaceUp}).oneAndOnly
        }
        
        set {
            for flipDownIndex in cards.indices {
                cards[flipDownIndex].isFaceUp = (flipDownIndex == newValue)
            }
        }
    }
    
    private var selectedIndex = Set<Int>()
    private var lastIndexWasSelected = false
    var allCardsHaveBeenMatched: Bool {
        for index in cards.indices {
            if !cards[index].isMatched { return false }
        }
        return true
    }
    
    mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "MatchingGame.chooseCard(at:\(index)): index is not in the cards")
        let cardWasPreviouslySelected = selectedIndex.contains(index)
        if !cards[index].isMatched {
            flipCount += 1
            if let matchIndex = indexOfOneAndOnlyFaceUp, matchIndex != index {
                if cards[index] == cards[matchIndex] {
                    cards[index].isMatched = true
                    cards[matchIndex].isMatched = true
                    if lastIndexWasSelected {
                        score += 1
                    } else {
                        score += 1
                    }
                }
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUp = index
                lastIndexWasSelected = cardWasPreviouslySelected
            }
        }
        
        selectedIndex.insert(index)
    }
    
    init(numberOfPairsOfCards: Int){
        assert(numberOfPairsOfCards > 0, "MatchingGame.init(numberOfPairsOfCards:\(numberOfPairsOfCards) you must have multiple pairs of cards")
        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        shuffleCards()
    }
    
    mutating private func shuffleCards() {
        for _ in 0..<cards.count {
            cards.sort(by: {_,_ in arc4random() > arc4random()})
        }
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
