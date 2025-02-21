//
//  SKTextureAtlas.swift
//  UselessCommon
//
//  Created by Manny Martins on 12/14/15.
//  Copyright © 2015 Useless Robot. All rights reserved.
//

import SpriteKit

extension SKTextureAtlas {
    
    public convenience init(named name: String, filteringMode: SKTextureFilteringMode) {
        self.init(named: name)
        if textureNames.count > 0 {
            textureNamed(textureNames.last!).filteringMode = filteringMode
        }
    }

    public class func textureAtlases(named names: [String], filteringMode: SKTextureFilteringMode) -> [String: SKTextureAtlas] {
        return Set(names).reduce([String: SKTextureAtlas]()) {
                var textureAtlases = $0
                textureAtlases[$1] = SKTextureAtlas(named: $1, filteringMode: filteringMode)
                return textureAtlases
        }
    }
    
}
