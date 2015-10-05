//
//  BIDIntroScreen.m
//  PongSKGame
//
//  Created by ZD on 6/18/14.
//  Copyright (c) 2014. All rights reserved.
//

#import "BIDIntroScreen.h"
#import "BIDMyScene.h"

@implementation BIDIntroScreen

-(instancetype)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]) {
        
    }
    //Making the Intro Scene
    self.backgroundColor = [UIColor blackColor];
    SKLabelNode *title = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
    SKLabelNode *subtitle = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
    title.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    title.fontSize = 24;
    title.fontColor = [UIColor whiteColor];
    subtitle.fontSize = 12;
    subtitle.fontColor = [UIColor grayColor];
    subtitle.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 50);
    title.text = @"Pong?";
    subtitle.text = @"Pong. (Touch to Start)";
    [self addChild:title];
    [self addChild:subtitle];
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    BIDMyScene *nextLevel = [[BIDMyScene alloc]
                             initWithSize:self.frame.size];
    [self.view presentScene:nextLevel
                 transition:[SKTransition fadeWithColor:[UIColor blackColor] duration:5.0]];
}


@end
