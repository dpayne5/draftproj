//
//  ManaFont.swift
//  draftproj
//
//  Created by Dusty Payne on 5/5/19.
//  Copyright © 2019 Dusty Payne. All rights reserved.
//

import Foundation


class manaFONT {
    let manafont = "mana"
    
    
    let toUTF = ["{W}": "\u{e600}",
                 "{U}": "\u{e601}",
                 "{B}": "\u{e602}",
                 "{R}": "\u{e603}",
                 "{G}": "\u{e604}",
                 "{0}": "\u{e605}",
                 "{1}": "\u{e606}",
                 "{2}": "\u{e607}",
                 "{3}": "\u{e608}",
                 "{4}": "\u{e609}",
                 "{5}": "\u{e60a}",
                 "{6}": "\u{e60b}",
                 "{7}": "\u{e60c}",
                 "{8}": "\u{e60d}",
                 "{9}": "\u{e60e}",
                 "{X}": "\u{e615}",
                 "{T}": "\u{e61a}",
                 "{half}": "\u{e902}",
                 ]
    
    
    
    
    func STS(s : String) -> String { 
        
        var returnString = s
        let pattern = "\\{[A-Z|0-9]?\\}"
        let regex = try! NSRegularExpression(pattern: pattern)
        var nsString = returnString as NSString
        
        var results = regex.matches(in: returnString, range: NSRange(location: 0, length: nsString.length))
        
        
        
        while results.count != 0 {
            
            var begOfWord = returnString.index(returnString.startIndex, offsetBy: results[0].range.lowerBound)
            var endofWord = returnString.index(returnString.startIndex, offsetBy: results[0].range.upperBound)
            
            var firstPart = returnString.startIndex..<begOfWord
            var word = begOfWord..<endofWord
            var lastPart = endofWord..<returnString.endIndex
            
            
            print(returnString[firstPart])
            print(returnString[word])
            print(returnString[lastPart])
            
            
            returnString = returnString[firstPart] + toUTF[String(returnString[word])]! /* placeholder for the dictionary item!*/ + returnString[lastPart]
            
            nsString = returnString as NSString
            results = regex.matches(in: returnString, range: NSRange(location: 0, length: nsString.length))
            
        }
        
        
        return returnString
        
    }
}
