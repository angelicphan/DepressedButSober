//
//  CardViewController.swift
//  DepressedButSober
//
//  Created by Angelic Phan on 8/4/20.
//  Copyright © 2020 Angelic Phan. All rights reserved.
//
//  This is the game screen that represents a game card. The user can
//  swipe left or right to iterate through the deck of cards.

import UIKit

class CardViewController: UIViewController {
    
    // ****************************************************************
    // MARK: Properties
    // ****************************************************************
    
    // The cards and currentCard values are passed by `HomeViewController` in `prepare(for:sender:)`
    var cards = [Card]()
    var currentCard = 0
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var promptText: UITextView!
    @IBOutlet weak var sipsText: UILabel!
    
    // ****************************************************************
    // MARK: View Lifecycle
    // ****************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Will hide/show navigation bar when user taps the screen
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.hidesBarsOnTap = true
        
        // Display Current Card
        connectCardDataToDisplayCard(card: cards[currentCard])
        
        // Set title to be an indicator of how far the user is in the deck
        self.title = "\(currentCard + 1)/\(cards.count)"
        
        // Save progress whenever user terminates or moves app to background
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(saveCards), name: UIApplication.willResignActiveNotification, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Show tutorial if this is the first game
        let userDefaults = UserDefaults.standard
        if(userDefaults.bool(forKey: "gameExists")) {
            // Not first game, don't show tutorials
        } else {
            // First game, change flag value and show tutorials
            userDefaults.set(true, forKey: "gameExists")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Popup about how to change cards with swipe only once
        if !UserDefaults.standard.bool(forKey: "swipeAlertAlreadyShown") {
            // Update variable
            UserDefaults.standard.set(true, forKey: "swipeAlertAlreadyShown")
            // Show alert
            let alert = UIAlertController(title: "How to Play", message: "Take the sips below if you can't relate to the prompt, and swipe left or right to change cards. More details in the navbar.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Save the current card state whenever the view is out of focus
        saveCards()
    }
    
    // ****************************************************************
    // MARK: Actions
    // ****************************************************************
    
    // This function will listen for a left swipe and change the card state
    // to be progressing through the deck by one if there are cards left.
    // Otherwise it will alert the user when they are at the last card.
    @IBAction func leftSwipe(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            // Go to next card in array
            if sender.direction == .left {
                if currentCard == cards.count - 1 {
                    // We are at the last card, cannot swipe to next card anymore
                    let alert = UIAlertController(title: "End of Deck", message: "You are currently at the last card.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    currentCard += 1
                    connectCardDataToDisplayCard(card: cards[currentCard])
                    // Set title to be an indicator of how far the user is in the deck
                    self.title = "\(currentCard + 1)/\(cards.count)"
                }
            }
        }
    }
    
    // This function will listen for a right swipe and change the card
    // state to be regressing through the deck by one if there were any
    // previous cards left. Otherwise it will alert the user when they
    // are at the first card.
    @IBAction func rightSwipe(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            // Go back to previous card in array
            if sender.direction == .right {
                if currentCard == 0 {
                    // We are at the first card, cannot swipe to previous card anymore
                    let alert = UIAlertController(title: "Start of Deck", message: "You are currently at the first card.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    currentCard -= 1
                    connectCardDataToDisplayCard(card: cards[currentCard])
                    // Set title to be an indicator of how far the user is in the deck
                    self.title = "\(currentCard + 1)/\(cards.count)"
                }
            }
        }
    }
    
    // ****************************************************************
    // MARK: Private Methods
    // ****************************************************************
    
    // This function will connect the card data that should be displayed
    // of the current card to the objects on the card display screen
    private func connectCardDataToDisplayCard(card: Card) {
        typeLabel.text = card.type
        promptText.text = card.prompt
        switch card.sips {
        case 0:
            sipsText.text = "Take ___ sips!"
        case 1:
            sipsText.text = "Take \(card.sips) sip!"
        default:
            sipsText.text = "Take \(card.sips) sips!"
        }
    }

    // This function will save the current game cards state to the
    // persistent data storage so that the user can resume the game
    // if they left it
    @objc private func saveCards() {
        // Save Cards to Persistent Data
        do {
            let myCards = try NSKeyedArchiver.archivedData(withRootObject: cards, requiringSecureCoding: true)
            try myCards.write(to: Card.ArchiveCardsURL)
        } catch {
            print("Couldn't save cards to persistent data file.")
        }
        
        // Save Current Card index to Persistent Data
        do {
            let myCurrentCard = try NSKeyedArchiver.archivedData(withRootObject: currentCard, requiringSecureCoding: true)
            try myCurrentCard.write(to: Card.ArchiveCurrentCardURL)
        } catch {
            print("Couldn't save current card index to persistent data file.")
        }
    }
    
}
