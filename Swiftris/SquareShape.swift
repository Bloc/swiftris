class SquareShape:Shape {
    /*
        | 0 | 1 |
        | 2 | 3 |
    */
    
    
    // Square does not handle rotation at all since it 
    // looks the same no matter what orientation it is in
    
    override var bottomBlocks:Array<Block> {
        return [self.blocks[ThirdBlockIdx], self.blocks[FourthBlockIdx]]
    }
    
    override func initializeBlocks() {
        for i in 0...FourthBlockIdx {
            let column:Int = i == 0 || i == 2 ? self.column : self.column + 1
            let row:Int = i == 0 || i == 1 ? self.row : self.row - 1
            let block = Block(column:column, row:row, style:BlockStyle.random(), color:self.color)
            self.blocks.append(block)
        }
    }
}