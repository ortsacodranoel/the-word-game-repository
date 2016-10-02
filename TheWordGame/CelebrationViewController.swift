//
//  CelebrationViewController.swift
//  TheWordGame
//
//  Created by Daniel Castro on 9/27/16.
//  Copyright © 2016 Daniel Castro. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class CelebrationViewController: UIViewController {

    // Displays winning team.
    @IBOutlet weak var winningTeamLabel: UILabel!
    
    var winningTeamName = String()
    
    @IBOutlet weak var newGameButton: UIButton!
    
    //MARK:- Audio Properties
    
    // Paths to sound effects.
    let celebrationMusic = URL(fileURLWithPath: Bundle.main.path(forResource: "celebrationMusic", ofType: "mp3")!)
    
    /// Used for menu interactions sounds.
    var celebrationScreenActiveAudio = AVAudioPlayer()
    

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.newGameButton.layer.cornerRadius = 7
        self.newGameButton.layer.borderColor = UIColor.darkGray.cgColor
        self.newGameButton.layer.borderWidth = 3
        
        
        do {
            self.celebrationScreenActiveAudio = try AVAudioPlayer(contentsOf: self.celebrationMusic, fileTypeHint: "mp3")
         } catch {
            print("Error: unable to find sound files.")
        }
    
        self.celebrationScreenActiveAudio.prepareToPlay()
        self.celebrationScreenActiveAudio.play()
        self.winningTeamLabel.text = Game.sharedGameInstance.winnerTitle
        
        
        // GAME KIT - METHODS
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
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
