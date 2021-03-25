//
//  Questions.swift
//  FunTimes
//
//  Created by Marjo Salo on 16/03/2021.
//

import Foundation

struct Table {
    
    var factorA: Int
    var factorB: Int
    var product: Int {
        factorA * factorB
    }
    var level: Int { 
        switch (factorA, factorB) {
        case (2, 8), (8, 2), (2, 12), (12, 2): return 2
        case (1, _), (_, 1), (2, _), (_, 2), (10, _), (_, 10): return 1
        case (7, _), (_, 7), (8, _), (_, 8), (12, _), (_, 12): return 3
        default: return 2
        }
    }
}
    
struct Questions {
    
    var table = [Table]()
    
    mutating func getAll() {
        
        for numberA in 1...12 {
            for numberB in 1...12 {
                table.append(Table(factorA: numberA, factorB: numberB))
            }
        }
    }
}
