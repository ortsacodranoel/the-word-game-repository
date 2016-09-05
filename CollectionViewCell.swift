//
//  TransitionManager.swift
//  TheWordGame
//
//  Created by Leo on 7/24/16.
//  Copyright © 2016 Daniel Castro. All rights reserved.
//

import UIKit
import AVFoundation

class CollectionViewCell: UICollectionViewCell {
    
    // MARK - Variables
    var category : String = ""
    var cellTag : Int = -1
    
    // MARK: - Buttons
    @IBOutlet weak var categoryButton: UIButton!

    
    // MARK: - Audio
    var buttonSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("ButtonTapped", ofType: "wav")!)
    var tapAudioPlayer = AVAudioPlayer()
    
    func loadSoundFile() {
        do {
            self.tapAudioPlayer = try AVAudioPlayer(contentsOfURL: self.buttonSound, fileTypeHint: "wav")
            self.tapAudioPlayer.prepareToPlay()
                        
        } catch {
            print("Unable to load sound files.")
        }
    }
    
   
    @IBAction func buttonTouched(sender: AnyObject) {
        self.loadSoundFile()
        self.tapAudioPlayer.play()
    }
}