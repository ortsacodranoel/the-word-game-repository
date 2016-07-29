//
//  Game.swift
//  testing-animations
//
//  Created by Leo on 7/6/16.
//  Copyright © 2016 Daniel Castro. All rights reserved.
//

import Foundation

class Game {
    
    var teamOneScore : Int
    var teamTwoScore : Int
    var teamOneTurn : Bool
   
    // Used to check if a game is in process.
    var isActive = false
    
    // Used to deterimine if the player has swiped.
    var hasSwiped = false
    
    init() {
        self.teamOneScore = 0
        self.teamTwoScore = 0
        teamOneTurn = true
    }
    
    
    // Sets the score variables to 0 in order to start a new game. 
    func start() {
        self.teamOneScore = 0
        self.teamTwoScore = 0
        
        // If neither teams have reached 25, generate a word.
        
    }
    
    
    /**
     
        Generates a random word from the desired word category. 
     
        - Parameter category: the number of the selected category.

     
        - Returns: A random word from the selected category.
     
     **/
    func getWord(category: Int) -> String {
    
        return "Hello"
    }
    
    
    // The method updates current game variables.
    func updateGame() {
        
    }
    
    
    // Returns the current score for Team One. 
    func getTeamOneScore() -> Int {
        return teamOneScore
    }
    
    
    // Returns the current score for Team Two.
    func getTeamTwoScore() -> Int {
        return teamTwoScore
    }
    
    
    // If someone swipes right, increment the teams score by one.
    

    // Return team who's turn it is.
    func getCurrentTeamTurn() -> String {
        if self.teamOneTurn == true {
            return "TEAM 1"
        } else {
            return "TEAM 2"
        }
    }




}