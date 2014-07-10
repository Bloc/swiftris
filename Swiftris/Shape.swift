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
                return "Zero"
            case .Ninety:
                return "Ninety"
            case .OneEighty:
                return "One Eighty"
            case .TwoSeventy:
                return "Two Seventy"
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
let NumShapeTypes:UInt32 = 5

let FirstBlockIdx:Int = 0
let SecondBlockIdx:Int = 1
let ThirdBlockIdx:Int = 2
let FourthBlockIdx:Int = 3

class Shape: Hashable, Printable {
    // Whether or not the shape is mirrored
    let mirrored:Bool
    // The color of the shape
    let color:BlockColor
    
    // The blocks comprising the shape
    var blocks = Array<Block>()
    // The current orientation of the shape
    var orientation: Orientation
    // The top-left corner of the shape's area
    var column, row:Int
    // The area this shape consumes, sublcasses should override
    var area:Int {
        return 4
    }
    // Subclases should override this calculated property
    var bottomBlocks:Array<Block> {
        return Array<Block>()
    }
    
    var hashValue:Int {
        return reduce(blocks, 0) { $0.hashValue ^ $1.hashValue }
    }
    
    var description:String {
        return "Shape"
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
    
    // Protected
    func rotateBlocksToOrientation(orientation: Orientation) {
        // Subclasses should override
    }
    
    @final func rotateClockwise() {
        rotateBlocksToOrientation(Orientation.rotate(orientation, clockwise: true))
        orientation = Orientation.rotate(orientation, clockwise: true)
    }
    
    @final func rotateCounterClockwise() {
        rotateBlocksToOrientation(Orientation.rotate(orientation, clockwise: false))
        orientation = Orientation.rotate(orientation, clockwise: false)
    }
    
    @final func lowerShapeByOneRow() {
        self.row -= 1
        for block in blocks {
            block.row -= 1
        }
    }
    
    @final func raiseShapeByOneRow() {
        self.row += 1
        for block in blocks {
            block.row += 1
        }
    }
    
    @final func shiftRightByOneColumn() {
        self.column += 1
        for block in blocks {
            block.column += 1
        }
    }
    
    @final func shiftLeftByOneColumn() {
        self.column -= 1
        for block in blocks {
            block.column -= 1
        }
    }
    
    @final class func random(startingRow:Int, startingCol:Int) -> Shape {
        var randomColor:BlockColor = BlockColor.random()
        var randomMirror:Bool = arc4random_uniform(1) == 1
        // TODO all shapes
        switch Int(arc4random_uniform(NumShapeTypes)) {
        case 0:
            return SquareShape(color: randomColor, column: startingCol,
                row:startingRow, mirrored:randomMirror)
        case 1:
            return LineShape(color: randomColor, column: startingCol,
                row:startingRow, mirrored:randomMirror)
        default:
            return LineShape(color: randomColor, column: startingCol,
                row:startingRow, mirrored:randomMirror)
        }
    }
}

func ==(lhs: Shape, rhs: Shape) -> Bool {
    return lhs.row == rhs.row && lhs.column == rhs.column
}