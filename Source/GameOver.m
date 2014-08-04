//
//  GameOver.m
//  OneClickCharlie
//
//  Created by Chad Rutherford on 7/15/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameOver.h"

@implementation GameOver
{
    
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void) restartGame
{
    CCScene *gamePlayScene = [CCBReader loadAsScene:@"GamePlayScene"];
    [[CCDirector sharedDirector] replaceScene:gamePlayScene];
}

- (void) gameOverPopUp
{
    self.paused = YES;
}

@end
