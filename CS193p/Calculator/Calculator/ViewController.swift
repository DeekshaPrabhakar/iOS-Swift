//
//  ViewController.swift
//  Calculator
//
//  Created by Deeksha Prabhakar on 7/3/16.
//  Copyright © 2016 Deeksha Prabhakar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!//initially set to nil, implicitly unwrapped optional
    
    var userIsInMiddleOfTyping = false //variables should always be initialized
    
    
    @IBAction func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if(userIsInMiddleOfTyping){
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        }
        else{
            display.text = digit
        }
        userIsInMiddleOfTyping = true
    }
    
    @IBAction func performOperation(sender: UIButton) {
        userIsInMiddleOfTyping = false
        if let mathematicalSymbol = sender.currentTitle { //mathematicalSymbol only exists in the current scope
            if(mathematicalSymbol == "π"){
                display.text = String(M_PI)
            }
        }
    }
}

