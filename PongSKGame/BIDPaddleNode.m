//
//  BIDPaddleNode.m
//  PongSKGame
//
//  Created by ZD on 6/17/14.
//  Copyright (c) 2014. All rights reserved.
//

#import "BIDPaddleNode.h"
#import "BIDGeometry.h"
#import "BIDPhysicsCategories.h"

@implementation BIDPaddleNode

- (instancetype) init{
    if (self = [super init]) {
        SKSpriteNode *paddle = [SKSpriteNode spriteNodeWithImageNamed:@"paddle"];
        [self initPhysicsBody];
        [self addChild:paddle];
    }
    return self;
}

- (void)initPhysicsBody {
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:
                           CGSizeMake(10, 100)];
    
    body.affectedByGravity = NO;
    body.categoryBitMask = PaddleCategory;
    body.contactTestBitMask = BallCategory|PaddleCategory;
    body.restitution = 0.5f;
    body.friction = 0.8f;
    body.dynamic = NO;
    self.physicsBody = body;
}

- (CGFloat)movePaddle:(CGPoint)location {
    //Modified from the Book's example
    [self removeActionForKey:@"movement"];
    CGFloat distance;
    if(location.y > 300){
        distance = BIDPointDistance(self.position, CGPointMake(30, 360));
    }else{
        distance = BIDPointDistance(self.position, location);
    }
    //CGFloat pixels = [UIScreen mainScreen].bounds.size.width;
    CGFloat duration = /*2.0 * distance / pixels*/.15;
    
    [self runAction:[SKAction moveTo:location duration:duration]
            withKey:@"movement"];
    
    return duration;
}

@end
