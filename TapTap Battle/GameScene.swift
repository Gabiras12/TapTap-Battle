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
    private var bluePlayer : SKSpriteNode?
    private var oragePlayer : SKSpriteNode?
    private var bluePoints : SKLabelNode?
    private var oragePoints : SKLabelNode?
    private var gameIsOn : Bool = true
    
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
        
        var nodeTouched = nodeAtPoint(touchLocation)
        
        if gameIsOn {
            if nodeTouched.isEqual(self.bluePlayer){
                self.blueHasTouch()
            }else if nodeTouched.isEqual(self.oragePlayer){
                self.orangeHasTouch()
            }
        }else {
            if nodeTouched.name == "restart"{
                var game = GameScene(size: self.size)
                var transition = SKTransition.fadeWithDuration(0.5)
                self.view?.presentScene(game, transition: transition)
            }
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
        self.bluePoints!.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        self.bluePoints!.position = CGPointMake(self.bluePoints!.frame.size.width, self.size.height/2 + self.bluePoints!.frame.size.width)
        self.bluePoints!.zRotation = CGFloat(M_PI)
        self.bluePoints!.zPosition = 3
        
        self.oragePoints = SKLabelNode(fontNamed: "MyriadPro-Bold")
        self.oragePoints!.text = "0"
        self.oragePoints!.fontSize = 35
        self.oragePoints!.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        self.oragePoints!.position = CGPointMake(self.size.width - self.oragePoints!.frame.size.width, self.size.height/2 - self.oragePoints!.frame.size.height)
        self.oragePoints!.zPosition = 3
        
        self.addChild(self.bluePoints!)
        self.addChild(self.oragePoints!)
    }
    
    func blueHasTouch(){
        self.oragePlayer?.zPosition = 0
        self.bluePlayer?.zPosition = 1
        self.bluePoints?.text = "\(1 + self.bluePoints!.text.toInt()!)"
        self.bluePlayer?.runAction(createActionToMove(self.bluePlayer!, node2: self.oragePlayer!))
        self.moveLabels(self.bluePoints!, label2: self.oragePoints!)
    }
    
    func orangeHasTouch(){
        self.oragePlayer?.zPosition = 1
        self.bluePlayer?.zPosition = 0
        self.oragePoints?.text = "\(1 + self.oragePoints!.text.toInt()!)"
        self.bluePlayer?.runAction(createActionToMove(self.oragePlayer!, node2: self.bluePlayer!))
        self.moveLabels(self.oragePoints!, label2: self.bluePoints!)
    }
    
    func createActionToMove(node1 : SKSpriteNode, node2 : SKSpriteNode) -> SKAction{
        var moveAction : SKAction = SKAction.runBlock({() in self.blockCode(node1, node2: node2)})
        var verifyGameOver : SKAction = SKAction.runBlock({() in self.verifyGameOver()})
        
        var createdAction: SKAction = SKAction.sequence([moveAction,verifyGameOver])

        return createdAction
    }
    
    func blockCode(node1 : SKSpriteNode, node2 : SKSpriteNode){
        node1.size = CGSizeMake(node1.size.width, node1.size.height + self.pointsToIncrise)
        node2.size = CGSizeMake(node2.size.width, node2.size.height - self.pointsToIncrise)
    }
    
    func moveLabels(label1: SKLabelNode, label2: SKLabelNode){
        if label1.isEqual(self.oragePoints){
            label1.position = CGPointMake(label1.position.x, label1.position.y + pointsToIncrise)
            label2.position = CGPointMake(label2.position.x, label2.position.y + pointsToIncrise)
        } else {
            label1.position = CGPointMake(label1.position.x, label1.position.y - pointsToIncrise)
            label2.position = CGPointMake(label2.position.x, label2.position.y - pointsToIncrise)
        }
    }
    
    func verifyGameOver(){
        if self.bluePlayer!.size.height + 94 >= self.size.height{
            self.gameOver("blue")
        }else if self.oragePlayer!.size.height + 94 >= self.size.height {
            self.gameOver("orange")
        }
    }
    
    
    func gameOver(winner: String){
        var gameOver: SKSpriteNode = SKSpriteNode(imageNamed: "background_win_" + winner + "_iphone");
        gameOver.position = CGPointMake(self.size.width/2, self.size.height/2)
        gameOver.setScale(0)
        gameOver.zPosition = 4
        
        var restart = SKSpriteNode(imageNamed: "restart")
        restart.name = "restart"
        restart.position = CGPointMake(gameOver.size.width/2, gameOver.size.height - restart.size.height)
        
        gameOver.addChild(restart)
        
        self.gameIsOn = false
        
        gameOver.runAction(SKAction.scaleTo(1, duration: 0.5))
        self.addChild(gameOver)
    }
    
}
