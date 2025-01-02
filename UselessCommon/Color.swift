//
//  Color.swift
//  UselessCommon
//
//  Created by Manny Martins on 1/2/25.
//  Copyright © 2025 Useless Robot. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
extension Color {
    public func luminance() -> Double {
        let uiColor = UIColor(self)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: nil)
        return 0.2126 * Double(r) + 0.7152 * Double(g) + 0.0722 * Double(b)
    }
    
    public func isBright() -> Bool {
        return luminance() > 0.5
    }
    
    public func adaptedTextColor() -> Color {
        return isBright() ? .black : .white
    }
}
