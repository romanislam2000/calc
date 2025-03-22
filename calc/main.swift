//
//  main.swift
//  calc
//
//  Created by Jesse Clark on 12/3/18.
//  Copyright © 2018 UTS. All rights reserved.
//

import Foundation

let args = ProcessInfo.processInfo.arguments.dropFirst()

if args.isEmpty {
    print("Usage: ./calc number operator number [operator number]...")
    exit(1)
}
let calculator = Calculator()
let result = calculator.calculate(args: Array(args))
print(result)
