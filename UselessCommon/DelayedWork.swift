//
//  DelayedWork.swift
//  Common
//
//  Created by Manny Martins on 1/12/16.
//  Copyright © 2016 Useless Robot. All rights reserved.
//

public class DelayedWork {
    
    private let delay: Float
    private let work: () -> Void
    private(set) var finished: Bool
    
    public init(delay: Float, work: @escaping () -> Void) {
        self.delay = delay
        self.work = work
        self.finished = false
    }
    
    private var elapsed: Float = 0.0
    
    public func update(_ dt: Float) {

        guard self.finished == false else {
            return
        }
        
        self.elapsed += dt
        if self.elapsed > self.delay {
            work()
        }
        
    }
    
}
