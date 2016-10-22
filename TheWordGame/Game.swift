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
    
    // Tutorial
    
    // Used to determine if a pop tutorial is shown.
    var showPopUp = false
    
    
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
        UIColor(red: 43/255, green: 100/255, blue: 130/225, alpha: 1),          // Jesus
        UIColor(red: 207/255, green: 127/255, blue: 110/225, alpha: 1),         // People
        UIColor(red: 204/255, green: 188/255, blue: 113/225, alpha: 1),         // Places
        UIColor(red: 209/255, green: 128/255, blue: 172/225, alpha: 1),         // Sunday School
        UIColor(red: 46/255, green: 127/255, blue: 133/225, alpha: 1),          // Concordance
        UIColor(red: 179/255, green: 67/255, blue: 61/225, alpha: 1),           // Angels
        UIColor(red: 202/255, green: 154/255, blue: 53/225, alpha: 1),          // Books and Movies
        UIColor(red: 193/255, green: 204/255, blue: 107/225, alpha: 1),         // Christian Nation
        UIColor(red: 171/255, green: 59/255, blue: 62/225, alpha: 1),          // Christmas Time
        UIColor(red: 42/255, green: 83/255, blue: 122/225, alpha: 1),           // Commands
        UIColor(red: 198/255, green: 139/255, blue: 88/225, alpha: 1),          // Denomations
        UIColor(red: 53/255, green: 151/255, blue: 156/225, alpha: 1),          // Easter
        UIColor(red: 202/255, green: 195/255, blue: 99/225, alpha: 1),          // Famous Christians
        UIColor(red: 163/255, green: 56/255, blue: 145/225, alpha: 1),           // Feasts
        UIColor(red: 123/255, green: 53/255, blue: 156/225, alpha: 1),           // History
        UIColor(red: 75/255, green: 101/255, blue: 195/225, alpha: 1),           // Kids
        UIColor(red: 56/255, green: 159/255, blue: 168/225, alpha: 1),           // Relics and Saints
        UIColor(red: 24/255, green: 59/255, blue: 73/225, alpha: 1),             // Revelation
        UIColor(red: 157/255, green: 85/255, blue: 52/225, alpha: 1),           // Sins
        UIColor(red: 153/255, green: 56/255, blue: 138/225, alpha: 1),           // Worship
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
    var christiannation:Category!
    var christmastime:Category!

    var commands:Category!
    var denominations:Category!
    var easter:Category!
    var famous:Category!
    var feasts:Category!
    var history:Category!
    var kids:Category!
    var relics:Category!
    var revelation:Category!
    var sins:Category!
    var worship:Category!
    
    init() {
        // Jesus category.
        self.jesus = Category(title: "Jesus",summary: "His many names, adjectives to describe His character, and words associated with our Lord Jesus Christ.")
        self.jesus.purchased = true
       
        // People category.
        self.people = Category(title: "People", summary: "Men and women of the Bible, from Genesis to Revelation and from the meek to the mighty.")
        self.people.purchased = true
      
        // Places category.
        self.places = Category(title: "Places", summary: "Stories from the Bible as well as Jesus’ parables.  * answers do not have to be exact, but must contain the main words.")
        self.places.purchased = true
      
        // Sunday School category.
        self.sunday = Category(title: "Sunday School", summary: "Stories from the Bible as well as Jesus’ parables.  * answers do not have to be exact, but must contain the main words.")
        self.sunday.purchased = true
       
        // Concordance category.
        self.concordance = Category(title: "Concordance", summary:"Words found in the concordance of a Bible, excluding names and places.")
        self.concordance.purchased = true
        
        // Angels category.
        self.angels = Category(title:"Angels",summary:"The names of the Angels from the Bible and from Christian-Judeo mythology.")
        if UserDefaults.standard.bool(forKey: "com.thewordgame.angels") {
            self.angels.purchased = true
        } else {
            self.angels.purchased = false
        }
        
        // Books and Movies category.
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
        self.commands = Category(title:"Commands",summary: "Words of Biblical mandates  * answers with more than one word do not have to be exact, but must contain the main words.")
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
        
        // Easter
        self.easter = Category(title:"Easter",summary: "All words related to the holiday in which we celebrate the Resurrection of Jesus Christ, including the days leading up to it.")
        if UserDefaults.standard.bool(forKey: "com.thewordgame.easter") {
            self.easter.purchased = true
        } else {
            self.easter.purchased = false
        }
        
        
        // Famous Christians
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
 
        // History
        self.history = Category(title:"History",summary: "The movements, councils, people, wars, translations, churches, schools and more that shaped Christianity.")
        if UserDefaults.standard.bool(forKey: "com.thewordgame.history") {
            self.history.purchased = true
        } else {
            self.history.purchased = false
        }

        // Kids
        self.kids = Category(title:"Kids",summary: "Easier words from Sunday School and the Bible, including people, places, food, and animals. Answers in quotation marks are song titles.")
        if UserDefaults.standard.bool(forKey: "com.thewordgame.kids") {
            self.kids.purchased = true
        } else {
            self.kids.purchased = false
        }
  
        // Relics and Saints
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
        self.sins = Category(title:"Sins",summary: "Transgressions described by the Bible and/or the Church.  * answers with more than one word do not have to be exact, but must contain the main words.")
            if UserDefaults.standard.bool(forKey: "com.thewordgame.sins") {
                self.sins.purchased = true
            } else {
                self.sins.purchased = false
            }
        
        // Worship
        self.worship = Category(title:"Worship",summary: "Hymns, words and songs of worship, Christian bands/singers, Biblical instruments.  * “song titles” do not have to be exact, but must contain the main words.")
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
                                self.easter,
                                self.famous,
                                self.feasts,
                                self.history,
                                self.kids,
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
        if self.teamOneScore == 10 {
            self.won = true
            self.winnerTitle = "Team One Wins!"
        } else if self.teamTwoScore == 10 {
            self.won = true
            self.winnerTitle = "Team Two Wins!"
        }
    }
    
    
    func getWord(_ categorySelected: Int) -> String {
        // Used to store a copy of the category array selected.
        var selectedArray = [String()]
        
        switch categorySelected {
        case 0:
            // Jesus
            selectedArray = self.jesus.wordsInCategory
        case 1:
            // People
            selectedArray = self.people.wordsInCategory
        case 2:
            // Places
            selectedArray = self.places.wordsInCategory
        case 3:
            // Sunday
            selectedArray = self.sunday.wordsInCategory
        case 4:
            // Concordance
            selectedArray = self.concordance.wordsInCategory
        case 5:
            // Angels
            selectedArray = self.angels.wordsInCategory
        case 6:
            // Books and Movies
            selectedArray = self.books.wordsInCategory
        case 7:
            // Christian Nation
            selectedArray = self.christiannation.wordsInCategory
        case 8:
            // Christmas Time
            selectedArray = self.christmastime.wordsInCategory
        case 9:
            // Commands
            selectedArray = self.commands.wordsInCategory
        case 10:
            // Denominations
            selectedArray = self.denominations.wordsInCategory
        case 11:
            // Easter
            selectedArray = self.easter.wordsInCategory
        case 12:
            // Famous Christians
            selectedArray = self.famous.wordsInCategory
        case 13:
            // Feasts
            selectedArray = self.feasts.wordsInCategory
        case 14:
            // History
            selectedArray = self.history.wordsInCategory
        case 15:
            // Kids
            selectedArray = self.kids.wordsInCategory
        case 16:
            // Relics
            selectedArray = self.relics.wordsInCategory
        case 17:
            // Revelation
            selectedArray = self.revelation.wordsInCategory
        case 19:
            // Sins
            selectedArray = self.sins.wordsInCategory
        case 20:
            // Worship
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
            let temp = self.getWord(categorySelected)
            print(temp)
            
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
        case "com.thewordgame.easter":
            return self.categoriesArray[11]
        case "com.thewordgame.famouschristians":
            return self.categoriesArray[12]
        case "com.thewordgame.feasts":
            return self.categoriesArray[13]
        case "com.thewordgame.history":
            return self.categoriesArray[14]
        case "com.thewordgame.kids":
            return self.categoriesArray[15]
        case "com.thewordgame.relicsandsaints":
            return self.categoriesArray[16]
        case "com.thewordgame.revelation":
            return self.categoriesArray[17]
        case "com.thewordgame.sins":
            return self.categoriesArray[18]
        case "com.thewordgame.worship":
            return self.categoriesArray[19]
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
