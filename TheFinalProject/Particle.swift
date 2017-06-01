//
//  Particle.swift
//  TheFinalProject
//
//  Created by Michael Castillo on 5/31/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import UIKit
import SpriteKit

class Particle {
    
    var meMeme = SKEmitterNode()
    meMeme.name = "MeMeMe Label animate"
    meMeme.particleTexture! = SKTexture.textureWithImageNamed("PARTICLE.PNG")
    meMeme.position = self.position
    // self is a SKScene
    meMeme.particlePosition = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
    // self is a SKScene
    meMeme.particlePositionRange = CGVectorMake(1.0, 1)
    meMeme.emissionAngle = 1.75 * M_PI
    meMeme.emissionAngleRange = 1.96 * M_PI
    meMeme.particleBirthRate = 10.00
    meMeme.numParticlesToEmit = 9
    meMeme.particleBlendMode = .Alpha
    meMeme.particleColorBlendFactor = 1.000
    meMeme.particleColorBlendFactorRange = 0.208
    meMeme.particleColorBlendFactorSpeed = 0.000
    meMeme.xAcceleration = 0.000
    meMeme.yAcceleration = 0.000
    meMeme.particleColor = UIColor(red: 0.89, green: 0.09, blue: 0.20, alpha: 1.00)

enumerateChildNodes(withName: "MeMeMe Label animate", usingBlock: {(_ node: SKNode, _ stop: Bool) -> Void in
    self.enumerateChildNodesWithName("MeMeMe Label animate", usingBlock: {(node: SKNode, stop: Bool) -> Void in
    var tmpNode = (node as! SKEmitterNode)
    tmpNode.particlePositionRange = CGVectorMake(1.0, 1)
    tmpNode.emissionAngle = 1.75 * M_PI
    tmpNode.emissionAngleRange = 1.96 * M_PI
    tmpNode.particleBirthRate = 10.00
    tmpNode.numParticlesToEmit = 9
    tmpNode.particleBlendMode = .Alpha
    tmpNode.particleColorBlendFactor = 1.000
    tmpNode.particleColorBlendFactorRange = 0.208
    tmpNode.particleColorBlendFactorSpeed = 0.000
    tmpNode.xAcceleration = 0.000
    tmpNode.yAcceleration = 0.000
    tmpNode.particleColor = UIColor(red: 0.89, green: 0.09, blue: 0.20, alpha: 1.00)
    tmpNode.particleColorRedSpeed = 0.655
    tmpNode.particleColorGreenSpeed = 0.448
}
