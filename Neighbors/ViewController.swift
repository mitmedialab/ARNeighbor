//
//  ViewController.swift
//  Neighbors
//
//  Created by Cindy Bishop on 10/11/18.
//  Copyright © 2018 LoopyLoo. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

private var hitTestResult :ARHitTestResult!

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    enum IncomeBracket: Int {
        case low = 1
        case middle = 2
        case high = 3
    }
    enum RaceIdentity: Int {
        case black = 1
        case brown = 2
        case pink = 3
        case offwhite = 4
        case red = 5
    }
    enum Choice: Int {
        case food = 1
        case bar = 2
        case people = 3
    }
    enum ChoiceAmount: Int {
        case poor = 1
        case fair = 2
        case great = 3
    }
    enum DistanceFromMIT: Int {
        case under10 = 1
        case under20 = 2
        case under30 = 3
        case above30 = 4
    }
    
    enum Persona : Int {
        case STUDENT = 1 // low income,
        case FACSTAFF = 2
        case VISITOR = 3
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        guard let referenceMaps = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        configuration.detectionImages = referenceMaps
        // Run the view's session
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    

    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if !(anchor is ARImageAnchor) {
            return
        }
        let imageAnchor = anchor as? ARImageAnchor
        
        let referenceImage = imageAnchor?.referenceImage
        DispatchQueue.main.async {
            
            // Create a plane to visualize the initial position of the detected image.
            let plane = SCNPlane(width: referenceImage!.physicalSize.width,
                                 height: referenceImage!.physicalSize.height)
            let planeNode = SCNNode(geometry: plane)
            planeNode.opacity = 0.25
            
            /*
             `SCNPlane` is vertically oriented in its local coordinate space, but
             `ARImageAnchor` assumes the image is horizontal in its local space, so
             rotate the plane to match.
             */
            planeNode.eulerAngles.x = -.pi / 2
            
            /*
             Image anchors are not tracked after initial detection, so create an
             animation that limits the duration for which the plane visualization appears.
             */
            //planeNode.runAction(self.imageHighlightAction)
            
            // Add the plane visualization to the scene.
            node.addChildNode(planeNode)
        }
    }

    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
