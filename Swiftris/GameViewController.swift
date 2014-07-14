import UIKit
import SpriteKit

class GameViewController: UIViewController, SwiftrisDelegate, UIGestureRecognizerDelegate {
    @IBOutlet var swipeRec: UISwipeGestureRecognizer
    @IBOutlet var panRec: UIPanGestureRecognizer
    @IBOutlet var tapRec: UITapGestureRecognizer
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
        if sender.state == .Ended {
            panPointReference = nil
        }
        let currentPoint = sender.translationInView(self.view)
        if let originalPoint = panPointReference {
            if abs(currentPoint.x - originalPoint.x) > BlockSize {
                if currentPoint.x > originalPoint.x {
                    if sender.velocityInView(self.view).x > CGFloat(0) {
                        swiftris.moveShapeRight()
                    }
                } else if sender.velocityInView(self.view).x < CGFloat(0) {
                    swiftris.moveShapeLeft()
                }
                panPointReference = currentPoint
            }
        } else if sender.state == .Began {
            panPointReference = currentPoint
        }
    }
    
    @IBAction func didSwipe(sender: UISwipeGestureRecognizer) {
        if swiftris.dropShape() {
            scene.stopTicking()
        }
    }
    
    
    @IBAction func didTap(sender: UITapGestureRecognizer) {
        swiftris.rotateShape()
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
        } else if let panRec = gestureRecognizer as? UIPanGestureRecognizer {
            if let tapRec = otherGestureRecognizer as? UITapGestureRecognizer {
                return true
            }
        }
        return false
    }
    
    // Switris Delegate
    
    func gameDidBegin(swiftris: Swiftris) {
        scene.addPreviewShapeToScene(swiftris.fallingShape!) {
            self.scene.movePreviewToShape(swiftris.fallingShape!) {
                self.scene.addPreviewShapeToScene(swiftris.nextShape!) {
                    self.swipeRec.enabled = true
                    self.panRec.enabled = true
                    self.tapRec.enabled = true
                    self.didTick()
                    self.scene.startTicking()
                }
            }
        }
    }
    
    func gameDidEnd(swiftris: Swiftris) {
        self.swipeRec.enabled = false
        self.panRec.enabled = false
        self.tapRec.enabled = false
        scene.stopTicking()
        
    }
    
    func gamePieceDidLand(swiftris: Swiftris) {
        scene.stopTicking()
        self.view.userInteractionEnabled = false
        let removedLines = swiftris.removeCompletedLines()
        if removedLines.linesRemoved.count > 0 {
            swiftris.score += PointsPerLine * removedLines.linesRemoved.count
            scene.animateCollapsingLines(removedLines.linesRemoved, fallenBlocks:removedLines.fallenBlocks) {
                self.gamePieceDidLand(swiftris)
            }
        } else {
            let newShapes = swiftris.newShape()
            if let fallingShape = newShapes.fallingShape {
                self.scene.movePreviewToShape(fallingShape) {
                    self.view.userInteractionEnabled = true
                    self.scene.addPreviewShapeToScene(newShapes.nextShape!) {
                        self.scene.startTicking()
                    }
                }
            }
        }
    }
  
    func gamePieceDidMove(swiftris: Swiftris) {
        scene.redrawShape(swiftris.fallingShape!) {}
    }
    
    func gamePieceDidDrop(swiftris: Swiftris) {
        scene.redrawShape(swiftris.fallingShape!) {
            self.didTick()
        }
    }
}
