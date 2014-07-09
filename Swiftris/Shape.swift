// Shape class defines a swiftris shape
import SpriteKit

enum Orientation: Int {
    case Zero = 0
    case Ninety = 1
    case OneEighty = 2
    case TwoSeventy = 3
    
    func rotateClockwise() -> Orientation {
        var rotated = self.toRaw() + 1
        if rotated > Orientation.TwoSeventy.toRaw() {
            rotated = Orientation.Zero.toRaw()
        }
        return Orientation.fromRaw(rotated)!
    }
}

// The number of total shape varieities
let NumShapeTypes:UInt32 = 5

class Shape: Hashable {
    // The current orientation of the shape
    var orientation: Orientation
    // The top-left corner of the shape's area
    var column, row:Int
    // Whether or not the shape is mirrored
    var mirrored:Bool
    // The color of the shape
    let color:BlockColor
    // The blocks comprising the shape
    let blocks:Set<Block> = Set<Block>()
    // The area this shape consumes, sublcasses should override
    var area:Int {
        return 4
    }
    
    var hashValue:Int {
        return reduce(blocks, 0) { $0.hashValue ^ $1.hashValue }
    }
    
    init(color: BlockColor, column:Int, row:Int, mirrored:Bool) {
        self.color = color
        self.column = column
        self.row = row
        self.mirrored = mirrored
        orientation = .Zero
        initializeBlocks()
    }
    
    func initializeBlocks() {
        // Subclasses must override
    }
    
    func rotateClockwise() {
        orientation = orientation.rotateClockwise()
    }
    
    func lowerShapeByOneRow() {
        self.row -= 1
        for block in blocks {
            block.row -= 1
        }
    }
    
    class func random(startingRow:Int, startingCol:Int) -> Shape {
        var randomColor:BlockColor = BlockColor.random()
        var randomMirror:Bool = arc4random_uniform(1) == 1
        // TODO all shapes
        switch Int(arc4random_uniform(NumShapeTypes)) {
        case 0:
            return SquareShape(color: randomColor, column: startingCol,
                row:startingRow, mirrored:randomMirror)
        default:
            return SquareShape(color: randomColor, column: startingCol,
                row:startingRow, mirrored:randomMirror)
        }
    }
}

func ==(lhs: Shape, rhs: Shape) -> Bool {
    return lhs.row == rhs.row && lhs.column == rhs.column
}