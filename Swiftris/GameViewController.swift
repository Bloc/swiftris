import UIKit
import SpriteKit

class GameViewController: UIViewController, SwiftrisDelegate {
    var scene: GameScene!
    var swiftris:Swiftris!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view.
        let skView = view as SKView
        skView.multipleTouchEnabled = false
        
        // Create and configure the scene.
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        scene.tick = didTick
        
        swiftris = Swiftris()
        swiftris.delegate = self
        swiftris.beginGame()
        
        // Present the scene.
        skView.presentScene(scene)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.toRaw())
        } else {
            return Int(UIInterfaceOrientationMask.All.toRaw())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    func didTick() {
        swiftris.letShapeFall()
        scene.redrawShape(swiftris.fallingShape!) {}
    }
    
    func gameDidBegin(swiftris: Swiftris, newShape: Shape) {
        scene.addShapeToScene(newShape) {
            self.didTick()
            self.scene.startTicking()
        }
    }
    
    func gameDidEnd(swiftris: Swiftris) {
        
    }
    
    func gamePieceDidLand(swiftris: Swiftris, landedShape: Shape) {
        scene.redrawShape(landedShape) {
            self.swiftris.settleShape()
            // Check for lines made?
            self.swiftris.newShape()
            self.scene.addShapeToScene(swiftris.fallingShape!) {}
            self.scene.startTicking()
        }
    }
    
}
