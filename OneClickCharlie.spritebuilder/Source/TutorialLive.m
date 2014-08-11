//
//  TutorialLive.m
//  OneClickCharlie
//
//  Created by Chad Rutherford on 8/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "TutorialLive.h"

@implementation TutorialLive
{
    CCPhysicsNode *physicsNode;
}

- (void) didLoadFromCCB
{
    CCNode *level = [CCBReader load:@"Levels/LoopingLevel"];
    [physicsNode addChild: level];
    
}

- (void) onEnter
{
    [super onEnter];
}

@end
