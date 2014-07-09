class SquareShape:Shape {
    override func initializeBlocks() {
        for i in 0...3 {
            let column:Int = i == 0 || i == 2 ? self.column : self.column + 1
            let row:Int = i == 0 || i == 1 ? self.row : self.row - 1
            let block = Block(column:column, row:row, style:BlockStyle.random(), color:self.color)
            self.blocks.addElement(block)
        }
    }
}