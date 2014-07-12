let NumColumns:Int = 10
let NumRows:Int = 20

let StartingColumn:Int = 4
let StartingRow:Int = NumRows - 1

let PointsPerLine = 10

protocol SwiftrisDelegate {
    func gameDidEnd(swiftris: Swiftris)
    func gameDidBegin(swiftris: Swiftris)
    func gamePieceDidLand(swiftris: Swiftris)
    func gamePieceDidMove(swiftris: Swiftris)
    func gamePieceDidDrop(swiftris: Swiftris)
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
        fallingShape = Shape.random(StartingColumn, startingRow: StartingRow)
        if detectIllegalPlacement() {
            while detectOverlappingBlocks() {
                self.fallingShape?.raiseShapeByOneRow()
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
            settleShape()
            delegate?.gamePieceDidDrop(self)
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
    
    func removeCompletedLines() -> (linesRemoved: Array<Array<Block>>, fallenBlocks: Array<Array<Block>>) {
        var removedLines = Array<Array<Block>>()
        for row in 0..<NumRows {
            var rowOfBlocks = Array<Block>()
            for column in 0..<NumColumns {
                if let block = blockArray[column, row] {
                    rowOfBlocks.append(block)
                }
            }
            if rowOfBlocks.count == NumColumns {
                removedLines.append(rowOfBlocks)
                for block in rowOfBlocks {
                    blockArray[block.column, block.row] = nil
                }
            }
        }
        
        if removedLines.count == 0 {
            return ([], [])
        }
        
        var fallenBlocks = Array<Array<Block>>()
        for column in 0..<NumColumns {
            var fallenBlocksArray = Array<Block>()
            for row in removedLines[0][0].row + 1..<NumRows {
                if let block = blockArray[column, row] {
                    var newRow = row
                    while (newRow > 0 && blockArray[column, newRow - 1] == nil) {
                        newRow--
                    }
                    block.row = newRow
                    blockArray[column, row] = nil
                    blockArray[column, newRow] = block
                    fallenBlocksArray.append(block)
                }
            }
            if fallenBlocksArray.count > 0 {
                fallenBlocks.append(fallenBlocksArray)
            }
        }
        return (removedLines, fallenBlocks)
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
        return detectOutOfBounds() || detectOverlappingBlocks()
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
                if bottomBlock.row == 0 ||
                    blockArray[bottomBlock.column, bottomBlock.row - 1] != nil {
                    return true
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