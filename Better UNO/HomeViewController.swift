//
//  ViewController.swift
//  Better UNO
//
//  Created by Jesse Brior on 11/28/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet var handOneLbl: UILabel!
    @IBOutlet var handTwoLbl: UILabel!
    @IBOutlet var playerOneLbl: UILabel!
    @IBOutlet var playerTwoLbl: UILabel!
    @IBOutlet var topPileCard: UILabel!
    
    var deck = Array(Deck().defaultDeck.values)
    let badStartingCards = Deck().badStartingCards
    var hands = [[String]]()
    // this version currently supports 2 players
    var currentPlayer = 1 // either 1 or 2
    var currentCardOnPile = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        giveOutStartingHands()
        updatePlayerHands()
        
        topPileCard.text = currentCardOnPile
        
        handTwoLbl.isHidden = true
        playerTwoLbl.isHidden = true
    }

// MARK: START OF GAME FUNCTIONS
    private func giveOutStartingHands() {
        var tempH1: [String] = []
        var tempH2: [String] = []
        for i in 0..<2 {
            for _ in 0..<7 {
                if i == 0 {
                    tempH1.append(getCardFromDeck())
                } else if i == 1 {
                    tempH2.append(getCardFromDeck())
                }
            }
        }
        hands.append(tempH1)
        hands.append(tempH2)
        
        setHandLabels()
        setStartingCard()
    }
    
    private func setStartingCard() {
        var card = ""
        while true {
            let r1 = Int.random(in: 0..<deck.count)
            let r2 = Int.random(in: 0..<deck[r1].count)
            card = deck[r1][r2]
            if !badStartingCards.contains(card) {
                currentCardOnPile = card
                removeCardFromDeck(r1, r2)
                break
            }
        }
    }
    
    private func removeCardFromDeck(_ x: Int, _ y: Int) {
        deck[x].remove(at: y)
    }
    
    private func getCardFromDeck() -> String {
        let r1 = Int.random(in: 0..<deck.count)
        let r2 = Int.random(in: 0..<deck[r1].count)
        let card = deck[r1][r2]
        removeCardFromDeck(r1, r2)
        print(countCardsInDeck())
        return card
    }
    
    @IBAction private func playerDrawsCard() {
        let card = getCardFromDeck()
        if currentPlayer == 1 {
            hands[0].append(card)
        } else {
            hands[1].append(card)
        }
        updatePlayerHands()
        switchTurns()
    }
    
    private func playerPlaysCard() {
        // update current card on top of pile
    }
    
    private func updatePlayerHands() {
        playerOneLbl.text! = "Player One - \(hands[0].count) cards left"
        playerTwoLbl.text! = "Player Two - \(hands[1].count) cards left"
    }
    
    private func switchTurns() {
        if currentPlayer == 1 {
            currentPlayer = 2
            playerOneLbl.isHidden = true
            handOneLbl.isHidden = true
            playerTwoLbl.isHidden = false
            handTwoLbl.isHidden = false
        } else {
            currentPlayer = 1
            playerOneLbl.isHidden = false
            handOneLbl.isHidden = false
            playerTwoLbl.isHidden = true
            handTwoLbl.isHidden = true
        }
        setHandLabels()
    }
    
    private func setHandLabels() {
        handOneLbl.text = ""
        handTwoLbl.text = ""
        var text = ""
        for i in 0..<hands[0].count {
            text += "\(hands[0][i]) : "
        }
        handOneLbl.text = String(text.dropLast(3))
        text = ""
        for i in 0..<hands[1].count {
            text += "\(hands[1][i]) : "
        }
        handTwoLbl.text = String(text.dropLast(3))
    }
    
// MARK: *****FOR TESTING*****
    // Count number of cards currently in deck
    /*
    private func countCardsInDeck() -> Int {
        // At start should = 112
        var index = 0
        for i in deck {
            for _ in i {
                index += 1
            }
        }
        return index
    }
    */
}
