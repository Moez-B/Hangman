//
//  gameViewController.swift
//  Hangman
//
//  Created by Moez on 2019-07-26.
//  Copyright © 2019 Moez. All rights reserved.
//

import UIKit

class gameViewController: UIViewController {
    
    var fieldEntry = ViewController()
    
    var guess:String = String()
    
    var guessed:[String] = []
    
    var word_text:String = String()
    
    var wordLabel_text:String = String()
    
    var wordLabel_arr:[String] = []
    
    var places:[Int] = []
    
    var correctGuesses_count:Int = 0
    
    var wrongGuesses_count:Int = 0
    
    @IBOutlet weak var alreadyGuessedLabel: UILabel!
    
    @IBOutlet weak var wordLabel: UILabel!
    
    @IBOutlet weak var guessField: UITextField!
    
    @IBOutlet weak var arm1: UIImageView!
    
    @IBOutlet weak var arm2: UIImageView!
    
    @IBOutlet weak var leg1: UIImageView!
    
    @IBOutlet weak var leg2: UIImageView!
    
    @IBOutlet weak var torso: UIImageView!
    
    @IBOutlet weak var head: UIImageView!
    
    @IBOutlet weak var guessButton: UIButton!
    
    @IBAction func backTapped(_ sender: Any) {
        performSegue(withIdentifier: "toHomeView", sender: self)
    }

    @IBAction func guessTapped(_ sender: Any) {
        guess = guessField.text!.uppercased()
        if guess.count == 1 {
            if !guessed.contains(guess) {
                guessed.append(guess)
                if word_text.uppercased().contains(guess) {
                    places = findIndexsOf(guess)
                    for place in places {
                        wordLabel_arr[place * 2] = guess
                    }
                    guessField.text = String()
                    alreadyGuessedLabel.text = "\(guess) is in the phrase!"
                    emptyGuessField()
                    correctGuesses_count += findIndexsOf(guess).count
                    setLabel()
                    if correctGuesses_count == word_text.count {
                        winner()
                    }
                }

                else {
                    alreadyGuessedLabel.text = "\(guess) is not in the phrase! Try again!"
                    emptyGuessField()
                    wrongGuesses_count += 1
                    if wrongGuesses_count < 6 {
                        removeBodyPart(wrongGuesses_count)
                    }
                    else {
                        assignWordLabel_arr()
                        setLabel()
                        loser()
                    }
                }
            }
            else {
                alreadyGuessedLabel.text = "Invalid, Already Guessed \(guess)!"
                emptyGuessField()
            }
        }
        else if guess.uppercased() == word_text.uppercased() {
            assignWordLabel_arr()
            setLabel()
            winner()
        }
        else {
            alreadyGuessedLabel.text = "Invalid, \(guess) is not the phrase!"
            emptyGuessField()
        }
    }
    
    func assignWordLabel_arr() {
        for (i,char) in word_text.enumerated() {
            wordLabel_arr[i * 2] = String(char).uppercased()
        }
    }
    
    func findIndexsOf(_ str:String) -> [Int] {
        var indexArr:[Int] = []
        for (index,letter) in word_text.uppercased().enumerated() {
            if letter == Character(str) {
               indexArr.append(index)
            }
        }
        return indexArr
    }
    
    func emptyGuessField() {
        guessField.text = String()
    }
    
    func winner() {
        alreadyGuessedLabel.text = "Good job! You have guessed the word(s)!"
        guessField.isEnabled = false
        guessField.text = "You Won! :)"
        guessButton.isEnabled = false
    }
    
    func loser() {
        alreadyGuessedLabel.text = "The phrase was \(word_text)!"
        guessField.isEnabled = false
        guessField.text = "You Lost! :("
        guessButton.isEnabled = false
    }
    
    func setLabel() {
        var label:String = String()
        for char in wordLabel_arr {
            label.append(char)
        }
        wordLabel.text = label
    }
    
    func removeBodyPart(_ counter:Int) {
        switch counter {
        case 1:
            head.isHidden = false
        case 2:
            torso.isHidden = false
        case 3:
            arm1.isHidden = false
        case 4:
            arm2.isHidden = false
        case 5:
            leg1.isHidden = false
        case 6:
            leg2.isHidden = false
        default:
            print("counter error")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configGuessField()
        
        setLimbAngles()
        hideBodyParts()
        initializeWordLabel()
    }
    
    func configGuessField() {
        guessField.delegate = self
    }
    
    func initializeWordLabel() {
        var counter:Int = 0
        while word_text.last! == " " || Int(word_text.last!.asciiValue!) < 65 || Int(word_text.last!.asciiValue!) > 122 {
                word_text = String(word_text.dropLast())
            }
        for char in word_text {
            if char != " " && char != "-" {
                wordLabel_text.append("_")
                wordLabel_arr.append("_")
            }
            else if char == "-" {
                wordLabel_text.append("-")
                wordLabel_arr.append("-")
            }
            else {
                wordLabel_text.append(char)
                wordLabel_arr.append(String(char))
            }
            wordLabel_text.append(" ")
            wordLabel_arr.append(" ")
            counter += 1
        }
        wordLabel.text = wordLabel_text
    }
    
    
    func setLimbAngles() {
        arm1.transform = CGAffineTransform(rotationAngle:-45)
        arm2.transform = CGAffineTransform(rotationAngle:45)
        
        leg1.transform = CGAffineTransform(rotationAngle:-45)
        leg2.transform = CGAffineTransform(rotationAngle:45)
    }
    
    func hideBodyParts() {
        head.isHidden = true
        torso.isHidden = true
        arm1.isHidden = true
        arm2.isHidden = true
        leg1.isHidden = true
        leg2.isHidden = true
    }

}

extension gameViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ guessField: UITextField) -> Bool {
        fieldEntry.isFieldEmpty(guessField,guessButton)
        if fieldEntry.isAllSpaces(guessField.text!) {
            guessButton.isEnabled = false
        }
        else if !fieldEntry.isAllSpaces(guessField.text!) {
            guessButton.isEnabled = true
        }
        guessField.resignFirstResponder()
        return true
    }
    
}
