//
//  BIDGoalWallNode.m
//  PongSKGame
//
//  Created by ZD on 6/17/14.
//  Copyright (c) 2014. All rights reserved.
//

#import "BIDGoalWallNode.h"
#import "BIDPhysicsCategories.h"

@implementation BIDGoalWallNode

- (instancetype) init{
    if (self = [super init]) {
        SKSpriteNode *paddle = [SKSpriteNode spriteNodeWithImageNamed:@"goal"];
        [self initPhysicsBody];
        [self addChild:paddle];
    }
    return self;
}

- (void)initPhysicsBody {
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:
                           CGSizeMake(3, 2000)];
    body.categoryBitMask = GoalCategory;
    body.contactTestBitMask = BallCategory;
    body.dynamic = NO;//Will not be affected by gravity
    self.physicsBody = body;
}

@end
