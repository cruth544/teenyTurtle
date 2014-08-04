//
//  Obstacles.m
//  OneClickCharlie
//
//  Created by Chad Rutherford on 7/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "ObstacleHolder.h"

@implementation ObstacleHolder
{
    CCNode *_obstacles;
    int _randomizer;
}

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)didLoadFromCCB
{
    [self reinitialize];
}

- (void) reinitialize
{
    [_obstacles removeAllChildrenWithCleanup:YES];
    _randomizer = arc4random()%8;
    if (_randomizer <= 3) {
        float obstaclePosition = arc4random()%270;
        CCNode *addGap = [CCBReader load:@"Gap"];
        CCNode *wallObstacle = [CCBReader load:@"Wall"];
        [_obstacles addChild:addGap];
        [_obstacles addChild:wallObstacle];
        wallObstacle.physicsBody.collisionType = @"wall";
        [addGap setPosition:ccp(0, 0)];
        [wallObstacle setPosition:ccp(0, obstaclePosition)];
    } else if (_randomizer == 4) {
        CCNode *addGap = [CCBReader load:@"Gap"];
        CCNode *clam = [CCBReader load:@"Clam"];
        [_obstacles addChild:addGap];
        [_obstacles addChild:clam];
        clam.physicsBody.collisionType = @"clam";
        [clam setPosition:ccp(0, 18)];
    } else if (_randomizer >= 5) {
        CCNode *starfish = [CCBReader load:@"Levels/starGroup1"];
            [_obstacles addChild:starfish z:90];
            float yPosition = arc4random() % 300;
            [starfish setPosition:ccp(0, yPosition + 10)];
    }
}

- (void) onEnter
{
    [super onEnter];
}

- (void)update:(CCTime)delta
{

}


@end
