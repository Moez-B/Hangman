//
//  settingsViewController.swift
//  Hangman
//
//  Created by Moez on 2019-07-30.
//  Copyright © 2019 Moez. All rights reserved.
//

import UIKit

class settingsController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var difficulty:String = String()
    
    let difficulties:[String] = ["Easy","Medium","Hard"]
    
    @IBOutlet weak var difficultyPicker: UIPickerView!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return difficulties.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return difficulties[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        difficulty = difficulties[row]
    }
    
    @IBAction func backToHomeViewTapped(_ sender: Any) {
        performSegue(withIdentifier: "backToHomeView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backToHomeView = segue.destination as! ViewController
        backToHomeView.difficulty = difficulty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configPickerView()
        
    }

    func configPickerView() {
        difficultyPicker.delegate = self
        difficultyPicker.dataSource = self
    }
    
}
