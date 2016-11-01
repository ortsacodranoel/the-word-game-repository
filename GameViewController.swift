//
//  GameViewController.swift
//  TheWordGame
//
//  Created by Daniel Castro on 6/23/16.
//  Copyright © 2016 Daniel Castro. All rights reserved.
//


import UIKit
import AVFoundation

class GameViewController: UIViewController {
    
    
    // MARK:- View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.isTutorialEnabled() == true {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GameViewController.hideTutorialAction(sender:)))
            self.tutorialOverlayView.addGestureRecognizer(tapGestureRecognizer)
        }
        self.addSwipeGestureRecognizers()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            self.tutorialBubbleTwoView.alpha = 0
            self.tutorial3view.alpha = 0
        
            menuButtonCenter = self.menuButtonView.center
            timerButtonCenter = self.timerView.center
            startButtonCenter = self.startButtonView.center
            teamTurnCenter = self.teamTurnView.center
            wordContainerCenter = self.wordContainerView.center
            timesUpCenter = self.timesUpView.center
            
            self.resetTimer()
            self.setTeamTurn()
            self.updateScore()
            self.setColorForViewBackground()
            self.configureViewStyles()
            self.configureLabelContent()
            self.loadSounds()
            
            self.timesUpView.alpha = 0
            
            UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
                // ONSCREEN: teamOneView up (-)
                self.teamOneView.center.y -= self.view.bounds.height
                }, completion:nil)
            UIView.animate(withDuration: 0.4, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
                // ONSCREEN: teamOneScore up (-)
                self.teamOneScoreView.center.y -= self.view.bounds.height
                }, completion: nil)
            UIView.animate(withDuration: 0.4, delay: 0.4, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
                // ONSCREEN: teamTwoView up (-)
                self.teamTwoView.center.y -= self.view.bounds.height
                }, completion: nil)
            UIView.animate(withDuration: 0.4, delay: 0.5, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
                // ONSCREEN: teamTwoScore (-)
                self.teamTwoScoreView.center.y -= self.view.bounds.height
                }, completion: nil)
            UIView.animate(withDuration: 0.4, delay: 0.6, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
                // ONSCREEN: menuBtn animation
                self.menuButtonView.center.y += self.view.bounds.height
                }, completion: nil)
            UIView.animate(withDuration: 0.4, delay: 0.7, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
                // ONSCREEN: timerView animate down (+)
                self.timerView.center.y += self.view.bounds.height
                }, completion: nil)
            UIView.animate(withDuration: 0.4, delay: 0.8, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
                // ONSCREEN: teamTurn animation
                self.teamTurnView.center.y += self.view.bounds.height
                }, completion: nil)
            UIView.animate(withDuration: 0.4, delay: 0.9, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
                // ONSCREEN: startBtn animation
                self.startButtonView.center.y -= self.view.bounds.height
                }, completion: nil)
            self.teamOneScoreLabel.text = String(Game.sharedGameInstance.getTeamOneScore())
            self.teamTwoScoreLabel.text = String(Game.sharedGameInstance.getTeamTwoScore())
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning() }


    // MARK: - Game Methods

    func playgame() {
        if self.isTutorialEnabled() == true {
            self.animateTutorialPopUps()
        }
        if Game.sharedGameInstance.won {
            self.gameTimer.invalidate()
            self.audioPlayerRoundIsEndingSound.stop()
            performSegue(withIdentifier: "segueToCelebration", sender: self)
        } else {
            // Reset Countdown for next team animation.
            self.countdownLabel.text = " "
            self.setTeamTurn()
            self.prepareGameTimer()
            self.startGameTimer()
            self.updateScore()
            self.endRound(0)
        }
    }
    
    
    // MARK: - Tutorial Methods
    
    func disablePopUps() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.managedObjectContext
        delegate.sharedTutorialEntity.setValue(false, forKey: "gameScreenEnabled")
        do {
            try context.save()
        } catch {
          //  let nserror = error as NSError
          //  NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func isTutorialEnabled() -> Bool {
        let sharedTutorialInstance = (UIApplication.shared.delegate as! AppDelegate).sharedTutorialEntity
        let enabled = sharedTutorialInstance?.value(forKey: "gameScreenEnabled") as! Bool
        return enabled
    }
    
    func animateTutorialPopUps() {
        if !self.popSoundTimer1.isValid {
            self.popSoundTimer1 = Timer.scheduledTimer(timeInterval: 0.0, target: self, selector: #selector(CategoriesViewController.playPopSound), userInfo:nil, repeats: false)
        }
        if !self.popSoundTimer2.isValid {
            self.popSoundTimer2 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(CategoriesViewController.playPopSound), userInfo:nil, repeats: false)
        }
        
        // Disable swipes.
        self.view.gestureRecognizers?.removeAll()
        
        self.tutorialBubbleTwoView.alpha = 1
        self.tutorial3view.alpha = 1
        
        // Animate views offScreen.
        self.tutorialBubbleTwoView.center.y -= self.tutorialBubbleTwoView.frame.size.height
        self.tutorialBubbleTwoView.center.x -= self.tutorialBubbleTwoView.frame.size.width
        
        self.tutorial3view.center.y += self.tutorial3view.frame.size.height
        self.tutorial3view.center.x += self.tutorial3view.frame.size.width
        
        // Animated views onScreen.
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            self.tutorialOverlayView.alpha = 0.8
            self.tutorialBubbleTwoView.center.y += self.tutorialBubbleTwoView.frame.size.height
            self.tutorialBubbleTwoView.center.x += self.tutorialBubbleTwoView.frame.size.width
            self.gameTimer.invalidate()
        }, completion: nil)
        
        UIView.animate(withDuration: 0.4, delay: 1.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            self.tutorial3view.center.y -= self.tutorial3view.frame.size.height
            self.tutorial3view.center.x -= self.tutorial3view.frame.size.width
        }, completion:nil)
    }
    
    
    func hideTutorialAction(sender:UITapGestureRecognizer) {
        // Animate overlay off-screen.
        UIView.animate(withDuration: 0.7, delay: 0.1,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
            // Increase the alpha of the view.
            self.tutorialOverlayView.alpha = 0
        }, completion: nil)
        // Animate tutorialView off-screen.
        UIView.animate(withDuration: 0.5, delay: 0.2,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
            // Move the view into place.
            self.tutorialBubbleTwoView.center.y -= self.tutorialBubbleTwoView.frame.size.height
            self.tutorialBubbleTwoView.center.x -= self.tutorialBubbleTwoView.frame.size.width
            
            self.tutorial3view.center.y += self.tutorial3view.frame.size.height
            self.tutorial3view.center.x += self.tutorial3view.frame.size.width
        }, completion: { (bool) in
            self.tutorialBubbleTwoView.alpha = 0
            self.tutorial3view.alpha = 0
            
            self.addSwipeGestureRecognizers()
            self.runGameTimer()
            
            self.disablePopUps()
        })
    }


    
    func playPopSound() {
        self.popAudioPlayer.play()
    }
    
    @IBAction func startButtonTouchUpInside(_ sender: AnyObject) {
        self.audioPlayerRoundIsStartingSound.play()
        
        UIView.animate(withDuration: 0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            // OFFSCREEN: wordContainerView animate (invisible)
            self.wordContainerView.center.x += self.view.bounds.width
            }, completion: nil )
        
        // TIME IS UP OFF SCREEN ANIMATE
        UIView.animate(withDuration: 0.4, delay: 0,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
            // OFFSCREEN: Time's Up View off the screen to the top.
            self.timesUpView.center.y -= self.view.bounds.height
            }, completion: nil)
        UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            // OFFSCREEN: startBtn animate down (+).
            self.startButtonView.center.y += self.view.bounds.height
            // OFFSCREEN: teamTurnView animate up (-).
            self.teamTurnView.center.y -= self.view.bounds.height
            }, completion: nil )
        UIView.animate(withDuration: 0.4, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            // OFFSCREEN: menuBtn animate up (-).
            self.menuButtonView.center.y -= self.view.bounds.height
            }, completion: nil )
        self.runCountdownTimer()
        
        // Reset swipe count.
        self.timesSwipedRight = 0
        
    }
    
    /// Used to execute something when the view returns from the summary screen.
    @IBAction func unwindToGame(_ segue: UIStoryboardSegue){
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            UIView.animate(withDuration: 0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
                
                // OFFSCREEN: wordContainerView animate (invisible)
                self.wordContainerView.center.x -= self.view.bounds.width
                }, completion: nil )

            self.startButtonView.center.y -= self.view.bounds.height
            self.teamTurnView.center.y += self.view.bounds.height
        }, completion: nil )
        
        // timerView ANIMATION: down to it's original position.
        UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            self.timerView.center.y += self.view.bounds.height
            }, completion: nil )

        // Animate the menu back to it's original position.
        UIView.animate(withDuration: 0.4, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            self.menuButtonView.center.y += self.view.bounds.height
            },completion:nil)

        // Clear the words from the arrays.
        Game.sharedGameInstance.correctWordsArray = []
        Game.sharedGameInstance.missedWordsArray = []
    }

    @IBAction func menuTapped(_ sender: AnyObject) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CategoriesViewController")
        self.present(vc!, animated: true, completion: nil)
    }
    
    
    func endRound(_ time: Int) {
        if self.seconds == 3 {
      
            // Play sounds alerting round coming to an end.
            self.audioPlayerRoundIsEndingSound.prepareToPlay()
            self.audioPlayerRoundIsEndingSound.play()
            
            
            // Red background color fade-in.
            UIView.animate(withDuration: 3.0, animations: { () -> Void in
                // Fade-in redBackgroundColor.
                self.redBackgroundView.alpha = 1
            })
         
            // If time is up and nobody won the game.
        } else if self.seconds == time && Game.sharedGameInstance.won == false {

            Game.sharedGameInstance.updateTeamTurn()
            self.setTeamTurn()
            
            // Animate the 'Time's Up' back onto the screen.
            UIView.animate(withDuration: 0.4, delay: 0,usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9,options: [], animations: {
                // print(self.timesUpView.center.y)
                // print("Animating timesUpView")
                self.timesUpView.alpha = 1
                self.timesUpView.center.y += self.view.bounds.height
                }, completion: nil)
        
            // Change the color of the screen back to original.
            UIView.animate(withDuration: 1.0, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
                self.setColorForViewBackground()
                }, completion: nil)
                
            // Move the 'gameTimer' up.
            UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
                    self.timerView.center.y -= self.view.bounds.height
                }, completion: nil)
            

            self.timesUpTimer.fire()
            
            // ANIMATION: Time's Up - Move UP.
            // Segue to the summary screen after 2.5 seconds.
            if !self.timesUpTimer.isValid {
                self.timesUpTimer = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(GameViewController.animateTimesUpOffScreen), userInfo:nil, repeats: false)
            }

            // Reset to `1:00`.
            self.resetTimer()
            
            
            // Remove the current word displayed on the screen.
            self.removeWord()
            
            // Segue to the summary screen after 2.5 seconds.
            if !self.segueDelayTimer.isValid {
                self.segueDelayTimer = Timer.scheduledTimer(timeInterval: 1.4, target: self, selector: #selector(GameViewController.displayWordSummaryScreen), userInfo:nil, repeats: false)
            }
        }
    }

    
    func resetRound(_ time: Double ) {
        UIView.animate(withDuration: 0.4, delay: time, usingSpringWithDamping: 0.8,initialSpringVelocity: 0.9, options: [], animations: {
                self.view.backgroundColor = Game.sharedGameInstance.colors[self.categoryTapped]
            }, completion: { (bool) in
                
                Game.sharedGameInstance.won = false
                self.audioPlayerRoundIsEndingSound.prepareToPlay()
                
                self.resetTimer()
                Game.sharedGameInstance.resetGame()
                Game.sharedGameInstance.updateTeamTurn()
                self.setTeamTurn()
                self.updateScore()
                self.removeWord()
        })
    }
    
    
    // Used by segueTimer to display the summaryViewController.
    func displayWordSummaryScreen() {
  
        // Red background color fade-in.
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            // Fade-in redBackgroundColor.
            self.redBackgroundView.alpha = 0
        })
        
        UIView.animate(withDuration: 0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
             
                // ANIMATION: Move the countdownView back into view for the next team.
                self.countdownView.center.x += self.view.bounds.width

                self.wordContainerView.alpha = 0
                }, completion:nil)
   
        Game.sharedGameInstance.segueFromDetailVC = false
        
        self.gameTimer.invalidate()
        performSegue(withIdentifier: "segueToSummaryScreen", sender: self)
    }
    
    
    func animateTimesUpOffScreen(){
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            self.timesUpView.center.y -= self.view.bounds.height
            self.timesUpView.alpha = 0
            }, completion: {(bool) in
                UIView.animate(withDuration: 0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
                    self.timesUpView.center.y += self.view.bounds.height
                    self.timesUpTimer.invalidate()
                }, completion: nil)
        })
    }
    
    
    
    // MARK: - Countdown animations

    func startCountdown() {
        if self.countdown  > 1 {
            self.countdown -= 1
            self.countdownLabel.text = "\(self.countdown)"
        } else {
            self.countdownLabel.text = "Go!"
            self.countdownTimer.invalidate()
            self.view.isUserInteractionEnabled = true
            self.wordOnScreen = true
            self.roundInProgress = true
            self.countdown = 4
            
            // Animate `Go!` Screen.
            UIView.animate(withDuration: 0.4, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
                self.countdownView.center.x -= self.view.bounds.width
            })
            
            // Start game.
            self.runGameTimer()
            self.animateNewWord()
        }
    }

    
    // MARK:- Configure Views
    
    func configureViewStyles(){
        let views = [self.startButton,
                     self.teamOneView,
                     self.teamTwoView,
                     self.teamOneScoreView,
                     self.teamTwoScoreView]
        for element in views {
            element?.layer.cornerRadius = 7
            element?.layer.borderColor = UIColor.white.cgColor
            element?.layer.borderWidth = 3
        }
    }
    

    func configureLabelContent() {
        self.teamOneLabel.text = "Team 1"
        self.teamTwoLabel.text = "Team 2"
    }
    
    func setColorForViewBackground() {
        self.view.backgroundColor = Game.sharedGameInstance.gameColor
    }
    
    func setTeamTurn() {
        if Game.sharedGameInstance.teamOneIsActive {
            self.teamTurnLabel.text = "Team One"
        } else {
            self.teamTurnLabel.text = "Team Two"
        }
    }

    func updateScore() {
        self.teamOneScoreLabel.text = String(Game.sharedGameInstance.getTeamOneScore())
        self.teamTwoScoreLabel.text = String(Game.sharedGameInstance.getTeamTwoScore())
    }
    

    /**
     Used by the game to remove a word when the game round ends. It removes
     the word that is currently on the screen off to the right. Once the word
     is moved, the method lowers the view's alpha.
     */
    func removeWord() {
        if Game.sharedGameInstance.won {
            UIView.animate(withDuration: 0.4, animations: {
                // Move the word container offscreen right (+)
                self.wordContainerView.center.x += self.view.bounds.width
            },  completion: { (bool) in
                self.resetRound(0)
            })
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                self.wordContainerView.center.x += self.view.bounds.width
            }, completion:nil)
        }
    }
    
    
    // MARK: - Gesture recognizer methods
    
    /**
     When the team knows the answer they will swipe left. When they do not, they can pass on the
     word by swiping right. Each team is limited to 2 passes per round.
     */
    func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                if self.roundInProgress {
                    if Game.sharedGameInstance.teamOneIsActive {
                        self.audioPlayerSwipeSound.play()
                        Game.sharedGameInstance.teamOneScore += 1
                        teamOneScoreLabel.text = String(Game.sharedGameInstance.getTeamOneScore())
                        self.animateNewWordRightSwipe()
                        self.audioPlayerCorrectSwipe.play()
                    
                    } else {
                        self.audioPlayerSwipeSound.play()
                        Game.sharedGameInstance.teamTwoScore += 1
                        teamTwoScoreLabel.text = String(Game.sharedGameInstance.getTeamTwoScore())
                        self.animateNewWordRightSwipe()
                        self.audioPlayerCorrectSwipe.play()
                    }
                }
            case UISwipeGestureRecognizerDirection.left:
                if self.roundInProgress {
                    if  self.wordOnScreen && self.timesSwipedRight < 2 {
                        self.audioPlayerSwipeSound.play()
                        self.timesSwipedRight += 1
                        self.animateNewWordLeftSwipe()
                    } else {
                        animatePassMessage()
                        self.audioPlayerWrondSwipe.play()
                    }
                }
            default:
                break
            }
        }
    }
    
    func addSwipeGestureRecognizers() {
        let swipeRightGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameViewController.respondToSwipeGesture(_:)))
        swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRightGestureRecognizer)
        let swipeLeftGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameViewController.respondToSwipeGesture(_:)))
        swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeftGestureRecognizer)
    }
    
    func animatePassMessage() {
        UIView.animate(withDuration: 0.4, delay:0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
                self.passLabel.alpha = 1
            },completion: {(bool) in
                UIView.animate(withDuration: 0.4, delay:1.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
                        self.passLabel.alpha = 0
                    },completion:nil)
        })
    }
    
    /**
     The initial word animation moves the wordContainerView into view from the left side of the screen.
     */
    func animateNewWordRightSwipe() {
        
        // Used to present words in summary screen.
        let currentWord = self.wordLabel.text
        Game.sharedGameInstance.correctWordsArray.append(currentWord!)
        
        // Animate new word from the right.
        UIView.animate(withDuration: 0.4, delay:0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            self.wordContainerView.alpha = 1
            // Move the word view right (+)
            self.wordContainerView.center.x += self.view.bounds.width
            // Check to see if game has been won.
            Game.sharedGameInstance.checkForWinner()
        }, completion: {(Bool) in
            if  Game.sharedGameInstance.won {
                self.wordContainerView.alpha = 0
            } else {
                self.wordLabel.text = Game.sharedGameInstance.getWord(self.categoryTapped)
            }
        })
        
        UIView.animate(withDuration: 0.4, delay:0.2, options: [], animations: {
                // Move the word to the left.
                self.wordContainerView.center.x -= self.view.bounds.width
                self.wordContainerView.alpha = 1
            }, completion: nil)
    }
    
    
    /**
     Animates the wordViewContainer left off-screen, followed by an animation of the container
     back to its original position to the right off-screen, finalizing by animating a new word
     to the middle of the screen. It also calls the .getWord() method to create the new word
     that is animated onto the screen.
     */
    
    func animateNewWordLeftSwipe() {
        let currentWord = self.wordLabel.text
        Game.sharedGameInstance.missedWordsArray.append(currentWord!)
        
        UIView.animate(withDuration: 0.4, delay:0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            // Moves the word that is currently on the screen off-screen left.
            self.wordContainerView.center.x -= self.view.bounds.width
            self.wordContainerView.alpha = 1
            }, completion: nil)
        UIView.animate(withDuration: 0.0, delay:0.4, options: [], animations: {
            // Moves the word that was just moved left off-screen all the way back to the right off-screen.
            self.wordContainerView.center.x += self.view.bounds.width + self.view.bounds.width
            self.wordContainerView.alpha = 1
            }, completion: { (Bool) in
                self.wordLabel.text = Game.sharedGameInstance.getWord(self.categoryTapped)
        })
        // Animates the word back from the right off-screen, to the middle.
        UIView.animate(withDuration: 0.4, delay:0.2, options: [], animations: {
            self.wordContainerView.center.x -= self.view.bounds.width
            self.wordContainerView.alpha = 1
            }, completion: nil)
    }
    
    
    /**
     Sets a new word to display based on the selected category. Animates that word onto
     the screen from the left side of the view, and sets`wordOnScreen` equal to true.
     */
    func animateNewWord() {
        UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9,options: [], animations: {
            // Get a new random word.
            self.wordLabel.text = Game.sharedGameInstance.getWord(self.categoryTapped)
            self.wordContainerView.alpha = 1
            self.wordContainerView.center.x -= self.view.bounds.width
            }, completion: nil )
    }
    
    

    // MARK: - Timer Methods
    
    /**
     Used to runs the countdown that appears before a game round start.
     The method is called when the start button is touched.
     */
    func runCountdownTimer() {
        // Display countdownView.
        self.countdownView.alpha = 1
        // Disable interactions.
        self.view.isUserInteractionEnabled = false
        // Initiate countdown.
        if !self.countdownTimer.isValid {
            self.countdownTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(GameViewController.startCountdown), userInfo:nil, repeats: true)
        }
    }
    
    
    /**
     Used to execute the game timer which notifies the players how much time
     is remaining. The method calls'startRound()`, which will execute
     all of the main game functions.
     */
    func runGameTimer() {
        if !self.gameTimer.isValid {
            self.gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.playgame), userInfo:nil, repeats: true)
        }
    }
    
    
    /**
     Used to change the text of the timer label from `01:00` to `00:59`.
     The method also updates the timeIsUp variable, which is used to 
     notify that a new game round has begun.
    */
    func prepareGameTimer() {
        timeIsUp = false
        if self.seconds == 0 {
            self.seconds = 60
            self.minutes = 0
            let strMinutes = String(format: "%1d", self.minutes)
            let strSeconds = String(format: "%02d", self.seconds)
            self.timerLabel.text = "\(strMinutes):\(strSeconds)"
        }
        self.countdown = 4
    }
    
    func startGameTimer() {
        self.seconds -= 1
        self.minutes = 0
        let strMinutes = String(format: "%1d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        self.timerLabel.text = "\(strMinutes):\(strSeconds)"
    }

    func resetTimer() {
        self.roundInProgress = false
        self.timeIsUp = true
        self.gameTimer.invalidate()
        self.seconds = 00
        self.minutes = 1
        let strMinutes = String(format: "%1d", self.minutes)
        let strSeconds = String(format: "%02d", self.seconds)
        self.timerLabel.text = "\(strMinutes):\(strSeconds)"
    }

    
    // MARK: - Audio Methods
    func loadSounds() {
        do {
            // Configure Audioplayers.
            self.audioPlayerWinSound = try AVAudioPlayer(contentsOf: self.soundEffectWinner,fileTypeHint: "mp3")
            self.audioPlayerSwipeSound = try AVAudioPlayer(contentsOf: self.soundEffectSwipe, fileTypeHint: "wav")
            self.audioPlayerRoundIsStartingSound = try AVAudioPlayer(contentsOf: self.soundEffectStartRound, fileTypeHint: "mp3")
            self.audioPlayerRoundIsEndingSound = try AVAudioPlayer(contentsOf: self.soundEffectEndRound, fileTypeHint: "mp3")
            self.audioPlayerCorrectSwipe = try AVAudioPlayer(contentsOf: self.soundEffectCorrectSwipe, fileTypeHint: "mp3")
            self.audioPlayerWrondSwipe = try AVAudioPlayer(contentsOf: self.soundEffectWrongSwipe, fileTypeHint: "mp3")
            
            self.audioPlayerWinSound.prepareToPlay()
            self.audioPlayerSwipeSound.prepareToPlay()
            self.audioPlayerRoundIsStartingSound.prepareToPlay()
            self.audioPlayerRoundIsEndingSound.prepareToPlay()
            
            self.audioPlayerCorrectSwipe.prepareToPlay()
            self.audioPlayerWrondSwipe.prepareToPlay()
            
            self.popAudioPlayer = try AVAudioPlayer(contentsOf: self.popSound, fileTypeHint: "mp3")
            self.popAudioPlayer.prepareToPlay()
            
        } catch {
            // let nserror = error as NSError
            // NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    
    //MARK:- Properties
    var categoryTapped = Int()

    /// Used to store the value for the initial countdown.
    var countdown = 4
    var wordOnScreen = false
    var wordRemoved = false
    var roundInProgress = false
    
    
    @IBOutlet weak var tutorialBubbleTwoView: UIView!
    @IBOutlet weak var tutorialOverlayView: UIView!
    @IBOutlet weak var tutorial3view: UIView!
    var popSound = URL(fileURLWithPath: Bundle.main.path(forResource: "BubblePop", ofType: "mp3")!)
    var popAudioPlayer = AVAudioPlayer()
    
    
    //MARK: - Views
    @IBOutlet weak var menuButtonView: UIView!
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var teamOneView: UIView!
    @IBOutlet weak var teamOneScoreView: UIView!
    @IBOutlet weak var teamTwoView: UIView!
    @IBOutlet weak var teamTwoScoreView: UIView!
    @IBOutlet weak var startButtonView: UIView!
    @IBOutlet weak var countdownView: UIView!
    @IBOutlet weak var teamTurnView: UIView!
    @IBOutlet weak var wordContainerView: UIView!
    @IBOutlet weak var timesUpView: UIView!
    
    /// Used when timer is running out.
    @IBOutlet weak var redBackgroundView: UIView!
    
    //MARK:- Labels
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var teamOneLabel: UILabel!
    @IBOutlet weak var teamTwoLabel: UILabel!
    @IBOutlet weak var teamOneScoreLabel: UILabel!
    @IBOutlet weak var teamTwoScoreLabel: UILabel!
    @IBOutlet weak var teamTurnLabel: UILabel!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var passLabel: UILabel!
    
    
    // MARK: - Transition Managers
    let transitionManager = TransitionManager()
    
    
    //MARK:- Buttons
    @IBOutlet weak var startButton: UIButton!
    
    //MARK:- Animation Properties
    var animatingLeft = false
    var animationInProgress = false
    
    //MARK:- Timer Properties
    var gameTimer = Timer()
    var countdownTimer = Timer()
    var segueDelayTimer = Timer()
    /// Used to animate Time's Up prior to summary screen.
    var timesUpTimer = Timer()
    var popSoundTimer1 = Timer()
    var popSoundTimer2 = Timer()

    var seconds = 00
    var minutes = 1
    var time = ""
    var timeIsUp = false
    
    
    //MARK:- Swipe Gesture Recognizer Properties
    var swipedRight = false
    var timesSwipedRight = 0
    
    
    // Paths to sound effects.
    let soundEffectSwipe = URL(fileURLWithPath: Bundle.main.path(forResource: "swipeSoundEffect", ofType: "mp3")!)
    let soundEffectWinner = URL(fileURLWithPath: Bundle.main.path(forResource: "winner", ofType: "mp3")!)
    let soundEffectStartRound = URL(fileURLWithPath: Bundle.main.path(forResource: "initialCountdown", ofType: "mp3")!)
    let soundEffectEndRound = URL(fileURLWithPath: Bundle.main.path(forResource: "countdown", ofType: "mp3")!)
    let soundEffectCorrectSwipe = URL(fileURLWithPath: Bundle.main.path(forResource: "correctSwipe", ofType: "mp3")!)
    let soundEffectWrongSwipe = URL(fileURLWithPath: Bundle.main.path(forResource: "wrong", ofType: "mp3")!)
    
    
    /// Used for sound effect when a word is swiped during the game.
    var audioPlayerSwipeSound = AVAudioPlayer()
    /// Used to play the sound effect when a team wins.
    var audioPlayerWinSound = AVAudioPlayer()
    /// Used to play sound effects before a game round begins.
    var audioPlayerRoundIsStartingSound = AVAudioPlayer()
    /// Used to play sound effects when the game timer is coming to an end.
    var audioPlayerRoundIsEndingSound = AVAudioPlayer()
    /// Used to play the correct swipe.
    var audioPlayerCorrectSwipe = AVAudioPlayer()
    /// Used to play the missed swipe.
    var audioPlayerWrondSwipe = AVAudioPlayer()
    
    
    // View centers.
    var menuButtonCenter:CGPoint!
    var timerButtonCenter:CGPoint!
    var startButtonCenter:CGPoint!
    var teamTurnCenter:CGPoint!
    var wordContainerCenter:CGPoint!
    var timesUpCenter:CGPoint!
    
    
    // Used to test celebration screen.
    var gameWon = false
}




