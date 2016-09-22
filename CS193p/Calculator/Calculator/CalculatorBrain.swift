//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Deeksha Prabhakar on 7/3/16.
//  Copyright © 2016 Deeksha Prabhakar. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    private var accumulator = 0.0
    
    var result: Double {
        get {
            return accumulator
        }
    }
    
    private struct PendingBinaryOperationInfo {//no initializers, for structs default initializer is all of its vars
        var binaryFunction: ((Double, Double) -> Double)
        var firstOperand: Double
        var symbol: String
    }
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
        case ClearAll
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    var description = ""
    var isPartialResult: Bool {
        get {
            if pending != nil {
                return true
            }
            else {
                return false
            }
        }
    }
    
    
    func setOperand(operand: Double)
    {
        accumulator = operand;
    }
    
    private var operations:Dictionary<String, Operation> = [
        "sin": Operation.UnaryOperation(sin),
        "cos": Operation.UnaryOperation(cos),
        "tan":Operation.UnaryOperation(tan),
        "e": Operation.Constant(M_E),
        "π": Operation.Constant(M_PI),
        "√": Operation.UnaryOperation(sqrt),
        "AC": Operation.ClearAll,
        "+∕−": Operation.UnaryOperation({ -$0 }),
        "%": Operation.UnaryOperation({ $0 / 100 }),
        "÷": Operation.BinaryOperation({ $0 / $1 }),
        "×": Operation.BinaryOperation({ $0 * $1 }),//Operation.BinaryOperation({(op1: Double, op2: Double) -> Double in return op1 * op2 }), closure can default args $0, $1 ..
        "−": Operation.BinaryOperation({ $0 - $1 }),
        "+": Operation.BinaryOperation({ $0 + $1 }),
        "=": Operation.Equals
    ]
    
    
    func performOperation(symbol: String)
    {
        if let operation = operations[symbol]{
            switch operation {
            case .Constant(let associatedConstantValue):
                description = symbol
                accumulator = associatedConstantValue
                break
            case .UnaryOperation(let associatedFunction) :
                description = symbol + " " + String(accumulator)
                accumulator = associatedFunction(accumulator)
                break
            case .BinaryOperation(let function):
                if(pending == nil){
                    description = String(accumulator) + symbol + "..."
                }
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator, symbol: symbol)
                break
            case .Equals:
                executePendingBinaryOperation()
                break
            case .ClearAll:
                pending = nil
                accumulator = 0
                description = ""
                break
            }
        }
    }
    
    private func executePendingBinaryOperation(){
        if(pending != nil){
            description = String(pending!.firstOperand) + " " + pending!.symbol + " " + String(accumulator) + " = "
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
}
