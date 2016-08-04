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

    
    var people = ["Agrippa","Alexander","Ammon","Amos","Andrew","Andronicus","Arad","Arod","Asher","Balaam","Balak","Barabbas","Barnabas","Bartholomew","Belshazzar","Delilah","Ben-Hur","Dorcas","Benjamin","Boaz","Elisabeth","Ceasar","Caiaphas","Cain","Caleb","Claudius","Cornelius","Eve","Cush","Hadassah","Hagar","Cyrus","Dan","Darius","David","Demetrius","Eli","Elijah","Enoch","Enos","Ephron","Ephraim","Erastus","Esau","Ethan","Ezekiel","Ezra","Felix","Jemima","Festus","Jezebel","Gad","Gaius","Gideon","Goliath","Judith","Gomer","Gog","Gilead","Habakkuk","Leah","Lydia","Haggai","Ham","Martha","Mary Magdalene","Mary","Haman","Herod","Herod Agrippa","Hosea","Miriam","Hezekiah","Ibsam","Naomi","Ichabod","Isaac","Isaiah","Issachar","Phoebe","Pricilla","Rachel","Rahab","Rebecca","Ishmael","Israel","Ruth","Sapphira","Sarah","Sheerah","Jacob","James","Japheth","Susanna","Tabitha","Jason","Jedidiah","Jeremiah","Jesse","Jesus","Jethro","Vashti","Zebudah","Joab","Job","Joel","John","John the Baptist","Zipporah","Jonah","Jonathan","Joram","Josaphat","Joseph","Joshua","Josiah","Jubal","Judas","Judah","Jude","Julius","Lazarus","Levi","Lot","Lucifer","Luke","Malachi","Mark","Matthias","Matthew","Menasheh","Meshach","Methuselah","Micah","Michael","Moab","Mordecai","Moses","Nahum","Naboth","Naphtali","Narcissus","Nathan","Nathanael","Nebuchadnezzar","Nehemiah","Nicodemus","Nicolas","Nimrod","Noah","Obadiah","Paul","Peter","Pharaoh","Philemon","Philip","Pontius Pilate","Phinehas","Potiphar","Reuben","Rufus","Samson","Samuel","Saul","Seth","Shadrach","Sheba","Shem","Silas","Simeon","Simon","Solomon","Sosthenes","Stephen","Thaddaeus","Thomas","Tiberius","Timothy","Timon","Titus","Tyrannus","Uriah","Yam","Zaccheaus","Zacharias","Zebadiah","Zebedee","Zebulun","Zephaniah"]
    
    

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
    
    
    /**
     
        Generates a random word from the desired word category. 
     
        - Parameter category: the number of the selected category.

     
        - Returns: A random word from the selected category.
     
     **/
    func getWord() -> String {
    
        let randomIndex = Int(arc4random_uniform(UInt32(people.count)))

            return people[randomIndex]
    }
    
    
    /**
     
     - Updates each team's turn.
     
     **/
    func switchTeams() {
       
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