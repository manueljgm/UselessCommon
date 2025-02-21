//
//  SKTexture.swift
//  UselessCommon
//
//  Created by Manny Martins on 12/2/14.
//  Copyright (c) 2014 Useless Robot. All rights reserved.
//

import CoreImage
import SpriteKit

public enum SKTextureGradientDirection {
    case down
    case downLeft
    case downRight
    case right
}

public enum SKTextureSplitOrder {
    case rightDown
    case rightUp
    case leftDown
    case leftUp
}

extension SKTexture {
    
    public convenience init(size: CGSize, color1: CIColor, color2: CIColor, direction: SKTextureGradientDirection = .down) {
        guard let gradientFilter = CIFilter(name: "CILinearGradient") else {
            self.init()
            return
        }
        
        gradientFilter.setDefaults()
        
        var startVector: CIVector
        var endVector: CIVector
        
        switch direction {
        case .down:
            startVector = CIVector(x: size.width / 2, y: size.height)
            endVector = CIVector(x: size.width / 2, y: 0)
        case .downLeft:
            startVector = CIVector(x: size.width, y: size.height)
            endVector = CIVector(x: 0, y: 0)
        case .downRight:
            startVector = CIVector(x: 0, y: size.height)
            endVector = CIVector(x: size.width, y: 0)
        case .right:
            startVector = CIVector(x: 0, y: size.height / 2)
            endVector = CIVector(x: size.width, y: size.height / 2)
        }
        
        gradientFilter.setValue(startVector, forKey: "inputPoint0")
        gradientFilter.setValue(color1, forKey: "inputColor0")
        gradientFilter.setValue(endVector, forKey: "inputPoint1")
        gradientFilter.setValue(color2, forKey: "inputColor1")
        
        let coreImageContext = CIContext(options: nil)
        guard let outputImage = gradientFilter.outputImage,
              let cgimg = coreImageContext.createCGImage(outputImage, from: CGRect(x: 0, y: 0, width: size.width, height: size.height)) else {
            self.init()
            return
        }

        self.init(cgImage: cgimg)
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
    
    public static func split(imageNamed name: String, bySize size: CGSize, splitOrder: SKTextureSplitOrder = .rightDown) -> [(texture: SKTexture, offset: CGPoint, index: Int)] {
        guard let sourceImage = UIImage(named: name) else {
            return []
        }
        
        let sourceTexture = SKTexture(image: sourceImage)
        return sourceTexture.split(bySize: size, splitOrder: splitOrder)
    }
    
}
