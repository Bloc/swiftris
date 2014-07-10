import UIKit
import SpriteKit

class GameViewController: UIViewController, SwiftrisDelegate, UIGestureRecognizerDelegate {
    var scene: GameScene!
    var swiftris:Swiftris!
    var panPointReference:CGPoint?
    
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
    
    @IBAction func didPan(sender: UIPanGestureRecognizer) {
        let currentPoint = sender.translationInView(self.view)
        if let originalPoint = self.panPointReference {
            if abs(currentPoint.x - originalPoint.x) >= BlockSize {
                if currentPoint.x > originalPoint.x {
                    swiftris.moveShapeRight()
                } else {
                    swiftris.moveShapeLeft()
                }
                sender.setTranslation(currentPoint, inView: self.view)
            }
        } else {
            println("Setting original reference: \(currentPoint)")
            panPointReference = currentPoint
        }
    }
    
    @IBAction func didSwipe(sender: UISwipeGestureRecognizer) {
        swiftris.dropShape()
    }
    
    func didTick() {
        swiftris.letShapeFall()
    }
    
    // UIGestureRecognizerDelegate
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer!, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer!) -> Bool {
        return true
    }
    
    // Switris Delegate
    
    func gameDidBegin(swiftris: Swiftris) {
        scene.addShapeToScene(swiftris.fallingShape!) {
            self.didTick()
            self.scene.startTicking()
        }
    }
    
    func gameDidEnd(swiftris: Swiftris) {
        scene.stopTicking()
    }
    
    func gamePieceDidLand(swiftris: Swiftris) {
        scene.stopTicking()
        // TODO Check for lines made?
        swiftris.newShape()
        scene.addShapeToScene(swiftris.fallingShape!) {}
        scene.startTicking()
    }
    
    func gamePieceDidMove(swiftris: Swiftris) {
        scene.redrawShape(swiftris.fallingShape!) {}
    }
}
