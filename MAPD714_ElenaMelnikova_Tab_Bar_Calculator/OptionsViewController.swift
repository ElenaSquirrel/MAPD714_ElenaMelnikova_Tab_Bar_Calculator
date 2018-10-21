
//  OptionsViewController.swift

//  Calculator with Tab Bar Controller version 1.2
//  Created by Elena Melnikova on 2018-10-16.
//  Student ID: 301025880
//  Last modification date: 2018-10-21
//  Copyright © 2018 Centennial College. All rights reserved.

import UIKit

class OptionsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet weak var color_picker: UIPickerView!
    // Send data to calculators
    let defaults = UserDefaults.standard
    
    var backgroundColor = "Dark Gray"
    var textColor = "White"
    
    //
    
    private let backgroundColorComponent = 0
    private let textColorComponent = 1
    
    private let characterBackgroundColors = [
        "Dark Gray", "Red", "Yellow", "Blue", "Black", "White"]
    
    
    private let characterTextColors = [
        "Dark Gray", "Red", "Yellow", "Blue", "Black", "White"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func submitOptions(_ sender: UIButton) {
        let row_backgroundColor = color_picker.selectedRow(inComponent: 0)
        let row_textColor = color_picker.selectedRow(inComponent: 1)
        
        let selected_backgroundColor = characterBackgroundColors[row_backgroundColor]
        let selected_textColor = characterTextColors[row_textColor]
        
//        let title_backgroundColor = "You selected \(selected_backgroundColor)!"
//        let title_textColor = "You selected \(selected_textColor)!"
        
//        let alert = UIAlertController(
//            title: title_backgroundColor + " " + title_textColor,
//            message: "Thank you for choosing",
//            preferredStyle: .alert)

        
//        let action = UIAlertAction(
//            title: "You're welcome",
//            style: .default,
//            handler: nil)
//        alert.addAction(action)
//        present(alert, animated: true, completion: nil)

        // Set defaults key value pairs to send colors data for calculators
        defaults.set(selected_backgroundColor, forKey: "backgroundColor")
        defaults.set(selected_textColor, forKey: "textColor")
    }
    
    // MARK: Picker Data Source Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        if component == backgroundColorComponent {
            return characterBackgroundColors.count
        } else {
            return characterTextColors.count
        }
    }
    
    // MARK: Picker Delegate Methods
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == backgroundColorComponent {
            return characterBackgroundColors[row]
        } else {
            return characterTextColors[row]
        }
    }
    
}

