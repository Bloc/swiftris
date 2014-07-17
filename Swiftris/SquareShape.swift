class SquareShape:Shape {
    /*

        | 0•| 1 |
        | 2 | 3 |
    
    • marks the row/column indicator for the shape
    
    */
    
    // The square shape will not rotate
    
    override var blockRowColumnPositions: [Orientation: Array<(columnDiff: Int, rowDiff: Int)>] {
        return [
            Orientation.Zero:       [(0, 0), (1, 0), (0, 1), (1, 1)],
            Orientation.OneEighty:  [(0, 0), (1, 0), (0, 1), (1, 1)],
            Orientation.Ninety:     [(0, 0), (1, 0), (0, 1), (1, 1)],
            Orientation.TwoSeventy: [(0, 0), (1, 0), (0, 1), (1, 1)]
        ]
    }
    
    override var bottomBlocksForOrientations: [Orientation: Array<Int>] {
        return [
            Orientation.Zero:       [ThirdBlockIdx, FourthBlockIdx],
            Orientation.OneEighty:  [ThirdBlockIdx, FourthBlockIdx],
            Orientation.Ninety:     [ThirdBlockIdx, FourthBlockIdx],
            Orientation.TwoSeventy: [ThirdBlockIdx, FourthBlockIdx]
        ]
    }

}