class LShape:Shape {
    /*
    
    Orientation 0
    
        | 0•|
        | 1 |
        | 2 | 3 |
    
    Orientation 90

          •
    | 2 | 1 | 0 |
    | 3 |
    
    Orientation 180
    
    | 3 | 2•|
        | 1 |
        | 0 |
    
    Orientation 270
    
          • | 3 |
    | 0 | 1 | 2 |
    
    • marks the row/column indicator for the shape
    
    Pivots about `1`
    
    */
    
    override var blockRowColumnPositions: [Orientation: Array<(columnDiff: Int, rowDiff: Int)>] {
        return [
            Orientation.zero:       [ (0, 0), (0, 1),  (0, 2),  (1, 2)],
            Orientation.ninety:     [ (1, 1), (0, 1),  (-1,1), (-1, 2)],
            Orientation.oneEighty:  [ (0, 2), (0, 1),  (0, 0),  (-1,0)],
            Orientation.twoSeventy: [ (-1,1), (0, 1),  (1, 1),   (1,0)]
        ]
    }
    
    override var bottomBlocksForOrientations: [Orientation: Array<Block>] {
        return [
            Orientation.zero:       [blocks[ThirdBlockIdx], blocks[FourthBlockIdx]],
            Orientation.ninety:     [blocks[FirstBlockIdx], blocks[SecondBlockIdx], blocks[FourthBlockIdx]],
            Orientation.oneEighty:  [blocks[FirstBlockIdx], blocks[FourthBlockIdx]],
            Orientation.twoSeventy: [blocks[FirstBlockIdx], blocks[SecondBlockIdx], blocks[ThirdBlockIdx]]
        ]
    }
}
