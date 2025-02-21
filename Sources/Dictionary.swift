//
//  Dictionary.swift
//  UselessCommon
//
//  Created by Manny Martins on 9/22/16.
//  Copyright © 2016 Useless Robot. All rights reserved.
//

extension Dictionary where Key : ExpressibleByStringLiteral {
    
    public subscript(ignoreCase searchKey: Key) -> Value? {
        get {
            for key in self.keys {
                if String(describing: key).caseInsensitiveCompare(String(describing: searchKey)) == .orderedSame {
                    return self[key]
                }
            }
            return nil
        }
    }
    
}
