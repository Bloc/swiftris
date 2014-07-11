class TShape:Shape {
    /*
    Orientation 0
    
      • | 0 |
    | 1 | 2 | 3 |
    
    Orientation 90
    
      • | 1 |
        | 2 | 0 |
        | 3 |
    
    Orientation 180

      •
    | 1 | 2 | 3 |
        | 0 |
    
    Orientation 270
    
      • | 1 |
    | 0 | 2 |
        | 3 |
    
    • marks the row/column indicator for the shape
    
    */
    
    override var blockRowColumnPositions: [Orientation: Array<(columnDiff: Int, rowDiff: Int)>] {
        return [
            Orientation.Zero:       [(1, 0), (0,-1), (1,-1), (2,-1)],
            Orientation.Ninety:     [(2,-1), (1, 0), (1,-1), (1,-2)],
            Orientation.OneEighty:  [(1,-2), (0,-1), (1,-1), (2,-1)],
            Orientation.TwoSeventy: [(0,-1), (1, 0), (1,-1), (1,-2)]
        ]
    }
    
    override var bottomBlocksForOrientations: [Orientation: Array<Int>] {
        return [
            Orientation.Zero:       [SecondBlockIdx, ThirdBlockIdx, FourthBlockIdx],
            Orientation.Ninety:     [FirstBlockIdx, FourthBlockIdx],
            Orientation.OneEighty:  [FirstBlockIdx, SecondBlockIdx, FourthBlockIdx],
            Orientation.TwoSeventy: [FirstBlockIdx, FourthBlockIdx]
        ]
    }
}
