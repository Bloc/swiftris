class LineShape:Shape {
    /**
        Orientations 0 and 180:
        | 0 |
        | 1 |
        | 2 |
        | 3 |
    
        Orientations 90 and 270:
        | 0 | 1 | 2 | 3 |
    **/
    
    override var bottomBlocks:Array<Block> {
        if orientation.isVertical() {
            return [blocks[FourthBlockIdx]]
        } else {
            return blocks
        }
    }
    
    override func initializeBlocks() {
        for i in 0...FourthBlockIdx {
            var column:Int = self.column
            var row:Int = self.row
            if orientation.isVertical() {
                row = self.row - i
            } else {
                column = self.column + i
            }
            let block = Block(column: column, row: row, style: BlockStyle.random(), color: color)
            blocks.append(block)
        }
    }
    
    override func rotateBlocksToOrientation(orientation: Orientation) {
        println("Rotating from \(self.orientation) to \(orientation)")
        // Hinges around SecondBlockIdx
        if (orientation.isHorizontal() && self.orientation.isHorizontal()) {
            return
        } else if (orientation.isVertical() && self.orientation.isVertical()) {
            return
        }
        let hingeColumn:Int = blocks[SecondBlockIdx].column
        let hingeRow:Int = blocks[SecondBlockIdx].row
        for i in 0...FourthBlockIdx {
            let block = blocks[i]
            if orientation.isVertical() {
                block.column = hingeColumn
                block.row = hingeRow - (i - SecondBlockIdx)
            } else {
                block.row = hingeRow
                block.column = hingeColumn - (i - SecondBlockIdx)
            }
        }
        // Update the shape's row and column
        column = blocks[FirstBlockIdx].column
        row = blocks[FirstBlockIdx].row
    }
}
