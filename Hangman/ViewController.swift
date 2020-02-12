//
//  ViewController.swift
//  Hangman
//
//  Created by Moez on 2019-07-26.
//  Copyright © 2019 Moez. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    let pickerViewLabels:[String] = ["2 Players","1 Player"]
    
    var players:Int = 0
    
    var difficulty:String = String()
    
    let wordListE:[String] = ["HAT","CAT","DOG","SELL","FOOD","BED","APPLE","LION","LAMP","SOFA","BENCH","PHONE"]
    
    let wordListM:[String] = ["WHAT","ELEPHANT","HELLO","AFRICA","WALEED","VIC","MOEZ","TELEPHONE","BEAR","WEAPON","WATER","FOOD","BANANA","CHEESE","HANDLE","SHELF","MONEY","THANKS","NECTARINE"]
    
    let wordListH:[String] = ["SERIOUSLY","LASAGNA","SPANAKOPITA","MEOW"]
    
    @IBOutlet weak var wordField: UITextField!
    
    @IBOutlet weak var instructionView: UILabel!
    
    @IBOutlet weak var playerPicker: UIPickerView!
    
    @IBOutlet weak var gameViewTapped: UIButton!
    
    @IBAction func settingsTapped(_ sender: Any) {
        performSegue(withIdentifier: "toSettings", sender: self)
    }
    
    @IBAction func toGameView(_ sender: Any?) {
        performSegue(withIdentifier: "toGameView", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGameView" {
            let gameView = segue.destination as! gameViewController
            var wordList:[String] = []
            if players == 1 {
                if difficulty == "Easy" {
                    wordList = wordListE
                }
                else if difficulty == "Medium" {
                    wordList = wordListM
                }
                else if difficulty == "Hard" {
                    wordList = wordListH
                }
                else {
                    wordList = wordListE
                }
                gameView.word_text = wordList[Int.random(in: 0...(wordList.count - 1))]
            }
            else {
                gameView.word_text = wordField.text!
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewLabels[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewLabels.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerViewLabels[row] == "2 Players" {
            instructionView.isHidden = false
            wordField.isEnabled = true
            wordField.placeholder = "Enter Text Here"
            wordField.text = String()
            players = 2
        }
        else if pickerViewLabels[row] == "1 Player" {
            instructionView.isHidden = true
            wordField.isEnabled = false
            wordField.text = "1 Player Mode Is Active"
            wordField.placeholder = String()
            players = 1
            gameViewTapped.isEnabled = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configFields()
        isFieldEmpty(wordField,gameViewTapped)
    }

    func isFieldEmpty(_ field: UITextField,_ button: UIButton) {
        if field.text!.isEmpty || isAllSpaces(field.text!) || isAllPunc(field.text!)  {
            button.isEnabled = false
        }
        else {
            button.isEnabled = true
        }
    }
    
    func isAllSpaces(_ str:String) -> Bool {
        var spaceCount:Int = 0
        for char in str {
            if char == " " {
                spaceCount += 1
            }
        }
        if spaceCount == str.count {
            return true
        }
        return false
    }
    
    func isAllPunc(_ str:String) -> Bool {
        var nonLetterCount:Int = 0
        for char in str {
            if Int(char.asciiValue!) < 65 || Int(char.asciiValue!) > 122 {
                nonLetterCount += 1
            }
        }
        if nonLetterCount == str.count {
            return true
        }
        return false
    }
    
    func configFields() {
        wordField.delegate = self
        
        playerPicker.delegate = self
        playerPicker.dataSource = self
    }
    
}

extension ViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ field: UITextField) -> Bool {
        field.resignFirstResponder()
        isFieldEmpty(wordField,gameViewTapped)
        return true
    }
    
}

