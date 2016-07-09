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

   
    init() {
        self.teamOneScore = 0
        self.teamTwoScore = 0
    }
    
    
    // Sets the score variables to 0 in order to start a new game. 
    func start() {
        self.teamOneScore = 0
        self.teamTwoScore = 0
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
    
}