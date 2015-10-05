//
//  BIDGameOverScreen.m
//  PongSKGame
//
//  Created by ZD on 6/17/14.
//  Copyright (c) 2014. All rights reserved.
//

#import "BIDGameOverScreen.h"
#import "BIDMyScene.h"

@implementation BIDGameOverScreen

-(instancetype)initWithSize:(CGSize)size didWin:(BOOL)didWin{
    if (self = [super initWithSize:size]) {
    }
    self.backgroundColor = [UIColor blackColor];
    SKLabelNode *title = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
    SKLabelNode *subtitle = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
    title.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    title.fontSize = 24;
    title.fontColor = [UIColor whiteColor];
    subtitle.fontSize = 12;
    subtitle.fontColor = [UIColor grayColor];
    subtitle.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 50);
    if(didWin == YES){
        title.text = @"Congratulations!";
        subtitle.text = @"Play again? (Click the Screen)";
    }else{
        title.text = @"Game Over.";
        subtitle.text = @"Try again? (Click the Screen)";
    }
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
