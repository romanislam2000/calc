//
//  Calculator.swift
//  calc
//
//  Created by Jacktator on 31/3/20.
//  Copyright © 2020 UTS. All rights reserved.
//

import Foundation

class Calculator {
    
    // MARK: - Arithmetic Operations with Overflow Check
    func add(_ a: Int, _ b: Int) -> Int {
        let result = a + b
        checkOverflow(result)
        return result
    }

    func subtract(_ a: Int, _ b: Int) -> Int {
        let result = a - b
        checkOverflow(result)
        return result
    }

    func multiply(_ a: Int, _ b: Int) -> Int {
        let result = a * b
        checkOverflow(result)
        return result
    }

    func divide(_ a: Int, _ b: Int) -> Int {
        if b == 0 {
            fputs("Error: Cannot divide by zero\n", stderr)
            exit(1)
        }
        let result = a / b
        checkOverflow(result)
        return result
    }

    func modulo(_ a: Int, _ b: Int) -> Int {
        if b == 0 {
            fputs("Error: Cannot modulo by zero\n", stderr)
            exit(1)
        }
        let result = a % b
        checkOverflow(result)
        return result
    }

    // MARK: - Overflow Protection (Int32 Boundaries)
    func checkOverflow(_ result: Int) {
        if result > Int32.max || result < Int32.min {
            fputs("Error: Integer overflow\n", stderr)
            exit(1)
        }
    }

    // MARK: - Main Calculate Function
    func calculate(args: [String]) -> String {
        if args.count < 1 || args.count % 2 == 0 {
            fputs("Error: Invalid input format\n", stderr)
            exit(1)
        }

        var numbers: [Int] = []
        var operators: [String] = []

        for (index, token) in args.enumerated() {
            let trimmed = token.trimmingCharacters(in: .whitespaces)

            if index % 2 == 0 {
                // Expect number (can be signed)
                if let number = Int(trimmed), number >= Int32.min, number <= Int32.max {
                    numbers.append(number)
                } else {
                    fputs("Error: Invalid or out-of-bounds number '\(trimmed)'\n", stderr)
                    exit(1)
                }
            } else {
                // Expect operator
                if ["+", "-", "x", "/", "%"].contains(trimmed) {
                    operators.append(trimmed)
                } else {
                    fputs("Error: Invalid operator '\(trimmed)'\n", stderr)
                    exit(1)
                }
            }
        }

        // Step 1: Handle x / %
        var i = 0
        while i < operators.count {
            if ["x", "/", "%"].contains(operators[i]) {
                let lhs = numbers[i]
                let rhs = numbers[i + 1]
                let result: Int

                switch operators[i] {
                    case "x": result = multiply(lhs, rhs)
                    case "/": result = divide(lhs, rhs)
                    case "%": result = modulo(lhs, rhs)
                    default: continue
                }

                numbers[i] = result
                numbers.remove(at: i + 1)
                operators.remove(at: i)
            } else {
                i += 1
            }
        }

        // Step 2: Handle + and -
        var result = numbers[0]
        for j in 0..<operators.count {
            let rhs = numbers[j + 1]
            switch operators[j] {
                case "+": result = add(result, rhs)
                case "-": result = subtract(result, rhs)
                default:
                    fputs("Error: Unexpected operator in final pass\n", stderr)
                    exit(1)
            }
        }

        return String(result)
    }
}
