//
//  GameScene.swift
//  Swiftris
//
//  Created by Stanley Idesis on 7/8/14.
//  Copyright (c) 2014 Bloc. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    let TickLengthMillis = NSTimeInterval(600)
    let BlockSize:CGFloat = 16.0
    
    let gameLayer = SKNode()
    let shapeLayer = SKNode()
    
    var tick:(() -> ())?
    
    var swiftris:Swiftris!
    
    var lastTick:NSDate?
    
    init(size: CGSize) {
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let background = SKSpriteNode(imageNamed: "Background")
        addChild(background)
        
        addChild(gameLayer)
        
        let layerPosition = CGPoint(
            x: -BlockSize * CGFloat(NumColumns) / 2,
            y: -BlockSize * CGFloat(NumRows) / 2)
        
        shapeLayer.position = layerPosition
        gameLayer.addChild(shapeLayer)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if lastTick == nil {
            lastTick = NSDate.date()
        } else {
            var timePassed = lastTick!.timeIntervalSinceNow * -1000.0
            if timePassed > TickLengthMillis {
                lastTick = NSDate.date()
                tick?()
            }
        }
    }
    
    func addSpritesForShape(shape:Shape) {
        for block in shape.blocks {
            let sprite = SKSpriteNode(imageNamed: block.spriteName)
            sprite.position = pointForColumn(block.column, row:block.row)
            shapeLayer.addChild(sprite)
            block.sprite = sprite
        }
    }
    
    func pointForColumn(column: Int, row: Int) -> CGPoint {
        let x: CGFloat = (CGFloat(column) * BlockSize) + (BlockSize / 2)
        let y: CGFloat = (CGFloat(row) * BlockSize) + (BlockSize / 2)
        return CGPointMake(x, y)
    }
    
    func redrawShape(shape:Shape, completion:() -> ()) {
        for (idx, block) in enumerate(shape.blocks) {
            let sprite = block.sprite!
            let moveTo = pointForColumn(block.column, row:block.row)
            let moveToAction:SKAction = SKAction.moveTo(moveTo, duration: 0.05)
            moveToAction.timingMode = .EaseOut
            if idx == 0 {
                sprite.runAction(moveToAction, completion)
            } else {
                sprite.runAction(moveToAction)
            }
        }
    }
}
