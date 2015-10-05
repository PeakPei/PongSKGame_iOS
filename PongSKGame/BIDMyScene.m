//
//  BIDMyScene.m
//  PongSKGame
//
//  Created by ZD on 6/17/14.
//  Copyright (c) 2014. All rights reserved.
//

#import "BIDMyScene.h"
#import "BIDGeometry.h"
#import "BIDPaddleNode.h"
#import "BIDBallNode.h"
#import "BIDPhysicsCategories.h"
#import "BIDGoalWallNode.h"
#import "BIDGameOverScreen.h"

static const float AIMOVE       = 0.26;

@interface BIDMyScene () <SKPhysicsContactDelegate>

@property (nonatomic) BIDPaddleNode *paddleNode;
@property (nonatomic) SKLabelNode *player1Score;
@property (nonatomic) SKLabelNode *player2Score;
@property (nonatomic) SKSpriteNode *upArrow;
@property (nonatomic) SKSpriteNode *downArrow;
@property (nonatomic) BIDBallNode *ballNode;
@property (nonatomic) BIDGoalWallNode *rightGoal;
@property (nonatomic) BIDGoalWallNode *leftGoal;
@property (nonatomic) BIDGoalWallNode *test;
@property (nonatomic) int player1ScoreNum;
@property (nonatomic) int player2ScoreNum;
@property (nonatomic) BIDPaddleNode *AIPaddleNode;
@property (nonatomic) NSTimeInterval lastUpdateTime;
@property (nonatomic) NSTimeInterval AIMoveInterval;

@end

@implementation BIDMyScene


//When Scene is initially created
-(instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        _player1ScoreNum = 0;
        _player2ScoreNum = 0;
        [self resetGame];
    }
    return self;
}

//When entering a new round
-(instancetype)initWithSize:(CGSize)size player1Score:(int)player1Score player2Score:(int)player2Score {
    if(self = [super initWithSize:size]){
        _player1ScoreNum = player1Score;
        _player2ScoreNum = player2Score;
        [self resetGame];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        //For the buttons
        
        //Hard-Coded Locations of buttons
        //*********************************************
        CGPoint location = [touch locationInNode:self];
        if((location.x > self.upArrow.position.x - 25 &&
           location.x <= self.upArrow.position.x + 25)
           &&
           (location.y > self.upArrow.position.y - 25 &&
            location.y <= self.upArrow.position.y +25)){
               if(self.paddleNode.position.y + 100 < self.frame.size.height){
                   [self.paddleNode movePaddle:CGPointMake(30, self.paddleNode.position.y + 50)];
               }else if(self.paddleNode.position.y + 100 > self.frame.size.height){
                    [self.paddleNode movePaddle:CGPointMake(30, (self.frame.size.height - 50))];
               }
            
        }
        
        if((location.x > self.downArrow.position.x - 25 &&
            location.x <= self.downArrow.position.x + 25)
           &&
           (location.y > self.downArrow.position.y - 25 &&
            location.y <= self.downArrow.position.y + 25)){
               if(self.paddleNode.position.y - 100 > 0){
                   [self.paddleNode movePaddle:CGPointMake(30, self.paddleNode.position.y - 50)];
               }else{
                   [self.paddleNode movePaddle:CGPointMake(30, self.frame.origin.x + 50)];
               }
           }
        //*********************************************
    }
}

-(void)update:(CFTimeInterval)currentTime {
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTime;
    self.lastUpdateTime = currentTime;
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
    
}

-(void)isGameOver{
    //Modified Clock idea from the Tornado Game
    if(_player1ScoreNum == 10){
        BIDGameOverScreen *endLevel = [[BIDGameOverScreen alloc]
                                       initWithSize:self.frame.size
                                       didWin:YES];
        //Transition to EndScene.  Player1 win.
        [self.view presentScene:endLevel
                     transition:[SKTransition fadeWithColor:[UIColor blackColor] duration:3.0]];
    }
    if(_player2ScoreNum == 10){
        BIDGameOverScreen *endLevel = [[BIDGameOverScreen alloc]
                                       initWithSize:self.frame.size
                                       didWin:NO];
        //Otherwise, the other transition.  Player1 lose.
        [self.view presentScene:endLevel
                     transition:[SKTransition fadeWithColor:[UIColor blackColor] duration:3.0]];

    }
}

-(void)checkGameOver{
    if(_player1ScoreNum == 10 || _player2ScoreNum == 10){
        _finished = YES;
    }
}

//Telling the AI paddle to move every AIMOVE constant interval
- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    self.AIMoveInterval            += timeSinceLast;
    if(self.AIMoveInterval > AIMOVE){
        [self followBall];
    }
    
}


-(void)followBall{
    //AI Instructions
    //Exactly the same as the user's controls
    CGPoint ballLoc = _ballNode.position;
    if(ballLoc.y > _AIPaddleNode.position.y - 25){
        if(self.AIPaddleNode.position.y + 100 < self.frame.size.height){
            [self.AIPaddleNode movePaddle:CGPointMake(CGRectGetMaxX(self.frame) - 30, self.AIPaddleNode.position.y + 50)];
        }else if(self.AIPaddleNode.position.y + 100 > self.frame.size.height){
            [self.AIPaddleNode movePaddle:CGPointMake(CGRectGetMaxX(self.frame) - 30, (self.frame.size.height - 50))];
        }
    }else{
        if(self.AIPaddleNode.position.y - 125 > 0){
            [self.AIPaddleNode movePaddle:CGPointMake(CGRectGetMaxX(self.frame) - 30, self.AIPaddleNode.position.y - 50)];
        }else{
            [self.AIPaddleNode movePaddle:CGPointMake(CGRectGetMaxX(self.frame) - 30, self.frame.origin.x + 50)];
        }
    }
    self.AIMoveInterval = 0;
}

-(void)resetGame{
    
    //Initilization/REInitilization Code
    
    self.AIMoveInterval = 0;
    self.backgroundColor = [SKColor colorWithRed:.8 green:1.0 blue:1.0 alpha:1.0];
    SKPhysicsBody* borderBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody = borderBody;
    self.physicsBody.friction = 0.0f;
    
    //Player 1 Label Score
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
    myLabel.fontColor = [SKColor colorWithRed:.2 green:.2 blue:.2 alpha:1.0];
    myLabel.text = [NSString stringWithFormat:@"%d", _player1ScoreNum];
    myLabel.fontSize = 44;
    myLabel.position = CGPointMake(CGRectGetMinX(self.frame) + 30,
                                   CGRectGetMaxY(self.frame) - 50);
    self.player1Score = myLabel;
    
    [self addChild:self.player1Score];
    
    //Player 2 Label Score
    SKLabelNode *myLabel2 = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
    myLabel2.fontColor = [SKColor colorWithRed:.2 green:.2 blue:.2 alpha:1.0];
    myLabel2.text = [NSString stringWithFormat:@"%d", _player2ScoreNum];
    myLabel2.fontSize = 44;
    myLabel2.position = CGPointMake(CGRectGetMaxX(self.frame) - 30,
                                    CGRectGetMaxY(self.frame) - 50);
    self.player2Score = myLabel2;
    
    [self addChild:self.player2Score];
    
    //Up Label Init
    self.upArrow = [SKSpriteNode spriteNodeWithImageNamed:@"UpArrow"];
    self.upArrow.size = CGSizeMake(50, 50);
    self.upArrow.position = CGPointMake(275, 125);
    [self addChild:self.upArrow];
    
    //Down Label Init
    self.downArrow = [SKSpriteNode spriteNodeWithImageNamed:@"UpArrow"];
    self.downArrow.zRotation = M_PI;
    self.downArrow.size = CGSizeMake(50, 50);
    self.downArrow.position = CGPointMake(275, 50);
    [self addChild:self.downArrow];
    
    //Player Paddle Init
    _paddleNode = [BIDPaddleNode node];
    _paddleNode.position = CGPointMake(30, CGRectGetMidY(self.frame));
    [self addChild:self.paddleNode];
    
    //AI Paddle Init
    _AIPaddleNode = [BIDPaddleNode node];
    _paddleNode.physicsBody.categoryBitMask = AICategory;
    _AIPaddleNode.position = CGPointMake(CGRectGetMaxX(self.frame) - 30, CGRectGetMidY(self.frame));
    [self addChild:self.AIPaddleNode];
    
    //Ball Init
    _ballNode = [BIDBallNode node];
    _ballNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:self.ballNode];
    [_ballNode.physicsBody applyImpulse:CGVectorMake(10.0f, -5.0f)];
    
    //Left Goal Wall Init
    _leftGoal = [BIDGoalWallNode node];
    _leftGoal.position = CGPointMake(1, 0);
    [self addChild:self.leftGoal];
    
    //Right Goal Wall Init
    _rightGoal = [BIDGoalWallNode node];
    _rightGoal.physicsBody.categoryBitMask = AIGoalCategory;
    _rightGoal.position = CGPointMake(CGRectGetMaxX(self.frame) - 1, 0);
    [self addChild:self.rightGoal];
    
    //For Collision
    self.physicsWorld.gravity = CGVectorMake(0,0);
    self.physicsWorld.contactDelegate = self;
}


- (void)didBeginContact:(SKPhysicsContact *)contact {
    if (contact.bodyA.categoryBitMask == contact.bodyB.categoryBitMask) {
        // Both bodies are in the same category
        // What do we do with these nodes?
    } else {
        SKNode *attacker = nil;
        SKNode *attackee = nil;
        
        if (contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask) {
            // Body A is attacking Body B
            attacker = contact.bodyA.node;
            attackee = contact.bodyB.node;
        } else {
            // Body B is attacking Body A
            attacker = contact.bodyB.node;
            attackee = contact.bodyA.node;
        }
        
        //If the Ball hits one of the paddles
        if ([attackee isKindOfClass:[BIDPaddleNode class]]){
            [_ballNode.physicsBody applyImpulse:CGVectorMake(3.0f, -5.0f)];
        }
        
        //If the ball hits the right wall object
        if(attackee.physicsBody.categoryBitMask == _rightGoal.physicsBody.categoryBitMask){
            _player1ScoreNum++;
            [self checkGameOver];
            if(_finished == YES) {
                [self isGameOver];//If the Game Reaches the End
            }else{
                BIDMyScene *nextLevel = [[BIDMyScene alloc]
                                         initWithSize:self.frame.size
                                         player1Score:_player1ScoreNum player2Score:_player2ScoreNum];
                [self.view presentScene:nextLevel
                             transition:[SKTransition fadeWithColor:[UIColor blackColor] duration:3.0]];
            }
        }
        
        //If the ball hits the left wall object
        if(attackee.physicsBody.categoryBitMask == _leftGoal.physicsBody.categoryBitMask){
            _player2ScoreNum++;
            [self checkGameOver];
            if(_finished == YES) {
                [self isGameOver];
            }else{
                BIDMyScene *nextLevel = [[BIDMyScene alloc]
                                         initWithSize:self.frame.size
                                         player1Score:_player1ScoreNum player2Score:_player2ScoreNum];
                [self.view presentScene:nextLevel
                             transition:[SKTransition fadeWithColor:[UIColor blackColor] duration:3.0]];
            }
         
        }
    }
}
    
@end
