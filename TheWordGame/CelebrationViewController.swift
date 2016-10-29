//
//  CelebrationViewController.swift
//  TheWordGame
//
//  Created by Daniel Castro on 6/23/16.
//  Copyright © 2016 Daniel Castro. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class CelebrationViewController: UIViewController {

    @IBOutlet weak var winningTeamLabel: UILabel!
    var winningTeamName = String()
    @IBOutlet weak var newGameButton: UIButton!
    let celebrationMusic = URL(fileURLWithPath: Bundle.main.path(forResource: "celebrationMusic", ofType: "mp3")!)
    var celebrationScreenActiveAudio = AVAudioPlayer()
    

    @IBAction func newGameTapped(_ sender: AnyObject) {
        if Game.sharedGameInstance.teamOneIsActive == true {
            Game.sharedGameInstance.teamOneIsActive = false
        } else {
            Game.sharedGameInstance.teamOneIsActive = true
        }
        
        // Reset the game. 
        Game.sharedGameInstance.won = false
        Game.sharedGameInstance.clearArrays()
        Game.sharedGameInstance.resetGame()
        
        self.celebrationScreenActiveAudio.stop()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.newGameButton.layer.cornerRadius = 7
        self.newGameButton.layer.borderColor = UIColor.green.cgColor
        self.newGameButton.layer.borderWidth = 3
        
        do {
            self.celebrationScreenActiveAudio = try AVAudioPlayer(contentsOf: self.celebrationMusic, fileTypeHint: "mp3")
         } catch {
            print("Error: unable to find sound files.")
        }
    
        self.celebrationScreenActiveAudio.prepareToPlay()
        self.celebrationScreenActiveAudio.play()
        self.winningTeamLabel.text = Game.sharedGameInstance.winnerTitle
        
        
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "GameScene") {
                scene.scaleMode = .aspectFill
                view.presentScene(scene)
            }
            view.ignoresSiblingOrder = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            self.winningTeamLabel.center.x += self.view.bounds.width
        }, completion: nil)
        
        UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            self.newGameButton.center.y -= self.view.bounds.height
        }, completion: nil)
    }
}
