//
//  Game.swift
//  testing-animations
//
//  Created by Leo on 7/6/16.
//  Copyright © 2016 Daniel Castro. All rights reserved.
//

import Foundation

class Game {
    
    // Used to verify that a new game has been initiated.
    var isActive = false
    
    // Used to determine if a team is still playing its turn.
    var roundInProgress : Bool
    
    // Used to determine if Team 1 is playing.
    var teamOneIsActive = false
    
    // Used to determine if Team 2 is playing.
    var teamTwoIsActive = false
    
    // Keeps the score of the first team.
    var teamOneScore : Int
    
    // Keeps the score of the second team.
    var teamTwoScore : Int
    
    

    /**
     
        Initializes a new game and sets the current turn to Team 1.
     
        Parameters:
     
        Returns:
     
    **/
    init() {
        
        self.teamOneScore = 0
        self.teamTwoScore = 0
        self.isActive = true
        self.roundInProgress = true
        self.teamOneIsActive = true
        self.roundInProgress = true
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
    

}