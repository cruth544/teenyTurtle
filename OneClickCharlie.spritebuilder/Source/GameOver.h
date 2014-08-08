//
//  GameOver.h
//  OneClickCharlie
//
//  Created by Chad Rutherford on 7/15/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GamePlayScene.h"
#import <Social/Social.h>


@interface GameOver : CCNode

@property (nonatomic, assign) BOOL hasGameBeenPlayed;

- (void) restartGame;
- (void) gameOverPopUp;

@end
