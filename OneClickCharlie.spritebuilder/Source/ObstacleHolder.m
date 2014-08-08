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
    if (_randomizer <= 3) {
        if (arc4random()%2 == 0) {
            obstaclePosition = [Character characterPosition] + arc4random()%25;
        } else {
            obstaclePosition = [Character characterPosition] - arc4random()%25;
        }
        
        CCNode *addGap = [CCBReader load:@"Gap"];
        [_obstacles addChild:addGap z:10];
        
        CCNode *wallObstacle = [CCBReader load:@"Wall"];
        [_obstacles addChild:wallObstacle z:1];
        
        float rotationAmount = arc4random()%30 + arc4random()%100 / 100;
        CCLOG(@"Rotation Amount: %f", rotationAmount);
        wallObstacle.physicsBody.collisionType = @"wall";
        [addGap setPosition:ccp(0, 0)];
        [wallObstacle setPosition:ccp(0, obstaclePosition)];
        [wallObstacle setRotation:rotationAmount];
        
    } else if (_randomizer == 4) {
        CCNode *addGap = [CCBReader load:@"Gap"];
        [_obstacles addChild:addGap];
        
        CCNode *clam = [CCBReader load:@"Clam"];
        [_obstacles addChild:clam];
        
        clam.physicsBody.collisionType = @"clam";
        [clam setPosition:ccp(0, 18)];
        
    } else if (_randomizer >= 9) {
        CCNode *starfish = [CCBReader load:@"Levels/starGroup1"];
            [_obstacles addChild:starfish z:99];
            float yPosition = arc4random() % 250;
            [starfish setPosition:ccp(0, yPosition + 30)];
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
