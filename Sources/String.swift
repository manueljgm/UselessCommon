//
//  String.swift
//  Common
//
//  Created by Manny Martins on 12/26/16.
//  Copyright © 2016 Useless Robot. All rights reserved.
//

import Foundation

extension String {

    public var localizable: String { NSLocalizedString(self, comment: "") }
    
    public func equalsPattern(_ regexPattern: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: regexPattern)
            let range = (self as NSString).range(of: self)
            let matchRange = regex.rangeOfFirstMatch(in: self, range: range)
            return matchRange.location == 0 && matchRange.length == range.length
        } catch let error {
            print("Invalid Regular Expression: \(error.localizedDescription)")
            return false
        }
    }
    
    public func matches(forRegexPattern pattern: String) -> [String] {
        do {
            let s = self as NSString
            let regex = try NSRegularExpression(pattern: pattern)
            let results = regex.matches(in: self, range: NSRange(location: 0, length: s.length))
            return results.map { s.substring(with: $0.range)}
        } catch let error {
            print("Invalid Regular Expression: \(error.localizedDescription)")
            return []
        }
    }
    
}
