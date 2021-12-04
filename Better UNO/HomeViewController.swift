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
    let miscCards = Deck().defaultDeck["MiscCards"]!
    var hands = [[String]]()
    // **** this version currently supports 2 players ****
    var currentPlayer = 1 // either 1 or 2
    var currentCardOnPile = String()
    var pickedCard = String()

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
            if !miscCards.contains(card) {
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
        let toMatchTo = String(Array(currentCardOnPile)[0])
        let pickedIndex = Int(pickedCard)! - 1
        var isSpecialCard = false
        let t = String(Array(hands[currentPlayer-1][pickedIndex])[0])
        
        if miscCards.contains(hands[currentPlayer-1][pickedIndex]) {
            isSpecialCard = true
            print("special card")
            return
        }
        print("test")
        if t == toMatchTo && !isSpecialCard {
            // not special card but can be played
            print("playbale card")
        } else {
            // not a playable card
            print("not playable")
        }
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
    
    @IBAction private func pickCardToPutDownAlert() {
        var textField = UITextField()
        let alert = UIAlertController(title: "Pick Card to Play", message: "type index number of the card you wish to play.", preferredStyle: .alert)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Enter number"
            alertTextField.textAlignment = .center
            alertTextField.keyboardType = .numberPad
            textField = alertTextField
        }
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { action in
            
            self.pickedCard = textField.text!
            let maxAllowedNum = self.hands[self.currentPlayer-1].count
            
            if Int(self.pickedCard)! < 1 || Int(self.pickedCard)! > maxAllowedNum {
                let alert = UIAlertController(title: "Error", message: "Please enter a valid number.", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .cancel) { action in
                    self.pickCardToPutDownAlert()
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            } else {
                self.playerPlaysCard()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
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
