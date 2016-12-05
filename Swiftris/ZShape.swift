class ZShape:Shape {
    /*
    
    Orientation 0
    
      • | 0 |
    | 2 | 1 |
    | 3 |
    
    Orientation 90
    
    | 0 | 1•|
        | 2 | 3 |
    
    Orientation 180
    
      • | 0 |
    | 2 | 1 |
    | 3 |
    
    Orientation 270
    
    | 0 | 1•|
        | 2 | 3 |

    
    • marks the row/column indicator for the shape
    
    */
    
    override var blockRowColumnPositions: [Orientation: Array<(columnDiff: Int, rowDiff: Int)>] {
        return [
            Orientation.zero:       [(1, 0), (1, 1), (0, 1), (0, 2)],
            Orientation.ninety:     [(-1,0), (0, 0), (0, 1), (1, 1)],
            Orientation.oneEighty:  [(1, 0), (1, 1), (0, 1), (0, 2)],
            Orientation.twoSeventy: [(-1,0), (0, 0), (0, 1), (1, 1)]
        ]
    }
    
    override var bottomBlocksForOrientations: [Orientation: Array<Block>] {
        return [
            Orientation.zero:       [blocks[SecondBlockIdx], blocks[FourthBlockIdx]],
            Orientation.ninety:     [blocks[FirstBlockIdx], blocks[ThirdBlockIdx], blocks[FourthBlockIdx]],
            Orientation.oneEighty:  [blocks[SecondBlockIdx], blocks[FourthBlockIdx]],
            Orientation.twoSeventy: [blocks[FirstBlockIdx], blocks[ThirdBlockIdx], blocks[FourthBlockIdx]]
        ]
    }
}
