//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Deeksha Prabhakar on 7/3/16.
//  Copyright © 2016 Deeksha Prabhakar. All rights reserved.
//

import Foundation

/*
 //global function
 func multiply(op1: Double, op2: Double) -> Double {
 return op1 * op2
 }
 */

class CalculatorBrain
{
    private var accumulator = 0.0
    
    func setOperand(operand: Double)
    {
        accumulator = operand;
    }
    /*
     var operations:Dictionary<String, Double> = [
     "π": M_PI,
     "e": M_E,
     "√": sqrt(),//gives error
     "cos": cos
     ]
     */
    
    private var operations:Dictionary<String, Operation> = [
        "π": Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        "±": Operation.UnaryOperation({ -$0 }),
        "√": Operation.UnaryOperation(sqrt),
        "cos": Operation.UnaryOperation(cos),
        "×": Operation.BinaryOperation({ $0 * $1 }),//Operation.BinaryOperation({(op1: Double, op2: Double) -> Double in return op1 * op2 }), closure can default args $0, $1 ..
        "÷": Operation.BinaryOperation({ $0 / $1 }),
        "+": Operation.BinaryOperation({ $0 + $1 }),
        "−": Operation.BinaryOperation({ $0 - $1 }),
        "=": Operation.Equals
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    func performOperation(symbol: String)
    {
        if let operation = operations[symbol]{
            switch operation {
            case .Constant(let associatedConstantValue):
                accumulator = associatedConstantValue
                break
            case .UnaryOperation(let associatedFunction) :
                accumulator = associatedFunction(accumulator)
                break
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
                break
            case .Equals:
                executePendingBinaryOperation()
                break
            }
        }
        
        /*
         switch symbol {
         case "π":
         accumulator = M_PI
         case "√":
         accumulator = sqrt(accumulator)
         default:
         break
         }
         */
    }
    
    private func executePendingBinaryOperation(){
        if(pending != nil){
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private struct PendingBinaryOperationInfo {//no initializers, for structs default initializer is all of its vars
        var binaryFunction: ((Double, Double) -> Double)
        var firstOperand: Double
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
}
