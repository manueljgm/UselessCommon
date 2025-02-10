//
//  Clamp.swift
//  Common
//
//  Created by Manny Martins on 11/18/15.
//  Copyright © 2015 Useless Robot. All rights reserved.
//

public func clamp<T: Comparable>(_ value: T, lower: T, upper: T) -> T {
    return min(max(value, lower), upper)
}
