//
//  CollectionViewCell.swift
//  testing-animations
//
//  Created by Daniel Castro on 6/23/16.
//  Copyright © 2016 Daniel Castro. All rights reserved.
//

import UIKit
import AVFoundation

class CollectionViewCell: UICollectionViewCell {
    
    // MARK - Variables
    var category : String = ""
    var cellTag : Int = -1
    
    // MARK: - Audio
    var buttonSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("ButtonTouched", ofType: "mp3")!)
    var audioPlayer = AVAudioPlayer()
    
    
    func loadSoundFile() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: self.buttonSound, fileTypeHint: "mp3")
            audioPlayer.prepareToPlay()
        } catch {
            print("Something happened")
        }
    }
    
    @IBOutlet weak var categoryButton: UIButton!
   
    
    @IBAction func buttonTouched(sender: AnyObject) {
        self.loadSoundFile()
        self.audioPlayer.play()
    }
}