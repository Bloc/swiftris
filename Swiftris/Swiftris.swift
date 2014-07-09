let NumColumns:Int = 10
let NumRows:Int = 20

let StartingColumn:Int = 4
let StartingRow:Int = NumRows - 1

protocol SwiftrisDelegate {
    func gameDidEnd(swiftris: Swiftris)
    func gameDidBegin(swiftris: Swiftris, newShape:Shape)
    func gamePieceDidLand(swiftris: Swiftris, landedShape:Shape)
}

class Swiftris {
    var blockArray:Array2D<Block?>
    
    var fallingShape:Shape?
    
    var delegate:SwiftrisDelegate?
    
    var score:Int = 0
    
    init() {
        fallingShape = nil
        blockArray = Array2D<Block?>(columns: NumColumns, rows: NumRows)
    }
    
    func beginGame() {
        fallingShape = newShape()
        delegate?.gameDidBegin(self, newShape:fallingShape!)
    }
    
    func newShape() -> Shape {
        fallingShape = nil
        fallingShape = Shape.random(StartingRow, startingCol: StartingColumn)
        if detectOverlap() || detectTouch() {
            endGame()
        }
        return fallingShape!
    }
    
    func dropShape() {
        // TODO
    }
    
    func letShapeFall() {
        fallingShape?.lowerShapeByOneRow()
        if detectTouch() {
            delegate?.gamePieceDidLand(self, landedShape: fallingShape!)
        }
    }
    
    func settleShape() {
        if let shape = fallingShape {
            for block in shape.blocks {
                blockArray[block.column, block.row] = block
            }
        }
    }
    
    // Private
    func detectOverlap() -> Bool {
        if let shape = fallingShape {
            for block in shape.blocks {
                if let collidingBlock = blockArray[block.column, block.row] {
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
                if (bottomBlock.row == 0) {
                    return true
                } else if let blockBelow = blockArray[bottomBlock.column, bottomBlock.row - 1] {
                    return true
                }
            }
        }
        return false
    }
    
    func endGame() {
        // TODO what else?
        delegate?.gameDidEnd(self)
    }
}