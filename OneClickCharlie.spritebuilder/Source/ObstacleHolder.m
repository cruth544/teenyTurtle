//
//  Obstacles.m
//  OneClickCharlie
//
//  Created by Chad Rutherford on 7/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "ObstacleHolder.h"
#import "Character.h"

@implementation ObstacleHolder
{
    CCNode *_obstacles;
    int _randomizer;
    Character *_characterNode;
    float obstaclePosition;
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
    [Character characterPosition];
    [_obstacles removeAllChildrenWithCleanup:YES];
    _randomizer = arc4random()%10;
    if (_randomizer <= 6) {
        obstaclePosition = arc4random()%200 + 80;
        
        CCNode *addGap = [CCBReader load:@"Gap"];
        [_obstacles addChild:addGap z:25];
        
        CCNode *wallObstacle = [CCBReader load:@"Jellyfish"];
        [_obstacles addChild:wallObstacle z:1];
        
//        wallObstacle.physicsBody.collisionType = @"wall";
        [addGap setPosition:ccp(0, 0)];
        [wallObstacle setPosition:ccp(0, obstaclePosition)];
        
    } else if (_randomizer >= 8) {
        CCNode *addGap = [CCBReader load:@"Gap"];
        [_obstacles addChild:addGap];
        
        CCNode *clam = [CCBReader load:@"Clam"];
        [_obstacles addChild:clam z:200];
        [clam setPosition:ccp(0, 0)];
        
        clam.physicsBody.collisionType = @"clam";
        [clam setPosition:ccp(0, 18)];
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
