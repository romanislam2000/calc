//
//  Calculator.swift
//  calc
//
//  Created by Jacktator on 31/3/20.
//  Copyright © 2020 UTS. All rights reserved.
//

import Foundation

class Calculator {
    
    func add(_ a: Int, _ b: Int) -> Int {
        return a + b
    }

    func subtract(_ a: Int, _ b: Int) -> Int {
        return a - b
    }

    func multiply(_ a: Int, _ b: Int) -> Int {
        return a * b
    }

    func divide(_ a: Int, _ b: Int) -> Int? {
        if b == 0 {
            print("Error: Cannot divide by zero")
            return nil
        }
        return a / b
    }

    func modulo(_ a: Int, _ b: Int) -> Int? {
        if b == 0 {
            print("Error: Cannot perform modulo by zero")
            return nil
        }
        return a % b
    }

    func calculate(args: [String]) -> String {
        guard args.count >= 3 else {
            return "Error: Invalid input. Format should be: number operator number"
        }

        var values: [Int] = []
        var operators: [String] = []
        
        for (index, arg) in args.enumerated() {
            if index % 2 == 0 {
                if let num = Int(arg) {
                    values.append(num)
                } else {
                    return "Error: Invalid number \(arg)"
                }
            } else {
                if ["+", "-", "x", "/", "%"].contains(arg) {
                    operators.append(arg)
                } else {
                    return "Error: Invalid operator \(arg)"
                }
            }
        }

        // First pass: Handle multiplication, division, modulo first
        var i = 0
        while i < operators.count {
            if ["x", "/", "%"].contains(operators[i]) {
                let lhs = values[i]
                let rhs = values[i + 1]
                let result: Int?

                switch operators[i] {
                case "x": result = multiply(lhs, rhs)
                case "/": result = divide(lhs, rhs)
                case "%": result = modulo(lhs, rhs)
                default: result = nil
                }

                if let res = result {
                    values[i] = res
                    values.remove(at: i + 1)
                    operators.remove(at: i)
                } else {
                    return "Error: Calculation failed"
                }
            } else {
                i += 1
            }
        }

        // Second pass: Handle addition and subtraction
        var finalResult = values[0]
        for j in 0..<operators.count {
            let rhs = values[j + 1]
            switch operators[j] {
            case "+": finalResult = add(finalResult, rhs)
            case "-": finalResult = subtract(finalResult, rhs)
            default: return "Error: Unexpected error"
            }
        }

        return String(finalResult)
    }
}

