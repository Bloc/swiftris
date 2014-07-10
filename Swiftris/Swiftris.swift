let NumColumns:Int = 10
let NumRows:Int = 20

let StartingColumn:Int = 4
let StartingRow:Int = NumRows - 1

protocol SwiftrisDelegate {
    func gameDidEnd(swiftris: Swiftris)
    func gameDidBegin(swiftris: Swiftris)
    func gamePieceDidLand(swiftris: Swiftris)
    func gamePieceDidMove(swiftris: Swiftris)
}

class Swiftris {
    var blockArray:Array2D<Block>
    
    var fallingShape:Shape?
    
    var delegate:SwiftrisDelegate?
    
    var score:Int = 0
    
    var gameOver:Bool
    
    init() {
        gameOver = true
        fallingShape = nil
        blockArray = Array2D<Block>(columns: NumColumns, rows: NumRows)
    }
    
    func beginGame() {
        gameOver = false
        fallingShape = newShape()
        delegate?.gameDidBegin(self)
    }
    
    func newShape() -> Shape? {
        fallingShape = Shape.random(StartingRow, startingCol: StartingColumn)
        if detectIllegalPlacement() {
            while detectOverlappingBlocks() {
                fallingShape?.raiseShapeByOneRow()
            }
            endGame()
            return nil
        }
        return fallingShape
    }
    
    func dropShape() {
        if let shape = fallingShape {
            let startingRow = shape.row
            while detectIllegalPlacement() == false {
                shape.lowerShapeByOneRow()
            }
            shape.raiseShapeByOneRow()
            if shape.row != startingRow {
                delegate?.gamePieceDidMove(self)
            }
            settleShape()
            delegate?.gamePieceDidLand(self)
        }
    }
    
    func letShapeFall() {
        fallingShape?.lowerShapeByOneRow()
        if detectIllegalPlacement() {
            fallingShape?.raiseShapeByOneRow()
            settleShape()
            delegate?.gamePieceDidLand(self)
        } else if detectTouch() {
            delegate?.gamePieceDidMove(self)
            settleShape()
            delegate?.gamePieceDidLand(self)
        } else {
            delegate?.gamePieceDidMove(self)
        }
    }
    
    func rotateShape() {
        fallingShape?.rotateClockwise()
        if detectIllegalPlacement() {
            fallingShape?.rotateCounterClockwise()
        } else {
            delegate?.gamePieceDidMove(self)
        }
    }

    
    func moveShapeLeft() {
        fallingShape?.shiftLeftByOneColumn()
        if detectIllegalPlacement() {
            fallingShape?.shiftRightByOneColumn()
            return
        }
        delegate?.gamePieceDidMove(self)
    }
    
    func moveShapeRight() {
        fallingShape?.shiftRightByOneColumn()
        if detectIllegalPlacement() {
            fallingShape?.shiftLeftByOneColumn()
            return
        }
        delegate?.gamePieceDidMove(self)
    }
    
    // Private
    func settleShape() {
        if let shape = fallingShape {
            for block in shape.blocks {
                blockArray[block.column, block.row] = block
            }
        }
    }
    
    // Private
    func detectIllegalPlacement() -> Bool {
        if detectOutOfBounds() || detectOverlappingBlocks() {
            return true;
        }
        return false
    }
    
    // Private
    func detectOutOfBounds() -> Bool {
        if let shape = fallingShape {
            for block in shape.blocks {
                if block.column < 0 || block.column >= NumColumns
                    || block.row < 0 || block.row >= NumRows {
                    return true
                }
            }
        }
        return false
    }
    
    // Private
    func detectOverlappingBlocks() -> Bool {
        if let shape = fallingShape {
            for block in shape.blocks {
                if block.column < 0 || block.column >= NumColumns
                    || block.row < 0 || block.row >= NumRows {
                        continue
                }
                if blockArray[block.column, block.row] != nil {
                    return true
                }
            }
        }
        return false
    }
    
    // Private
    func detectTouch() -> Bool {
        if let shape = fallingShape {
            for bottomBlock in shape.bottomBlocks {
                if bottomBlock.row == 0 {
                    return true
                } else if let blockBelow = blockArray[bottomBlock.column, bottomBlock.row - 1] {
                    return blockArray[bottomBlock.column, bottomBlock.row] == nil
                }
            }
        }
        return false
    }
    
    // Private
    func endGame() {
        gameOver = true
        delegate?.gameDidEnd(self)
    }
}