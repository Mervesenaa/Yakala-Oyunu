//
//  ViewController.swift
//  YakalamaOyunu
//
//  Created by Merve Sena on 31.01.2024.
//

import UIKit

class ViewController: UIViewController {
    
    var score = 0
    var timer = Timer()
    var counter = 0
    var moneyArray = [UIImageView]()
    var hideTimer = Timer()
    var highScore = 0
    
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highscoreLabel: UILabel!
    @IBOutlet weak var money1: UIImageView!
    @IBOutlet weak var money2: UIImageView!
    @IBOutlet weak var money3: UIImageView!
    @IBOutlet weak var money4: UIImageView!
    @IBOutlet weak var money5: UIImageView!
    @IBOutlet weak var money6: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreLabel.text = "Score :\(score)"
        
        let storedHighScore = UserDefaults.standard.object(forKey: "highScore")
        
        if storedHighScore == nil {
            highScore = 0
            highscoreLabel.text = "HighScore :\(highScore)"
        }
        
        if let newScore = storedHighScore as? Int {
            highScore = newScore
            highscoreLabel.text = "Highscore :\(highScore)"
        }
        
        
        money1.isUserInteractionEnabled = true
        money2.isUserInteractionEnabled = true
        money3.isUserInteractionEnabled = true
        money4.isUserInteractionEnabled = true
        money5.isUserInteractionEnabled = true
        money6.isUserInteractionEnabled = true
        
        let recognizer1 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer2 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer3 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer4 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer5 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer6 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        
        money1.addGestureRecognizer(recognizer1)
        money2.addGestureRecognizer(recognizer2)
        money3.addGestureRecognizer(recognizer3)
        money4.addGestureRecognizer(recognizer4)
        money5.addGestureRecognizer(recognizer5)
        money6.addGestureRecognizer(recognizer6)
        
        
        moneyArray = [money1, money2, money3, money4, money5, money6]
        
        counter = 10
        timeLabel.text = "\(counter)"
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        hideTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(hideMoney), userInfo: nil, repeats: true)
        
        hideMoney()
        
        
    }
    
    @objc func hideMoney() {
        for money in moneyArray {
            money.isHidden = true
        }
        
        let random = Int(arc4random_uniform(UInt32(moneyArray.count-1)))
        moneyArray[random].isHidden = false
    }
    
    @objc func increaseScore(){
        score += 1
        scoreLabel.text = "Score :\(score)"
    }
    
    @objc func countDown(){
        counter  -= 1
        timeLabel.text = String(counter)
        
        if counter == 0{
            timer.invalidate()
            hideTimer.invalidate()
            
                for money in moneyArray {
                    money.isHidden = true
                }
                
                if self.score > self.highScore {
                    self.highScore = self.score
                    highscoreLabel.text = "Highscore: \(self.highScore)"
                    UserDefaults.standard.set(self.highScore, forKey: "highscore")
                }
                
                let alert = UIAlertController(title: "Time's Up!", message: "Do you want to play again?", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
                
                let replyButton = UIAlertAction(title: "Replay", style: UIAlertAction.Style.default) { UIAlertAction in
                    self.score = 0
                    self.scoreLabel.text = "Score :\(self.score)"
                    self.counter = 10
                    self.timeLabel.text = String(self.counter)
                    
                    
                    self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)
                    self.hideTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.hideMoney), userInfo: nil, repeats: true)
                    
                    
                }
                
                alert.addAction(okButton)
                alert.addAction(replyButton)
                self.present(alert, animated: true, completion: nil)
        }
    }
}
