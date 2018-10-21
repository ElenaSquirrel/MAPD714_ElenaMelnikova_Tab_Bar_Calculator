//
//  ScientificCalculatorViewController.swift
//  MAPD714_ElenaMelnikova_Tab_Bar_Calculator
//
//  Created by Elena Melnikova on 2018-10-16.
//  Copyright © 2018 Centennial College. All rights reserved.
//

import UIKit

class ScientificCalculatorViewController: UIViewController {
    let defaults = UserDefaults.standard
    
    func getSubviewsOfView(v:UIView) -> [UIButton] {
        var buttonArray = [UIButton]()
        for subview in v.subviews {
            buttonArray += getSubviewsOfView(v: subview)
            if subview is UIButton {
                buttonArray.append(subview as! UIButton)
            }
        }
        return buttonArray
    }
    
    // Set x^2, x^3 and 10^x in readable form
    
    @IBOutlet weak var xExp2: UIButton!
    @IBOutlet weak var xExp3: UIButton!
    @IBOutlet weak var tenExpN: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    // https://www.fileformat.info/info/unicode/block/superscripts_and_subscripts/list.htm
       
        xExp2.setTitle("x\u{00B2}", for: [])
        xExp3.setTitle("x\u{00B3}", for: [])
        tenExpN.setTitle("10\u{207F}", for: [])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        var backgroundColor = UIColor.darkGray
        var textColor = UIColor.white
        
        var scientificBackgroundColor = defaults.string(forKey: "backgroundColor")
        var scientificTextColor = defaults.string(forKey: "textColor")
        
        if scientificBackgroundColor == nil{
            scientificBackgroundColor = "Dark Gray"
            
        }
        
        switch scientificBackgroundColor {
        case "Red":
            backgroundColor = UIColor.red
            break
        case "Yellow":
            backgroundColor = UIColor.yellow
            break
        case "Blue":
            backgroundColor = UIColor.blue
            break
        case "Black":
            backgroundColor = UIColor.black
            break
        case "White":
            backgroundColor = UIColor.white
            break
        default:
            backgroundColor = UIColor.darkGray
        }
        
        if scientificTextColor == nil{
            scientificTextColor = "White"
        }
        switch scientificTextColor {
        case "Red":
            textColor = UIColor.red
            break
        case "Yellow":
            textColor = UIColor.yellow
            break
        case "Blue":
            textColor = UIColor.blue
            break
        case "Black":
            textColor = UIColor.black
            break
        case "Dark Gray":
            textColor = UIColor.darkGray
            break
        default:
            textColor = UIColor.white
        }
        
        let buttons = getSubviewsOfView(v: self.view)
        for btn in buttons {
            btn.setTitleColor(textColor, for: .normal)
            if btn.titleLabel?.text != "C" && btn.titleLabel?.text != "=" {
                btn.backgroundColor = backgroundColor
            }
        }
    }
    
    
    
    
    
    
    
    var screenNumber:Double? = nil
    
    //Number displayed on screen before operation
    var previousNumber:Double? = nil
    
    //Operation
    var operation:Int? = nil
    
    //Flag showing if operation is in progress
    var performingMath = false
    
    var eql = false
    //UILabel! with paddings that set in UILabelPaddind.swift
    
    @IBOutlet weak var label: UILabelPadding!
    
    //Normalize string to string
    
    func normalize(input:String) -> String {
        
        let isMinus = String(input.prefix(1))
        var str: String
        //Take first 9 chars including "-" sign or 8 chars excluding "+" sign
        
        //Take first 9 chars (with "-")
        
        if isMinus == "-" {
            
            str = String(input.prefix(9))
        } else {
            //Take first 8 chars (no "-"
            str = String(input.prefix(8))
        }
        //Remove trailing "0"
        if str.contains(".") {
            while str.last! == "0" {
                str = String(str.dropLast())
            }
        }
        
        //Remove last "."
        if str.last == "." {
            str = String(str.dropLast())
        }
        
        return str
    }
    //Normalize double to string
    
    func normalize(input:Double) -> String {
        let str = String(input)
        return normalize(input:str)
    }
    
    
    
    //Process number entered

    @IBAction func numberField(_ sender: UIButton) {
        eql = false
        //Do not allow enter second "." if "." already presents in the label
        if sender.tag == 0 && (label.text!.contains(".")) {
            return
        }
        
        if performingMath == true {
            
            //Current mode Performing math switchs to Entering numbers mode
            
            performingMath = false
            previousNumber = screenNumber
            
            //Decemal "." clicked
            if sender.tag == 0  {
                
                //Update label
                
                label.text = "0."
                
                //Update screen number
                
                screenNumber = Double(label.text!)!
            } else {
                
                //Clicked other number (not ".") and this number is first one after mode switched to Entering numbers
                
                // Changed to var from let
                
                var str = String(sender.tag - 1)
                
                // Changed by adding normolize to cut lenght of the result
                str = normalize(input: str)
                
                //Set screennumber
                
                screenNumber = Double(str)!
                
                //Set label
                
                label.text = str
            }
        } else {
            //Current mode: Entering numbers
            
            if sender.tag == 0  {
                
                //"." entered
                
                if label.text! == "" {
                    
                    //If nothing entered in lable, default to "0"
                    
                    label.text="0"
                }
                
                //Append "." to string that already in label
                
                label.text=label.text!+"."
                
                //Update screennumber from label
                
                screenNumber = Double(label.text!)!
            } else
            {
                //Entered other number (not ".")
                
                //If label was not either "0" or "Error"
                if label.text != "0" && label.text != "-0" && label.text != "Error" {
                    
                    //Append number to string already in label
                    let str = String(label.text!+String(sender.tag-1))
                    
                    //str = normalize(input: str)
                    
                    //Update screenNumber
                    screenNumber = Double(normalize(input: str))
                    
                    //Update label
                    if str.prefix(1) == "-" {
                        label.text = String(str.prefix(9))
                    } else {
                        label.text = String(str.prefix(8))
                    }
                } else {
                    //Label was either "0" or "Error"
                    
                    //Update label with entered number
                    
                    label.text=String(sender.tag-1)
                    
                    //Update screenNumber with entered number
                    screenNumber = Double(label.text!)!
                }
            }
        }
    }
        //Process operation entered
    
    @IBAction func operationsField(_ sender: UIButton) {
        if sender.tag != 18 {
            eql = false
        }
        
        //"C" clicked
        if sender.tag == 11
        {
            //Initialize all data
            previousNumber = nil;
            screenNumber = 0;
            label.text = "0";
            operation = nil;
            performingMath = false;
            return
        }
        
        //Previous operation was error - do not allow enter operation
        if label.text == "Error" || label.text == "Overflow" {
            return
        }
        
        if sender.tag != 18 && operation == 18 {
            previousNumber = nil;
        }
        
        //"+/-" button clicked
        if sender.tag == 12 {
            screenNumber = -screenNumber!
            let str = normalize(input:screenNumber!)
            label.text = str
            return
        }
        // √
        if sender.tag == 13 && screenNumber! < 0 {
            //Set error
            previousNumber = nil
            screenNumber = nil
            label.text = "Error"
            performingMath = false
            return
        }else if operation == 14 && screenNumber! == 0 {
            //Set error
            previousNumber = nil
            screenNumber = nil
            label.text = "Error"
            performingMath = false
            return
        } else if sender.tag == 13 && screenNumber! >= 0 {
            let res = oper(num1:previousNumber, num2:screenNumber, operation:13)
            
            //Normalize result
            let str = normalize(input: res)
            
            //Normalize double
            let dbl = Double(str)
            
            //Update label
            label.text = str
            
            //Update screenNumber
            screenNumber = dbl
            operation = sender.tag
            
            //Set performanceMath flag
            performingMath = true
            
            return
        }
            //operation clicked
        else if sender.tag != 18 {
            if previousNumber == nil {
                previousNumber = screenNumber
                //Update operation
                operation = sender.tag
                performingMath = true
                return
            }
            if operation == nil {
                operation = sender.tag
                return
            }
            let res = oper(num1:previousNumber, num2:screenNumber, operation:operation!)
            if res > 99999999 || res < -99999999 || (res > 0 && res < 0.000001) || (res < 0 && res > -0.000001 ) {
                //Set error
                previousNumber = nil
                screenNumber = nil
                label.text = "Overflow"
                performingMath = false
                return
            }
            //Normalize result
            let str = normalize(input: res)
            
            //Normalize double
            let dbl = Double(str)
            //Update label
            label.text = str
            
            //Update previousNumber
            previousNumber = nil
            
            //Update screenNumber
            screenNumber = dbl
            
            //Update operation
            operation = sender.tag
            
            //Set performanceMath flag
            performingMath = true
            return
            
        } else
        {
            if previousNumber == nil {
                previousNumber = screenNumber
                //Update operation
                performingMath = true
            }
            if operation == nil {
                return
            }
            let res = oper(num1:previousNumber, num2:screenNumber, operation:operation!)
            if res > 99999999 || res < -99999999 || (res > 0 && res < 0.000001) || (res < 0 && res > -0.000001 ) {
                //Set error
                previousNumber = nil
                screenNumber = nil
                label.text = "Overflow"
                performingMath = false
                return
            }            //Normalize result
            var str = normalize(input: res)
            
            //Normalize double
            let dbl = Double(str)
            
            //Update label
            label.text = str
            
            if !eql {
                //Update previousNumber
                previousNumber = screenNumber
                eql = true
            }
            
            //Update screenNumber
            screenNumber = dbl
            
            //Update operation
            //operation = sender.tag
            
            //Set performanceMath flag
            performingMath = true
            
            if operation! == 16 {
                previousNumber = -previousNumber!
                operation = 17
            }
            
            if operation! == 14 {
                previousNumber = 1 / previousNumber!
                operation = 15
            }
            
            return
        }
    }
    
    func operationToLabel(tag:Int) -> String {
        switch tag {
        case 13:
            //Square root
            return "√"
        case 14:
            //Division
            return "/"
        case 15:
            //Multiplication
            return "X"
        case 16:
            //Subtraction
            return "-"
        case 17:
            //Sum
            return "+"
        case 20:
            //tan
            return "tan"
        case 21:
            //cos
            return "cos"
        case 22:
            //sin
            return "sin"
        case 23:
            //x^2
            return "x^2"
        case 24:
            //x^3
            return "x^3"
        case 25:
            //10^n
            return "10^n"
        default:
            return ""
        }
    }
    
    
    func oper(num1: Double?, num2: Double?, operation:Int) -> Double {
        var res: Double = 0
        switch operation {
        case 13:
            //Square root
            //res = num1!.squareRoot()
            res = num2!.squareRoot()
            break
        case 14:
            //Division
            res = Double(num1!) / Double(num2!)
            break;
        case 15:
            //Multiplication
            res = Double(num1!) * Double(num2!)
            break;
        case 16:
            //Subtraction
            res = Double(num1!) - Double(num2!)
            break;
        case 17:
            //Sum
            res = Double(num1!) + Double(num2!)
            break;
        case 20:
            //tan
            res = tan(Double(num2!))
            break;
        case 21:
            //cos
            res = cos(Double(num2!))
            break;
        case 22:
            //sin
            res = sin(Double(num2!))
            break;
        case 23:
            //x^2
            res = pow(Double(num2!), 2)
            break;
        case 24:
            //x^3
            res = pow(Double(num2!), 3)
            break;
        case 25:
            //10^n
            res = pow(10, Double(num2!))

        
        default:
            res = num2!
        }
        return res
    }
}
