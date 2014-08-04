//
//  StartScene.m
//  OneClickCharlie
//
//  Created by Chad Rutherford on 7/3/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "StartScene.h"

@implementation StartScene

- (void) startButton
{
    //starts game with Play Button
    CCScene *gamePlayScene = [CCBReader loadAsScene:@"GamePlayScene"];
    [[CCDirector sharedDirector] replaceScene:gamePlayScene];
}


@end
