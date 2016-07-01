class SquareShape:Shape {
    /*
    
    | 0•| 1 |
    | 2 | 3 |
    
    • marks the row/column indicator for the shape
    
    */
    
    // The square shape will not rotate
    
    override var blockRowColumnPositions: [Orientation: Array<(columnDiff: Int, rowDiff: Int)>] {
        return [
            Orientation.zero:       [(0, 0), (1, 0), (0, 1), (1, 1)],
            Orientation.oneEighty:  [(0, 0), (1, 0), (0, 1), (1, 1)],
            Orientation.ninety:     [(0, 0), (1, 0), (0, 1), (1, 1)],
            Orientation.twoSeventy: [(0, 0), (1, 0), (0, 1), (1, 1)]
        ]
    }
    
    override var bottomBlocksForOrientations: [Orientation: Array<Block>] {
        return [
            Orientation.zero:       [blocks[ThirdBlockIdx], blocks[FourthBlockIdx]],
            Orientation.oneEighty:  [blocks[ThirdBlockIdx], blocks[FourthBlockIdx]],
            Orientation.ninety:     [blocks[ThirdBlockIdx], blocks[FourthBlockIdx]],
            Orientation.twoSeventy: [blocks[ThirdBlockIdx], blocks[FourthBlockIdx]]
        ]
    }
    
}
