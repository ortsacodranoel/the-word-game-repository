//
//  Game.swift
//  testing-animations
//
//  Created by Leo on 7/6/16.
//  Copyright © 2016 Daniel Castro. All rights reserved.
//

import Foundation
import UIKit
import StoreKit

class Game {
    
    static let sharedGameInstance = Game()
    
    // Used to determine if a team is still playing its turn.
    var roundInProgress = true
    // Used to determine if Team 1 is playing.
    var teamOneIsActive = true
    // Keeps the score of the first team.
    var teamOneScore = 0
    // Keeps the score of the second team.
    var teamTwoScore = 0
    // Keeps track of the words used.
    var arrayOfUsedWords = [String]()
    /// Variable to temporarily store a word.
    var word = String()
    /// Used to determine if a team has won the game.
    var won = false
    /// Used to temporarily store winner title.
    var winnerTitle = String()
    /// Categories array.
    var categoriesArray = [Category]()
    
    
    // MARK: - Free categories
    var jesus:Category!
    var people:Category!
    var places:Category!
    var sunday:Category!
    var concordance:Category!
    
    // MARK: - Paid categories
    var angels:Category!
    var books:Category!
    var commands:Category!
    var denominations:Category!
    var famous:Category!
    var feasts:Category!
    var relics:Category!
    var revelation:Category!
    var sins:Category!
    var worship:Category!
    
    
    init() {
        
        self.jesus = Category(title: "Jesus",summary: "His many names, adjectives to describe His character, and words associated with our Lord Jesus Christ.")
        self.people = Category(title: "People", summary: "Men and women of the Bible, from Genesis to Revelation and from the meek to the mighty.")
        self.places = Category(title: "Places", summary: "Countries, cities, lands, bodies of water, geological landmarks, and man-made structures of the Bible and bible times.")
        self.sunday = Category(title: "Sunday School", summary: "Stories from the Bible as well as Jesus’ parables.  *teams need not guess the exact answer, but must clearly guess the correct story or parable.")
        self.concordance = Category(title: "Concordance", summary:"Words found in the concordance of a Bible, excluding names and places.")
        
        let productAngel = IAPManager.sharedInstance.products.objectAtIndex(0) as! SKProduct
        let productBooks = IAPManager.sharedInstance.products.objectAtIndex(1) as! SKProduct
        let productCommands = IAPManager.sharedInstance.products.objectAtIndex(2) as! SKProduct
        let productDenominations = IAPManager.sharedInstance.products.objectAtIndex(3) as! SKProduct
        let productFamousChristians = IAPManager.sharedInstance.products.objectAtIndex(4) as! SKProduct
        let productFeasts = IAPManager.sharedInstance.products.objectAtIndex(5) as! SKProduct
        let productRelicsAndSaints = IAPManager.sharedInstance.products.objectAtIndex(6) as! SKProduct
        let productRevelation = IAPManager.sharedInstance.products.objectAtIndex(7) as! SKProduct
        let productSins = IAPManager.sharedInstance.products.objectAtIndex(8) as! SKProduct
        let productWorship = IAPManager.sharedInstance.products.objectAtIndex(9) as! SKProduct
        
        self.angels = Category(title:productAngel.localizedTitle,summary: productAngel.localizedDescription)
        self.books = Category(title:productBooks.localizedTitle,summary: productBooks.localizedDescription)
        self.commands = Category(title:productCommands.localizedTitle,summary: productCommands.localizedDescription)
        self.denominations = Category(title:productDenominations.localizedTitle,summary: productDenominations.localizedDescription)
        self.famous = Category(title:productFamousChristians.localizedTitle,summary: productFamousChristians.localizedDescription)
        self.feasts = Category(title:productFeasts.localizedTitle,summary: productFeasts.localizedDescription)
        self.relics = Category(title:productRelicsAndSaints.localizedTitle,summary: productRelicsAndSaints.localizedDescription)
        self.revelation = Category(title:productRevelation.localizedTitle,summary: productRevelation.localizedDescription)
        self.sins = Category(title:productSins.localizedTitle,summary: productSins.localizedDescription)
        self.worship = Category(title:productWorship.localizedTitle,summary: productWorship.localizedDescription)
        
        self.categoriesArray = [self.jesus,self.people,self.places,self.sunday,self.concordance,self.angels,self.books,self.commands,self.denominations,self.famous, self.feasts,self.relics,self.revelation,self.sins,self.worship]
    }
    
    
    func newGame() {
        self.teamOneScore = 0
        self.teamTwoScore = 0
        self.teamOneIsActive = true
        self.roundInProgress = true
    }
    
    
    /// Resets team scores back to 0.
    func resetGame() {
        self.teamOneScore = 0
        self.teamTwoScore = 0
    }
    
    /// Used to get the String value of the team that has won the game.
    func checkForWinner() {
        if self.teamOneScore == 5 {
            self.won = true
            self.winnerTitle = "Team One"
        } else if self.teamTwoScore == 5 {
            self.won = true
            self.winnerTitle = "Team Two"
        }
    }
    
    
    func getWord(categorySelected: Int) -> String {
        // Used to store a copy of the category array selected.
        var selectedArray = [String()]
        
        switch categorySelected {
        case 0:
            selectedArray = self.jesus.wordsInCategory
        case 1:
            selectedArray = self.people.wordsInCategory
        case 2:
            selectedArray = self.places.wordsInCategory
        case 3:
            selectedArray = self.sunday.wordsInCategory
        case 4:
            selectedArray = self.concordance.wordsInCategory
        case 5:
            selectedArray = self.famous.wordsInCategory
        case 6:
            selectedArray = self.worship.wordsInCategory
        case 7:
            selectedArray = self.books.wordsInCategory
        case 8:
            selectedArray = self.feasts.wordsInCategory
        case 9:
            selectedArray = self.relics.wordsInCategory
        case 10:
            selectedArray = self.revelation.wordsInCategory
        case 11:
            selectedArray = self.angels.wordsInCategory
        case 12:
            selectedArray = self.denominations.wordsInCategory
        case 13:
            selectedArray = self.sins.wordsInCategory
        case 14:
            selectedArray = self.commands.wordsInCategory
        default: break
        }
        
        // Generate a random number within the range of the count of items in the selected array.
        let randomIndex = Int(arc4random_uniform(UInt32(selectedArray.count)))
        
        // Set the word variable to a random word from the selected category array.
        word = selectedArray[randomIndex]
        
        if arrayOfUsedWords.contains(word) {
            // Run the method again.
            self.getWord(categorySelected)
        } else {
            self.arrayOfUsedWords.append(word)
        }
        return word
    }
    
    /// Updates each team's turn.
    func updateTeamTurn() {
        if self.teamOneIsActive {
            self.teamOneIsActive = false
        } else {
            teamOneIsActive = true
        }
    }
    
    
    // Returns the current score for Team One.
    func getTeamOneScore() -> Int {
        return teamOneScore
    }
    
    
    // Returns the current score for Team Two.
    func getTeamTwoScore() -> Int {
        return teamTwoScore
    }
    
}