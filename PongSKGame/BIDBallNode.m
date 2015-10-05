//
//  BIDBallNode.m
//  PongSKGame
//
//  Created by ZD on 6/17/14.
//  Copyright (c) 2014. All rights reserved.
//

#import "BIDBallNode.h"
#import "BIDPhysicsCategories.h"
#include <stdlib.h>

@interface BIDBallNode ()

@property (nonatomic) CGVector velocityOfBall;

@end

@implementation BIDBallNode

- (instancetype) init{
    if (self = [super init]) {
        SKSpriteNode *ball = [SKSpriteNode spriteNodeWithImageNamed:@"Ball"];
        [self initPhysicsBody];
        [self addChild:ball];
    }
    return self;
}

- (void)initPhysicsBody {
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:
                           CGSizeMake(15, 15)];
    
    //Physics of ball
    body.friction = 0.0f;
    body.restitution = 1.0f;
    body.allowsRotation = NO;
    body.linearDamping = 0.0f;
    body.angularVelocity = .9;
    body.mass = .07;
    

    self.physicsBody = body;
    [self.physicsBody applyImpulse:CGVectorMake(10.0f, -10.0f)];
}



@end
