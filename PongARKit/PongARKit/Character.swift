//
//  Character.swift
//  PongARKit
//
//  Created by Jones on 2018/1/30.
//  Copyright © 2018年 ssrh. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class Character: SCNNode {
    
    var animations = [String: CAAnimation]()
    var movingDirection = SCNVector3(0, 0, 0)
    var movingSpeed: Float = 0.002
    var curAnimation: String = ""
    var parentCamera: ARCamera!
    private var _bornPos: SCNVector3?

    init(ModelFile file: String) {
        super.init()
        
        self.name = "character"
        let scn = SCNScene(named: file);
        for child in scn!.rootNode.childNodes {
            self.addChildNode(child)
        }
        self.scale = SCNVector3(0.0005, 0.0005, 0.0005)
        
        loadAnimation(withKey: "idle", sceneName: "art.scnassets/idle", animIdentifier: "idle-1")
        loadAnimation(withKey: "walking", sceneName: "art.scnassets/walking", animIdentifier: "walking-1")
        loadAnimation(withKey: "running", sceneName: "art.scnassets/running", animIdentifier: "running-1")
//
//        self.physicsBody?.categoryBitMask = CollisionCategory.character.rawValue
//        self.physicsBody?.contactTestBitMask = CollisionCategory.bottom.rawValue
//        self.physicsBody?.collisionBitMask = CollisionCategory.bottom.rawValue
//        self.physicsBody?.isAffectedByGravity = true
//        self.physicsBody?.friction = 0
//        self.physicsBody?.restitution = 0
//        self.physicsBody?.angularDamping = 0
//
//        // Below is the Creation of the Physics body of the character
//        let (min, max) = self.boundingBox
//        let capsuleRadius = CGFloat(max.x - min.x) * 0.4
//        let capsuleHeight = CGFloat(max.y - min.y)
//
//        // position light above the floor so you dont hit it and cause a contact
////        self.position = SCNVector3(0.0, capsuleHeight * 0.51, 0.0)
//        self.physicsBody = SCNPhysicsBody(type: .dynamic,
//                                          shape: SCNPhysicsShape(geometry: SCNCapsule(capRadius: capsuleRadius,
//                                                                                      height: capsuleHeight),
//                                                                 options:nil))
        
        
//        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
//        self.physicsBody?.mass = 2
//        self.physicsBody?.categoryBitMask = CollisionCategory.character.rawValue
        playAnimation(key: "idle")
    }
    
    var bornPos: SCNVector3? {
        get { return _bornPos }
        set(value) {
            _bornPos = value
            _bornPos!.y += Float(collisionHeight * 0.51)
            self.position = _bornPos!
        }
    }
    
    var collisionHeight: CGFloat {
        let (min, max) = self.boundingBox
        return CGFloat(max.y - min.y)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(updateAtTime time: TimeInterval, camera: ARCamera?){
        if self.isHidden { return }
        parentCamera = camera
        self.position += movingDirection * movingSpeed
        if movingDirection.length() > 0 {
            let angleInRadians = atan2(-movingDirection.z, movingDirection.x) + Float.pi * 0.5
            self.rotation = SCNVector4(0, 1, 0, angleInRadians)
        }
        
//        print("character pos: \(self.position.x),0,\(self.position.z)")
    }
    
    func loadAnimation(withKey: String, sceneName: String, animIdentifier: String) {
        let sceneURL = Bundle.main.url(forResource: sceneName, withExtension: "dae")
        let sceneSource = SCNSceneSource(url: sceneURL!, options: nil)
        
        if let animObj = sceneSource?.entryWithIdentifier(animIdentifier, withClass: CAAnimation.self) {
            // The animation will only play once
            animObj.repeatCount = Float.greatestFiniteMagnitude
            // To create smooth transitions between animations
            animObj.fadeInDuration = CGFloat(1)
            animObj.fadeOutDuration = CGFloat(0.5)
            // Store the animation for later use
            animations[withKey] = animObj
        }
    }
    
    func playAnimation(key: String) {
        if curAnimation == key {
            return
        }
        stopAnimation(key: curAnimation)
        // Add the animation to start playing it right away
        self.addAnimation(animations[key]!, forKey: key)
        curAnimation = key
    }
    
    func stopAnimation(key: String) {
        // Stop the animation with a smooth transition
        self.removeAnimation(forKey: key, blendOutDuration: CGFloat(0.5))
    }
    
    func move(dirShift: Float, dirForward: Float) {
        if parentCamera == nil { return }
        if dirShift == 0 && dirForward == 0{
            movingDirection = SCNVector3(0, 0, 0)
            playAnimation(key: "idle")
            return
        }
        let len = sqrt(dirShift * dirShift + dirForward * dirForward)
        let mat = SCNMatrix4(parentCamera.transform)
        let dir = SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33)
        let forward = SCNVector3(dir.x, 0, dir.z).normalized()
        let left = dir.cross(vector: SCNVector3(0, 1, 0))
        movingDirection = left * dirShift / len + forward * dirForward / len
        playAnimation(key: "running")
    }
}
