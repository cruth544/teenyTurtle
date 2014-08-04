//
//  Tutorial.m
//  OneClickCharlie
//
//  Created by Chad Rutherford on 7/24/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Tutorial.h"

@implementation Tutorial
{
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _tutorialPage = 2;
    }
    return self;
}



- (void) nextPage: (id) sender
{
    //starts game with Play Button
    CCScene *tutorialPageScene = [[CCScene alloc] init];
    Tutorial *tutorialNode = (Tutorial *)[CCBReader load:[NSString stringWithFormat:@"Tutorials/Tutorial%i", _tutorialPage]];
    tutorialNode.tutorialPage = self.tutorialPage + 1;
    [tutorialPageScene addChild:tutorialNode];
    [[CCDirector sharedDirector] replaceScene:tutorialPageScene];
}

- (void) startGame
{
    CCScene *startGame = [CCBReader loadAsScene:@"GamePlayScene"];
    [[CCDirector sharedDirector] replaceScene:startGame];
}

@end
