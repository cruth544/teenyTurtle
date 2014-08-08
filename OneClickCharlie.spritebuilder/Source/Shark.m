//
//  Shark.m
//  OneClickCharlie
//
//  Created by Chad Rutherford on 7/23/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Shark.h"
#import "Character.h"
#import "CCActionMoveToNode.h"

@implementation Shark
{
    CCNode *_shark;
    float sharkSpeed;
    BOOL didMethodRun;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        sharkSpeed = 80.f;
    }
    return self;
}

- (void) didLoadFromCCB
{
    self.paused = YES;
    didMethodRun = NO;
}

- (void) onEnter
{
    [super onEnter];
}

- (void) delayShark
{
    if (!self.paused && !didMethodRun) {
        [self scheduleBlock:^(CCTimer *timer) {
            CCActionMoveToNode *followCharacter = [CCActionMoveToNode actionWithSpeed:sharkSpeed targetNode:_turtleTarget followInfinite:YES];
            [self runAction:followCharacter];
            self.visible = YES;
            self.paused = NO;
        } delay:2.5f];
        didMethodRun = YES;
    }
}

- (void) update:(CCTime)delta
{
    [self delayShark];
}


@end
