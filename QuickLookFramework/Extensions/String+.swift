//
//  String+.swift
//  QuickLookFramework
//
//  Created by Mario on 10/09/2019.
//  Copyright © 2019 Mario Iannotta. All rights reserved.
//

import Foundation

extension String {
    
    subscript(bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    subscript(bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
    
    subscript(at: Int) -> String {
        return String(self[index(startIndex, offsetBy: at)])
    }
    
}
