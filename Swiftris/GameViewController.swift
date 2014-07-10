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
        if swiftris.gameOver {
            return
        }
        if sender.state == .Ended {
            panPointReference = nil
        }
        let currentPoint = sender.translationInView(self.view)
        if let originalPoint = panPointReference {
            if abs(currentPoint.x - originalPoint.x) > BlockSize * 1.5 {
                if currentPoint.x > originalPoint.x {
                    if sender.velocityInView(self.view).x > CGFloat(0) {
                        swiftris.moveShapeRight()
                    }
                } else if sender.velocityInView(self.view).x < CGFloat(0) {
                    swiftris.moveShapeLeft()
                }
                panPointReference = currentPoint
                sender.setTranslation(currentPoint, inView: self.view)
            }
        } else {
            panPointReference = currentPoint
        }
    }
    
    @IBAction func didSwipe(sender: UISwipeGestureRecognizer) {
        if swiftris.gameOver {
            return
        }
        swiftris.dropShape()
    }
    
    func didTick() {
        swiftris.letShapeFall()
    }
    
    // UIGestureRecognizerDelegate
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer!, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer!) -> Bool {
        return true
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer!, shouldBeRequiredToFailByGestureRecognizer otherGestureRecognizer: UIGestureRecognizer!) -> Bool {
        if let swipeRec = gestureRecognizer as? UISwipeGestureRecognizer {
            if let panRec = otherGestureRecognizer as? UIPanGestureRecognizer {
                return true
            }
        }
        return false
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
        if let newShape = swiftris.newShape() {
            scene.addShapeToScene(newShape) {}
            scene.startTicking()
        }
    }
    
    func gamePieceDidMove(swiftris: Swiftris) {
        scene.redrawShape(swiftris.fallingShape!) {}
    }
}
