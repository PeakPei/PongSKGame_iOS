//
//  BIDPhysicsCategories.h
//  Practice52
//
//  Created by ZD on 6/16/14.
//  Copyright (c) 2014. All rights reserved.
//

#ifndef Practice52_BIDPhysicsCategories_h
#define Practice52_BIDPhysicsCategories_h

typedef NS_OPTIONS(uint32_t, BIDPhysicsCategory) {
    PaddleCategory      =  1 << 1,
    BallCategory        =  1 << 2,
    AICategory          =  1 << 3,
    GoalCategory        =  1 << 4,
    AIGoalCategory      =  1 << 5
};

#endif
