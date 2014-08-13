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
    CCNode *_obstacleForTutorial;
}

- (void) didLoadFromCCB
{
    [self loadLargeTutorial];
}

- (void) loadLargeTutorial
{
    CCNode *largeTutorialLevel = [CCBReader load:@"Levels/TutorialLevel"];
    [self.physicsNode addChild:largeTutorialLevel];
}

- (void) loadTutorial
{
    for (int i = 0; i < 12; i++) {
        CCNode *looper = [CCBReader load:@"Levels/LevelForTutorial"];
        [self.levelsGroup addObject:looper];
        [self.physicsNode addChild:looper];
        looper.position = ccp(looper.contentSize.width * i, 0);
        
        if (i <= 5 || i == 7 || i == 10) {
            CCNode *addGap = [CCBReader load:@"Gap"];
            [_obstacleForTutorial addChild:addGap];
            [addGap setPosition:ccp(0, 0)];
        } else if (i == 6) {
            CCNode *addFirstWall = [CCBReader load:@"Wall"];
            [_obstacleForTutorial addChild:addFirstWall];
            CCNode *swipeUpGesture = [CCBReader load:@"Live Tutorial/TutorialSwipeUp"];
            swipeUpGesture.position = ccp(looper.contentSize.width * 5, 0);
        } else if (i == 8) {
            CCNode *addSecondWall = [CCBReader load:@"Wall"];
            [_obstacleForTutorial addChild:addSecondWall];
            [addSecondWall setPosition:ccp(0, 200)];
            CCNode *swipeUpGesture = [CCBReader load:@"Live Tutorial/TutorialSwipeUp"];
            swipeUpGesture.position = ccp(looper.contentSize.width * 5, 0);
        } else if (i == 9) {
            CCNode *addClam = [CCBReader load:@"Clam"];
            [_obstacleForTutorial addChild:addClam];
        } else if (i == 11) {
            CCNode *wallForSharkAttack = [CCBReader load:@"Wall"];
            [_obstacleForTutorial addChild:wallForSharkAttack];
        }
    }
}


@end
