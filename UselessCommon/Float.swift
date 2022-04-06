//
//  Float.swift
//  UselessCommon
//
//  Created by Manny Martins on 4/3/22.
//  Copyright © 2022 Useless Robot. All rights reserved.
//

extension Float {
    
    public func isFuzzyEqual(to other: Float, epsilon: Float) -> Bool {
        return abs(self - other) < epsilon
    }
    
}
