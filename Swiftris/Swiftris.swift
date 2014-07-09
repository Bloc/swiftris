let NumColumns:Int = 10
let NumRows:Int = 20

let StartingColumn:Int = 4
let StartingRow:Int = NumRows - 1

protocol SwiftrisDelegate {
    func gameDidEnd(swiftris: Swiftris)
    
}

class Swiftris {
    let shapes:Set<Shape> = Set<Shape>()
    
    var fallingShape:Shape?
    
    var delegate:SwiftrisDelegate?
    
    var score:Int = 0
    
    init() {
        fallingShape = nil
    }
    
    func beginGame() {
        fallingShape = newShape()
    }
    
    func newShape() -> Shape {
        var newShape = Shape.random(StartingRow, startingCol: StartingColumn)
        shapes.addElement(newShape)
        if detectCollision() {
            shapes.removeElement(newShape)
            endGame()
        }
        return newShape
    }
    
    func letShapeFall() {
        fallingShape?.lowerShapeByOneRow()
    }
    
    func detectCollision() -> Bool {
        // TODO
        return false
    }
    
    func endGame() {
        // TODO what else?
        delegate?.gameDidEnd(self)
    }
}