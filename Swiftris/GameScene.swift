//
//  GameScene.swift
//  Swiftris
//
//  Created by Stanley Idesis on 7/8/14.
//  Copyright (c) 2014 Bloc. All rights reserved.
//

import SpriteKit

let BlockSize:CGFloat = 16.0

class GameScene: SKScene {
    let TickLengthMillis = NSTimeInterval(600)
    
    let gameLayer = SKNode()
    let shapeLayer = SKNode()
    
    var textureCache = Dictionary<String, SKTexture>()
    
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
        
        let color:UIColor = UIColor(red: CGFloat(255), green: CGFloat(255), blue: CGFloat(255), alpha: CGFloat(0.5))
        let map = SKSpriteNode(color: color, size:CGSizeMake(BlockSize * CGFloat(NumColumns), BlockSize * CGFloat(NumRows)))
        map.position = CGPoint(x:CGFloat(0), y:CGFloat(0))
        
        gameLayer.addChild(map)
        shapeLayer.position = layerPosition
        gameLayer.addChild(shapeLayer)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if lastTick == nil {
            return
        }
        var timePassed = lastTick!.timeIntervalSinceNow * -1000.0
        if timePassed > TickLengthMillis {
            lastTick = NSDate.date()
            tick?()
        }
    }
    
    func startTicking() {
        lastTick = NSDate.date()
    }
    
    func stopTicking() {
        lastTick = nil
    }
    
    func addShapeToScene(shape:Shape, completion:() -> ()) {
        for (idx, block) in enumerate(shape.blocks) {
            var texture = textureCache[block.spriteName]
            if texture == nil {
                texture = SKTexture(imageNamed: block.spriteName)
                textureCache[block.spriteName] = texture
            }
            let sprite = SKSpriteNode(texture: texture)
            sprite.position = pointForColumn(block.column, row:block.row + 2)
            shapeLayer.addChild(sprite)
            block.sprite = sprite
            
            // Animation
            sprite.alpha = 0
            let moveAction = SKAction.moveTo(pointForColumn(block.column, row: block.row), duration: NSTimeInterval(0.2))
            moveAction.timingMode = .EaseOut
            let fadeTo:CGFloat = block.row >= NumRows ? 0.5 : 1.0
            let fadeInAction = SKAction.fadeAlphaTo(fadeTo, duration: NSTimeInterval(0.4))
            fadeInAction.timingMode = .EaseOut
            sprite.runAction(SKAction.group([moveAction, fadeInAction]))
        }
        runAction(SKAction.waitForDuration(NSTimeInterval(0.4)), completion: completion)
    }
    
    func animateCollapsingLines(linesToRemove: Array<Array<Block>>, fallenBlocks: Array<Array<Block>>, completion:() -> ()) {
        // another behemoth…
        var longestDuration: NSTimeInterval = 0
        
        for (columnIdx, column) in enumerate(fallenBlocks) {
            for (blockIdx, block) in enumerate(column) {
                let newPosition = pointForColumn(block.column, row: block.row)
                let sprite = block.sprite!
                let delay = (NSTimeInterval(columnIdx) * 0.05) + (NSTimeInterval(blockIdx) * 0.05)
                let duration = NSTimeInterval(((sprite.position.y - newPosition.y) / BlockSize) * 0.1)
                let moveAction = SKAction.moveTo(newPosition, duration: duration)
                moveAction.timingMode = .EaseOut
                sprite.runAction(
                    SKAction.sequence([
                        SKAction.waitForDuration(delay),
                        moveAction]))
                longestDuration = max(longestDuration, duration + delay)
            }
        }
        
        // TODO remove previous
        for (rowIdx, row) in enumerate(linesToRemove) {
            for (blockIdx, block) in enumerate(row) {
                block.sprite!.runAction(SKAction.removeFromParent())
            }
        }
        
        runAction(SKAction.waitForDuration(longestDuration), completion:completion)
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
            sprite.runAction(moveToAction, completion: idx == 0 ? completion : nil)
        }
    }
}
