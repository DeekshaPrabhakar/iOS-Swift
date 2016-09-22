//
//  ViewController.swift
//  Calculator
//
//  Created by Deeksha Prabhakar on 7/3/16.
//  Copyright © 2016 Deeksha Prabhakar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var display: UILabel!//initially set to nil, implicitly unwrapped optional
    
    @IBOutlet private weak var displayDescription: UILabel!
    
    private var userIsInMiddleOfTyping = false //variables should always be initialized
    
    //Computed Property
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()//infer
    
    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if(userIsInMiddleOfTyping) {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        }
        else {
            display.text = digit
        }
        userIsInMiddleOfTyping = true
       
    }
    
    
    @IBAction private func performOperation(sender: UIButton) {
        if userIsInMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle { //mathematicalSymbol only exists in the current scope
            brain.performOperation(mathematicalSymbol)
        }
        
        displayValue = brain.result
        displayDescription.text = brain.description
    }
}

