let NumColumns = 10
let NumRows = 20

let StartingColumn = 4
let StartingRow = 19

let PreviewColumn = 12
let PreviewRow = 18

let PointsPerLine = 10

let LevelThreshold = 1000

protocol SwiftrisDelegate {
    func gameDidEnd(swiftris: Swiftris)
    func gameDidBegin(swiftris: Swiftris)
    func gamePieceDidLand(swiftris: Swiftris)
    func gamePieceDidMove(swiftris: Swiftris)
    func gamePieceDidDrop(swiftris: Swiftris)
    func gameDidLevelUp(swiftris: Swiftris)
}

class Swiftris {
    var blockArray:Array2D<Block>
    var nextShape:Shape?
    var fallingShape:Shape?
    var delegate:SwiftrisDelegate?
    
    var score:Int
    var levelThreshold:Int
    var level:Int
    
    var gameOver:Bool
    
    init() {
        score = 0
        levelThreshold = 0
        level = 1
        gameOver = true
        fallingShape = nil
        nextShape = nil
        blockArray = Array2D<Block>(columns: NumColumns, rows: NumRows)
    }
    
    func beginGame() {
        gameOver = false
        if (nextShape == nil) {
            nextShape = Shape.random(PreviewColumn, startingRow: PreviewRow)
        }
        delegate?.gameDidBegin(self)
    }
    
    func newShape() -> (fallingShape:Shape?, nextShape:Shape?) {
        fallingShape = nextShape
        nextShape = Shape.random(PreviewColumn, startingRow: PreviewRow)
        fallingShape?.moveTo(StartingColumn, row: StartingRow)
        if detectIllegalPlacement() {
            nextShape = fallingShape
            nextShape!.moveTo(PreviewColumn, row: PreviewRow)
            endGame()
            return (nil, nil)
        }
        return (fallingShape, nextShape)
    }
    
    func dropShape() -> Bool {
        if let shape = fallingShape {
            while detectIllegalPlacement() == false {
                shape.lowerShapeByOneRow()
            }
            shape.raiseShapeByOneRow()
            delegate?.gamePieceDidDrop(self)
            return true
        }
        return false
    }
    
    func letShapeFall() {
        if let shape = fallingShape {
            shape.lowerShapeByOneRow()
            if detectIllegalPlacement() {
                shape.raiseShapeByOneRow()
                if detectIllegalPlacement() {
                    endGame()
                } else {
                    settleShape()
                }
            } else if detectTouch() {
                delegate?.gamePieceDidMove(self)
                settleShape()
            } else {
                delegate?.gamePieceDidMove(self)
            }
        }
    }
    
    func rotateShape() {
        if let shape = fallingShape {
            shape.rotateClockwise()
            if detectIllegalPlacement() {
                shape.rotateCounterClockwise()
            } else {
                delegate?.gamePieceDidMove(self)
            }
        }
    }

    
    func moveShapeLeft() {
        if let shape = fallingShape {
            shape.shiftLeftByOneColumn()
            if detectIllegalPlacement() {
              shape.shiftRightByOneColumn()
              return
            }
            delegate?.gamePieceDidMove(self)
        }
    }
    
    func moveShapeRight() {
        if let shape = fallingShape {
            shape.shiftRightByOneColumn()
            if detectIllegalPlacement() {
              shape.shiftLeftByOneColumn()
              return
            }
            delegate?.gamePieceDidMove(self)
        }
    }
    
    func removeAllBlocks() -> Array<Array<Block>> {
        var allBlocks = Array<Array<Block>>()
        for row in 0..<NumRows {
            var rowOfBlocks = Array<Block>()
            for column in 0..<NumColumns {
                if let block = blockArray[column, row] {
                    rowOfBlocks.append(block)
                    blockArray[column, row] = nil
                }
            }
            allBlocks.append(rowOfBlocks)
        }
        return allBlocks
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
        } else {
            let pointsEarned = removedLines.count * PointsPerLine * level
            score += pointsEarned
            levelThreshold += pointsEarned
            if levelThreshold >= LevelThreshold {
                level += 1
                levelThreshold -= LevelThreshold
                delegate?.gameDidLevelUp(self)
            }
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
            fallingShape = nil
            delegate?.gamePieceDidLand(self)
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
        score = 0
        level = 1
        levelThreshold = 0
        gameOver = true
        delegate?.gameDidEnd(self)
    }
}