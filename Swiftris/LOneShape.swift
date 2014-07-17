class LOneShape:Shape {
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
            Orientation.Zero:       [ (0, 0), (0, 1),  (0, 2),  (1, 2)],
            Orientation.Ninety:     [ (1, 1), (0, 1),  (-1,1), (-1, 2)],
            Orientation.OneEighty:  [ (0, 2), (0, 1),  (0, 0),  (-1,0)],
            Orientation.TwoSeventy: [ (-1,1), (0, 1),  (1, 1),   (1,0)]
        ]
    }
    
    override var bottomBlocksForOrientations: [Orientation: Array<Int>] {
        return [
            Orientation.Zero:       [ThirdBlockIdx, FourthBlockIdx],
            Orientation.Ninety:     [FirstBlockIdx, SecondBlockIdx, FourthBlockIdx],
            Orientation.OneEighty:  [FirstBlockIdx, FourthBlockIdx],
            Orientation.TwoSeventy: [FirstBlockIdx, SecondBlockIdx, ThirdBlockIdx]
        ]
    }
}
