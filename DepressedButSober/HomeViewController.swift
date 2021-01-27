//
//  HomeViewController.swift
//  DepressedButSober
//
//  Created by Angelic Phan on 7/27/20.
//  Copyright © 2020 Angelic Phan. All rights reserved.
//
//  This is the home screen of the app that allows users to either
//  start a new game, resume an old game, or get more information
//  about the game.

import UIKit

class HomeViewController: UIViewController {
    
    // ****************************************************************
    // MARK: Properties
    // ****************************************************************
    
    var currentCard : Int = 0
    @IBOutlet weak var resumeButton: UIButton!
    
    // ****************************************************************
    // MARK: View Lifecycle
    // ****************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Will hide the navigation bar for home screen
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Check if there is an existing game, and if so, show the RESUME option
        let userDefaults = UserDefaults.standard
        if(userDefaults.bool(forKey: "gameExists")) {
            resumeButton.isHidden = false
        } else {
            resumeButton.isHidden = true
        }
        
    }
    
    // ****************************************************************
    // MARK: Navigation
    // ****************************************************************

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Check which segue was chosen
        switch(segue.identifier ?? "") {
        case "NewGame":
            // Get destination View Controller
            guard let cardViewController = segue.destination as? CardViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
           
            // Load and scramble card data from JSON file
            if let newCards = loadCardsFromJson(){
                cardViewController.cards = newCards.shuffled()
                cardViewController.currentCard = 0
            } else {
                cardViewController.cards = loadErrorCard()
                cardViewController.currentCard = 0
            }
            
        case "Resume":
            // Get destination View Controller
            guard let cardViewController = segue.destination as? CardViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            // Load card data from persistent data storage if any, otherwise, load from JSON
            if let oldCards = loadCardsFromStorage() {
                cardViewController.cards = oldCards
                cardViewController.currentCard = currentCard
            } else if let newCards = loadCardsFromJson(){
                cardViewController.cards = newCards.shuffled()
                cardViewController.currentCard = 0
            } else {
                cardViewController.cards = loadErrorCard()
                cardViewController.currentCard = 0
            }
            
        case "About":
            // Get destination View Controller
            guard segue.destination is AboutViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
        default:
            fatalError("Unexpected Segue Identifier: \(String(describing: segue.identifier))")
        }
    }
    
    // ****************************************************************
    // MARK: Private Methods
    // ****************************************************************
    
    // This function will load an error card into the card array. It is
    // called whenever the app is unable to load the cards from the JSON
    // file or persistent data storage. The error card lets users know
    // there was a problem getting the game cards.
    private func loadErrorCard() -> [Card] {
        guard let errorCard = Card(type: "ERROR", prompt: "There was a problem loading the cards.", sips: 0) else {
            fatalError("Unable to instantiate errorCard")
        }
        return [errorCard]
    }
    
    // This function will load the game card data from the JSON file
    private func loadCardsFromJson() -> [Card]? {
        // Get data from JSON and shuffle
        // fileLocation is the json file with the card data
        if let fileLocation = Bundle.main.url(forResource: "cardData", withExtension: "json") {
            do {
                // Get data from json file
                let data = try Data(contentsOf: fileLocation)
                let jsonDecoder = JSONDecoder()
                let dataFromJson = try jsonDecoder.decode([Card].self, from: data)
                return dataFromJson
            } catch {
                print(error)
            }
        }
        return nil
    }
    
    // This function will load the game card data from persistent data
    // storage
    private func loadCardsFromStorage() -> [Card]? {
        
        // Get cards data from persistent data storage
        guard let codedCards = try? Data(contentsOf: Card.ArchiveCardsURL) else {
            return  nil
        }
        let allCards = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(codedCards)
        
        // Get current card index from persistent data storage
        guard let codedCardIndex = try? Data(contentsOf: Card.ArchiveCurrentCardURL) else {
            return  nil
        }
        let currentCardIndex = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(codedCardIndex)
        currentCard = currentCardIndex as! Int
        
        return (allCards as! [Card])
    }
    

}

