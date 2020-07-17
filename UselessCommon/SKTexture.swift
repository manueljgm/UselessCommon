//
//  SKTexture.swift
//  Common
//
//  Created by Manny Martins on 12/2/14.
//  Copyright (c) 2014 Useless Robot. All rights reserved.
//

import SpriteKit

public enum SKTextureSplitOrder {
    case rightDown
    case rightUp
    case leftDown
    case leftUp
}

extension SKTexture {
    
    public convenience init(imageNamed name: String, filteringMode: SKTextureFilteringMode) {
        self.init(imageNamed: name)
        self.filteringMode = filteringMode
    }
    
    public func split(bySize splitSize: CGSize, splitOrder: SKTextureSplitOrder = .rightDown) -> [(texture: SKTexture, offset: CGPoint, index: Int)] {
        let textureSize = self.size()
        guard splitSize.width <= textureSize.width && splitSize.height <= textureSize.height else {
            return [(texture: self, offset: CGPoint.zero, index: 0)]
        }
        
        let unitCoordinateSize = CGSize(
            width: splitSize.width / textureSize.width,
            height: splitSize.height / textureSize.height)
        var unitPosition = CGPoint.zero
        
        var index = 0
        var partials = [(texture: SKTexture, offset: CGPoint, index: Int)]()
        repeat {
            repeat {
                let texturePosition = CGPoint(
                    x: (splitOrder == .leftDown || splitOrder == .leftUp) ? 1.0 - unitCoordinateSize.width - unitPosition.x : unitPosition.x,
                    y: (splitOrder == .rightUp || splitOrder == .leftUp) ? unitPosition.y : 1.0 - unitCoordinateSize.height - unitPosition.y
                )

                let leftClipAmount = abs(min(texturePosition.x, 0.0))
                let rightClipAmount = abs(min(1.0 - (texturePosition.x + unitCoordinateSize.width), 0.0))
                let topClipAmount = abs(min(1.0 - (texturePosition.y + unitCoordinateSize.height), 0.0))
                let bottomClipAmount = abs(min(texturePosition.y, 0.0))
                
                let partial = SKTexture(rect: CGRect(origin: CGPoint(x: texturePosition.x + leftClipAmount,
                                                                     y: texturePosition.y + bottomClipAmount),
                                                     size: CGSize(width: unitCoordinateSize.width - leftClipAmount - rightClipAmount,
                                                                  height: unitCoordinateSize.height - bottomClipAmount - topClipAmount)),
                                        in: self)
                partials.append((texture: partial,
                                 offset: CGPoint(x: (texturePosition.x + leftClipAmount) * textureSize.width, y: (texturePosition.y + bottomClipAmount) * textureSize.height),
                                 index: index))
                
                unitPosition.x += unitCoordinateSize.width
                index += 1
                
            } while (1.0 - unitPosition.x) > (unitCoordinateSize.width * 0.01)

            unitPosition.x = 0.0
            unitPosition.y += unitCoordinateSize.height
            
        } while (1.0 - unitPosition.y) > (unitCoordinateSize.height * 0.01)
        
        return partials
    }
    
    public class func split(imageNamed name: String, bySize size: CGSize, splitOrder: SKTextureSplitOrder = .rightDown, filteringMode: SKTextureFilteringMode = .nearest) -> [(texture: SKTexture, offset: CGPoint, index: Int)] {
        guard let sourceImage = UIImage(named: name) else {
            return []
        }
        
        let sourceTexture = SKTexture(image: sourceImage)
        sourceTexture.filteringMode = filteringMode
        return sourceTexture.split(bySize: size, splitOrder: splitOrder)
    }
    
}
