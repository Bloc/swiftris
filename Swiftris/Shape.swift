// Shape class defines a swiftris shape
import SpriteKit

enum Orientation: Int, Printable {
    case Zero = 0
    case Ninety = 1
    case OneEighty = 2
    case TwoSeventy = 3
    
    var description: String {
        switch self {
            case .Zero:
                return "0"
            case .Ninety:
                return "90"
            case .OneEighty:
                return "180"
            case .TwoSeventy:
                return "270"
        }
    }
    
    func is0() -> Bool {
        return self == Zero
    }
    
    func is90() -> Bool {
        return self == Ninety
    }
    
    func is180() -> Bool {
        return self == OneEighty
    }
    
    func is270() -> Bool {
        return self == TwoSeventy
    }
    
    func isVertical() -> Bool {
        return is0() || is180()
    }
    
    func isHorizontal() -> Bool {
        return is90() || is270()
    }
    
    static func random() -> Orientation {
        return Orientation.fromRaw(Int(arc4random_uniform(4)))!
    }
    
    static func rotate(orientation:Orientation, clockwise: Bool) -> Orientation {
        var rotated = orientation.toRaw() + (clockwise ? 1 : -1)
        if rotated > Orientation.TwoSeventy.toRaw() {
            rotated = Orientation.Zero.toRaw()
        } else if rotated < 0 {
            rotated = Orientation.TwoSeventy.toRaw()
        }
        return Orientation.fromRaw(rotated)!
    }
}

// The number of total shape varieities
let NumShapeTypes:UInt32 = 7
// Shape indexes
let FirstBlockIdx:Int = 0
let SecondBlockIdx:Int = 1
let ThirdBlockIdx:Int = 2
let FourthBlockIdx:Int = 3

class Shape: Hashable, Printable {
    // The color of the shape
    let color:BlockColor
    
    // The blocks comprising the shape
    var blocks = Array<Block>()
    // The current orientation of the shape
    var orientation: Orientation
    // The top-left corner of the shape's area
    var column, row:Int
    
    // Required Overrides
    
    // Subclasses must override this property
    var blockRowColumnPositions: [Orientation: Array<(columnDiff: Int, rowDiff: Int)>] {
        return [:]
    }
    // Subclasses must override this property
    var bottomBlocksForOrientations: [Orientation: Array<Int>] {
        return [:]
    }
    
    var bottomBlocks:Array<Block> {
        if let bottomBlockIndexes: Array<Int> = bottomBlocksForOrientations[orientation] {
            var bottomBlocksArray = Array<Block>()
            for i in bottomBlockIndexes {
                bottomBlocksArray.append(blocks[i])
            }
            return bottomBlocksArray
        }
        return []
    }

    // Hashable
    var hashValue:Int {
        return reduce(blocks, 0) { $0.hashValue ^ $1.hashValue }
    }
    
    // Printable
    var description:String {
        return "\(orientation): \(blocks[FirstBlockIdx]), \(blocks[SecondBlockIdx]), \(blocks[ThirdBlockIdx]), \(blocks[FourthBlockIdx])"
    }
    
    init(column:Int, row:Int, color: BlockColor, orientation:Orientation) {
        self.color = color
        self.column = column
        self.row = row
        self.orientation = orientation
        initializeBlocks()
    }
    
    convenience init(column:Int, row:Int) {
        self.init(column:column, row:row, color:BlockColor.random(), orientation:Orientation.random())
    }
    
    @final func initializeBlocks() {
        if let blockRowColumnTranslations:Array<(columnDiff: Int, rowDiff: Int)> = blockRowColumnPositions[orientation] {
            for i in 0..<blockRowColumnTranslations.count {
                let blockRow = row + blockRowColumnTranslations[i].rowDiff
                let blockColumn = column + blockRowColumnTranslations[i].columnDiff
                let newBlock = Block(column: blockColumn, row: blockRow, color: color)
                blocks.append(newBlock)
            }
        }
    }
    
    // Private
    @final func rotateBlocks(orientation: Orientation) {
        if let blockRowColumnTranslation:Array<(columnDiff: Int, rowDiff: Int)> = blockRowColumnPositions[orientation] {
            for (idx, (columnDiff:Int, rowDiff:Int)) in enumerate(blockRowColumnTranslation) {
                blocks[idx].column = column + columnDiff
                blocks[idx].row = row + rowDiff
            }
        }
    }
    
    @final func rotateClockwise() {
        let newOrientation = Orientation.rotate(orientation, clockwise: true)
        rotateBlocks(newOrientation)
        orientation = newOrientation
    }
    
    @final func rotateCounterClockwise() {
        let newOrientation = Orientation.rotate(orientation, clockwise: false)
        rotateBlocks(newOrientation)
        orientation = newOrientation
    }
    
    @final func lowerShapeByOneRow() {
        shiftBy(0, rows:-1)
    }
    
    @final func raiseShapeByOneRow() {
        shiftBy(0, rows:1)
    }
    
    @final func shiftRightByOneColumn() {
        shiftBy(1, rows:0)
    }
    
    @final func shiftLeftByOneColumn() {
        shiftBy(-1, rows:0)
    }
    
    @final func shiftBy(columns: Int, rows: Int) {
        self.column += columns
        self.row += rows
        for block in blocks {
            block.column += columns
            block.row += rows
        }
    }
  
    @final func moveTo(column: Int, row:Int) {
        self.column = column
        self.row = row
        rotateBlocks(orientation)
    }
  
    @final class func random(startingColumn:Int, startingRow:Int) -> Shape {
        switch Int(arc4random_uniform(NumShapeTypes)) {
        case 0:
            return SquareShape(column:startingColumn, row:startingRow)
        case 1:
            return LineShape(column:startingColumn, row:startingRow)
        case 2:
            return TShape(column:startingColumn, row:startingRow)
        case 3:
            return ZigZagOneShape(column:startingColumn, row:startingRow)
        case 4:
            return ZigZagTwoShape(column:startingColumn, row:startingRow)
        case 5:
            return LOneShape(column:startingColumn, row:startingRow)
        default:
            return LTwoShape(column:startingColumn, row:startingRow)
        }
    }
}

func ==(lhs: Shape, rhs: Shape) -> Bool {
    return lhs.row == rhs.row && lhs.column == rhs.column
}