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
    // Used to verify the game has begun.
    var gameBegan = false
    
    
    
    /// Used to determine the color of the game being played. 
    var gameColor:UIColor!
    
    
    // Used to notify GameVC if segue comes from DetailVC.
    var segueFromDetailVC:Bool!
    
    
    // MARK: - Array properties
    
    /// Categories array.
    var categoriesArray = [Category]()
    /// Used to store missed words.
    var missedWordsArray = [String]()
    /// Used to store correct words.
    var correctWordsArray = [String]()
    
    
    // MARK: - Colors for screens and categories.
    let colors = [
        UIColor(red: 91/255, green: 123/255, blue: 200/225, alpha: 1),  // Row 1
        UIColor(red: 196/255, green: 93/255, blue: 79/225, alpha: 1),   // Row 2
        UIColor(red: 196/255, green: 185/255, blue: 79/225, alpha: 1),  // Row 3
        UIColor(red: 212/255, green: 152/255, blue: 125/225, alpha: 1), // Row 4
        UIColor(red: 214/255, green: 133/255, blue: 157/225, alpha: 1), // Row 5
        UIColor(red: 150/255, green: 144/255, blue: 218/225, alpha: 1), // Row 6
        UIColor(red: 179/255, green: 193/255, blue: 230/225, alpha: 1), // Row 7
        UIColor(red: 228/255, green: 209/255, blue: 175/225, alpha: 1), // Row 8
        UIColor(red: 221/255, green: 152/255, blue: 182/225, alpha: 1), // Row 9
        UIColor(red: 133/255, green: 184/255, blue: 214/225, alpha: 1), // Row 10
        UIColor(red: 187/255, green: 94/255, blue: 62/225, alpha: 1),   // Row 11
        UIColor(red: 212/255, green: 186/255, blue: 232/225, alpha: 1), // Row 12
        UIColor(red: 201/255, green: 209/255, blue: 117/225, alpha: 1), // Row 13
        UIColor(red: 152/255, green: 221/255, blue: 217/225, alpha: 1), // Row 14
        UIColor(red: 193/255, green: 68/255, blue: 93/225, alpha: 1),   // Row 15
        UIColor(red: 190/255, green: 68/255, blue: 93/225, alpha: 1),   // Row 16
        UIColor(red: 196/255, green: 54/255, blue: 93/225, alpha: 1)    // Row 17
    ]
    
    
    
    
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
    var christiannation:Category!
    var christmastime:Category!
    var denominations:Category!
    var famous:Category!
    var feasts:Category!
    var relics:Category!
    var revelation:Category!
    var sins:Category!
    var worship:Category!
    
    init() {
        
        self.jesus = Category(title: "Jesus",summary: "His many names, adjectives to describe His character, and words associated with our Lord Jesus Christ.")
        self.jesus.purchased = true
        
        self.people = Category(title: "People", summary: "Men and women of the Bible, from Genesis to Revelation and from the meek to the mighty.")
        self.people.purchased = true
        
        self.places = Category(title: "Places", summary: "Countries, cities, lands, bodies of water, geological landmarks, and man-made structures of the Bible and bible times.")
        self.places.purchased = true
        
        self.sunday = Category(title: "Sunday School", summary: "Stories from the Bible as well as Jesus’ parables.  *teams need not guess the exact answer, but must clearly guess the correct story or parable.")
        self.sunday.purchased = true
        
        self.concordance = Category(title: "Concordance", summary:"Words found in the concordance of a Bible, excluding names and places.")
        self.concordance.purchased = true
        
        // Angels
        self.angels = Category(title:"Angels",summary:"The names of the Angels from the Bible and from Christian-Judeo mythology.")
        
        if UserDefaults.standard.bool(forKey: "com.thewordgame.angels") {
            self.angels.purchased = true
        } else {
            self.angels.purchased = false
        }
        
        
        // Books
        self.books = Category(title:"Books and Movies",summary: "Christian and Christian-friendly books and movies, as well as the books of the Bible.")
        
        if UserDefaults.standard.bool(forKey: "com.thewordgame.books") {
            self.books.purchased = true
        } else {
            self.books.purchased = false
        }
            

        // Christian Nation
        self.christiannation = Category(title:"Christian Nation",summary: "Early American colonies, the American Revolution, US Government, major Founding Fathers, all US President, and all US States.")
        if UserDefaults.standard.bool(forKey: "com.thewordgame.christiannation") {
            self.christiannation.purchased = true
        } else {
            self.christiannation.purchased = false
        }
        
        
        // Christmas Time
        self.christmastime = Category(title:"Christmas Time",summary:"Titles of songs and carols, food, characters, and other words associated with celebrating the Birth of Jesus Christ.")
        if UserDefaults.standard.bool(forKey: "com.thewordgame.christmastime") {
            self.christmastime.purchased = true
        } else {
            self.christmastime.purchased = false
        }
        
        
        // Commands
        self.commands = Category(title:"Commands",summary: "Words of Biblical mandates  * answers with more than one word need not be guessed exactly, but must contain the main words.")
        if UserDefaults.standard.bool(forKey: "com.thewordgame.commands") {
            self.commands.purchased = true
        } else {
            self.commands.purchased = false
        }

        
        // Denominations
        self.denominations = Category(title:"Denominations",summary: "Christian denominations, beliefs and practices within different denominations, words associated with different denominations.")
            if UserDefaults.standard.bool(forKey: "com.thewordgame.denominations") {
                self.denominations.purchased = true
            } else {
                self.denominations.purchased = false
            }
        
        
        // Famous
        self.famous = Category(title:"Famous Christians",summary: "Historical and influential Christians, TV evangelists, and Celebrities who have claimed Faith in Christ.")
            if UserDefaults.standard.bool(forKey: "com.thewordgame.famouschristians") {
                self.famous.purchased = true
            } else {
                self.famous.purchased = false
            }
        
        
        // Feasts
        self.feasts = Category(title:"Feasts",summary: "Biblical and/or Jewish feasts, Christian holidays, as well as food and drink mentioned in the Bible.")
            if UserDefaults.standard.bool(forKey: "com.thewordgame.feasts") {
                self.feasts.purchased = true
            } else {
                self.feasts.purchased = false
            }
        
        
        // Relics
        self.relics = Category(title:"Relics and Saints",summary: "Religious artifacts throughout history and the names of Catholic Saints.")
            if UserDefaults.standard.bool(forKey: "com.thewordgame.relicsandsaints") {
                self.relics.purchased = true
            } else {
                self.relics.purchased = false
            }
        
        // Revelation
        self.revelation = Category(title:"Revelation",summary:"Words and phrases of the prophetic last book of the Bible.")
            if UserDefaults.standard.bool(forKey: "com.thewordgame.revelation") {
                self.revelation.purchased = true
            } else {
                self.revelation.purchased = false
            }
        // Sins
        self.sins = Category(title:"Sins",summary: "Transgressions described by the Bible and/or the Church.  * answers with more than one word need not be guessed exactly, but must contain the main words.")
            if UserDefaults.standard.bool(forKey: "com.thewordgame.sins") {
                self.sins.purchased = true
            } else {
                self.sins.purchased = false
            }
        // Worship
        self.worship = Category(title:"Worship",summary: "Hymns, words and songs of worship, Christian bands/singers, Biblical instruments.  * “song titles” need not be guessed exactly, but must contain the main words.")
            if UserDefaults.standard.bool(forKey: "com.thewordgame.worship") {
                self.worship.purchased = true
            } else {
                self.worship.purchased = false
            }
        
        
        
        self.categoriesArray = [self.jesus,
                                self.people,
                                self.places,
                                self.sunday,
                                self.concordance,
                                self.angels,
                                self.books,
                                self.christiannation,
                                self.christmastime,
                                self.commands,
                                self.denominations,
                                self.famous,
                                self.feasts,
                                self.relics,
                                self.revelation,
                                self.sins,
                                self.worship]

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
    
    
    func getWord(_ categorySelected: Int) -> String {
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
            selectedArray = self.angels.wordsInCategory
        case 6:
            selectedArray = self.books.wordsInCategory
        case 7:
            selectedArray = self.christiannation.wordsInCategory
        case 8:
            selectedArray = self.christmastime.wordsInCategory
        case 9:
            selectedArray = self.commands.wordsInCategory
        case 10:
            selectedArray = self.denominations.wordsInCategory
        case 11:
            selectedArray = self.famous.wordsInCategory
        case 12:
            selectedArray = self.feasts.wordsInCategory
        case 13:
            selectedArray = self.relics.wordsInCategory
        case 14:
            selectedArray = self.revelation.wordsInCategory
        case 15:
            selectedArray = self.sins.wordsInCategory
        case 16:
            selectedArray = self.worship.wordsInCategory
        default:
            break
        }
        
        // Generate a random number within the range of the count of items in the selected array.
        let randomIndex = Int(arc4random_uniform(UInt32(selectedArray.count)))
        
        // Set the word variable to a random word from the selected category array.
        word = selectedArray[randomIndex]
        
        if arrayOfUsedWords.contains(word) {
            // Run the method again.
           // self.getWord(categorySelected)
            
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
    
    func getCategoryForProductKey(_ productIdentifier: String) -> Category {
        
        switch productIdentifier{
        case "com.thewordgame.angels":
            return self.categoriesArray[5]
        case "com.thewordgame.books":
            return self.categoriesArray[6]
        case "com.thewordgame.christiannation":
            return self.categoriesArray[7]
        case "com.thewordgame.christmastime":
            return self.categoriesArray[8]
        case "com.thewordgame.commands":
            return self.categoriesArray[9]
        case "com.thewordgame.denominations":
            return self.categoriesArray[10]
        case "com.thewordgame.famouschristians":
            return self.categoriesArray[11]
        case "com.thewordgame.feasts":
            return self.categoriesArray[12]
        case "com.thewordgame.relicsandsaints":
            return self.categoriesArray[13]
        case "com.thewordgame.revelation":
            return self.categoriesArray[14]
        case "com.thewordgame.sins":
            return self.categoriesArray[15]
        case "com.thewordgame.worship":
            return self.categoriesArray[16]
        default:
            break
        }
        
        let temp = Category(title: "No category exists",summary: "No summary exists for this category")
        
        return temp
    }
    
    // MARK: - Array Methods
    
    /// Clears all information in correct/missedWordsArray.
    func clearArrays() {
        self.correctWordsArray = []
        self.missedWordsArray = []
    }
    
    /// Prints the data in correct/missedWordsArray.
    func printCorrectMissedArray() {
      
        print("Missed words:")
        for word in missedWordsArray {
            print("   " + word)
        }
        
        print("\n" + "Words guessed:")
        for word in correctWordsArray {
            print("   " + word)
        }
    
    }
    
}
