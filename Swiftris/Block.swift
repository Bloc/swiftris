import SpriteKit

enum BlockStyle: Int {
    case StyleOne, StyleTwo
    
    var prefix: String {
        if self == .StyleOne {
            return "Block-1"
        } else {
            return "Block-2"
        }
    }
    
    static func random() -> BlockStyle {
        return BlockStyle.fromRaw(Int(arc4random_uniform(2)))!
    }
}

enum BlockColor: Int, Printable {
    case Blue = 0, Red, Green, Yellow
    
    var postfix: String {
        switch self {
        case .Blue:
            return "-Blue"
        case .Red:
            return "-Red"
        case .Green:
            return "-Green"
        case .Yellow:
            return "-Yellow"
        }
    }
    
    var description: String {
        switch self {
            case .Blue:
                return "Blue"
            case .Red:
                return "Red"
            case .Green:
                return "Green"
            case .Yellow:
                return "Yellow"
        }
    }
    
    static func random() -> BlockColor {
        return BlockColor.fromRaw(Int(arc4random_uniform(4)))!
    }
}

class Block: Hashable, Printable {
    // Constants
    let type: (style: BlockStyle, color: BlockColor)

    // Variables
    var column: Int
    var row: Int
    
    // Lazy loading
    var sprite: SKSpriteNode?
    
    var spriteName: String {
        return type.style.prefix + type.color.postfix
    }
    
    var hashValue: Int {
        return self.column ^ self.row
    }
    
    var description: String {
        return "\(type.color) (\(column), \(row))"
    }
    
    init(column:Int, row:Int, style:BlockStyle, color:BlockColor) {
        self.column = column
        self.row = row
        self.type = (style, color)
    }
    
    convenience init(column:Int, row:Int, color:BlockColor) {
        self.init(column:column, row:row, style:BlockStyle.random(), color:color)
    }
}

func ==(lhs: Block, rhs: Block) -> Bool {
    return lhs.column == rhs.column && lhs.row == rhs.row
}
