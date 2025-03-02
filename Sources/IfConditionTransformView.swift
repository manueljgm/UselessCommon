//
//  IfConditionTransformView.swift
//  UselessCommon
//
//  Created by Manny Martins on 3/1/25.
//  Copyright © 2025 Useless Robot. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
extension View {
    
    @ViewBuilder public func `if`<T: View>(_ condition: Bool, transform: (Self) -> T) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
}
