//
//  GameScene.swift
//  TapTap Battle
//
//  Created by Gabriel Silva on 9/18/14.
//  Copyright (c) 2014 Gabriel Silva. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    //variaveis
    var bluePlayer : SKSpriteNode?
    var oragePlayer : SKSpriteNode?
    var bluePoints : SKLabelNode?
    var oragePoints : SKLabelNode?
    
    //contante de aumento
    let pointsToIncrise = CGFloat(10)
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUpUI()
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        self.setUpUI()
    }    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
    }
    
    //identificando touch
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        var localTouch = touches.anyObject() as UITouch
        var locationTouch = localTouch.locationInNode(self)
        indentifyTouchedNode(locationTouch)
    }
    
    func indentifyTouchedNode(touchLocation: CGPoint){
        if nodeAtPoint(touchLocation).isEqual(self.bluePlayer){
            self.blueHasTouch()
        }else if nodeAtPoint(touchLocation).isEqual(self.oragePlayer){
            self.orangeHasTouch()
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    //configurando a UI
    private func setUpUI(){
        self.bluePlayer = SKSpriteNode(color: UIColor.blueColor(),
            size: CGSizeMake(self.size.width,self.size.height/2))
        
        self.oragePlayer = SKSpriteNode(color: UIColor.orangeColor(),
            size: CGSizeMake(self.size.width, self.size.height/2))
        
        self.bluePlayer!.anchorPoint = CGPointMake(0,1)
        self.oragePlayer!.anchorPoint = CGPointMake(0, 0)
        
        self.bluePlayer!.position = CGPointMake(0, self.size.height);
        self.oragePlayer!.position = CGPointMake(0 , 0)
        //self.oragePlayer!.zRotation = CGFloat(M_PI)
        
        self.addChild(self.bluePlayer!)
        self.addChild(self.oragePlayer!)
        
        self.bluePoints = SKLabelNode(fontNamed: "MyriadPro-Bold")
        self.bluePoints!.text = "0"
        self.bluePoints!.fontSize = 35
        self.bluePoints!.position = CGPointMake(20, self.size.height/2 + 20)
        self.bluePoints!.zRotation = CGFloat(M_PI)
        self.bluePoints!.zPosition = 3
        
        self.oragePoints = SKLabelNode(fontNamed: "MyriadPro-Bold")
        self.oragePoints!.text = "0"
        self.oragePoints!.fontSize = 35
        self.oragePoints!.position = CGPointMake(self.size.width - 20, self.size.height/2 - 20)
        self.oragePoints!.zPosition = 3
        
        self.addChild(self.bluePoints!)
        self.addChild(self.oragePoints!)
    }
    
    func blueHasTouch(){
        self.oragePlayer?.zPosition = 0
        self.bluePlayer?.zPosition = 1
        self.bluePoints?.text = "\(1 + self.bluePoints!.text.toInt()!)"
        self.bluePlayer?.runAction(createActionToMove(self.bluePlayer!, node2: self.oragePlayer!))
    }
    
    func orangeHasTouch(){
        self.oragePlayer?.zPosition = 1
        self.bluePlayer?.zPosition = 0
        self.oragePoints?.text = "\(1 + self.oragePoints!.text.toInt()!)"
        self.bluePlayer?.runAction(createActionToMove(self.oragePlayer!, node2: self.bluePlayer!))
    }
    
    func createActionToMove(node1 : SKSpriteNode, node2 : SKSpriteNode) -> SKAction{
        var actionRun : SKAction = SKAction.runBlock({() in self.myRunBlock(node1, node2: node2)})
        
        var actionToCreate : SKAction = SKAction.sequence([actionRun])

        return actionToCreate
    }
    
    func myRunBlock(node1 : SKSpriteNode, node2 : SKSpriteNode){
        node1.size = CGSizeMake(node1.size.width, node1.size.height + self.pointsToIncrise)
        node2.size = CGSizeMake(node2.size.width, node2.size.height - self.pointsToIncrise)
    }
    
    
}
