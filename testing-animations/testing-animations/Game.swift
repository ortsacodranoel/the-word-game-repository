//
//  Game.swift
//  testing-animations
//
//  Created by Leo on 7/6/16.
//  Copyright © 2016 Daniel Castro. All rights reserved.
//

import Foundation
import UIKit

class Game {
    
    // Used to determine if a team is still playing its turn.
    var roundInProgress : Bool
    // Used to determine if Team 1 is playing.
    var teamOneIsActive = false
    // Keeps the score of the first team.
    var teamOneScore : Int
    // Keeps the score of the second team.
    var teamTwoScore : Int
    // Keeps track of the words used.
    var arrayOfUsedWords = [String]()
    /// Variable to temporarily store a word.
    var word = String()
    /// Used to determine if a team has won the game.
    var won = false
    /// Used to temporarily store winner title.
    var winnerTitle = String()
    
    // MARK: - Categories
    var jesus = Category()
    var people = Category()
    var places = Category()
    var sunday = Category()
    var concordance = Category()
    var famous = Category()
    var worship = Category()
    var books = Category()
    var feasts = Category()
    var relics = Category()
    var revelation = Category()
    var angels = Category()
    var doctrine = Category()
    var sins = Category()
    var commands = Category()
    

    init() {
        
        self.teamOneScore = 0
        self.teamTwoScore = 0
        self.roundInProgress = true
        self.teamOneIsActive = true
        self.roundInProgress = true
        
        self.jesus.loadContent("Jesus")
        self.people.loadContent("People")
        self.places.loadContent("Places")
        self.sunday.loadContent("Sunday")
        self.concordance.loadContent("Concordance")
        self.famous.loadContent("Famous")
        self.worship.loadContent("Worship")
        self.books.loadContent("Books")
        self.feasts.loadContent("Feasts")
        self.relics.loadContent("Relics")
        self.revelation.loadContent("Revelation")
        self.angels.loadContent("Angels")
        self.doctrine.loadContent("Doctrine")
        self.sins.loadContent("Sins")
        self.commands.loadContent("Commands")
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
    
    
    /**
     
        Generates a random word from the desired word category. 
     
        - Parameter str: The string to repeat.

     
        - Returns: A random word from the selected category.
     
     **/
    func getWord(categorySelected: Int) -> String {
    
        // Used to store a copy of the category array selected.
        var selectedArray = [String()]
        
        switch categorySelected {
        case 0:
            selectedArray = self.jesus.words
        case 1:
            selectedArray = self.people.words
        case 2:
            selectedArray = self.places.words
        case 3:
            selectedArray = self.sunday.words
        case 4:
            selectedArray = self.concordance.words
        case 5:
            selectedArray = self.famous.words
        case 6:
            selectedArray = self.worship.words
        case 7:
            selectedArray = self.books.words
        case 8:
            selectedArray = self.feasts.words
        case 9:
            selectedArray = self.relics.words
        case 10:
            selectedArray = self.revelation.words
        case 11:
            selectedArray = self.angels.words
        case 12:
            selectedArray = self.doctrine.words
        case 13:
            selectedArray = self.sins.words
        case 14:
            selectedArray = self.commands.words
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