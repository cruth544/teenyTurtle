//
//  Obstacles.h
//  OneClickCharlie
//
//  Created by Chad Rutherford on 7/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GamePlayScene.h"

@interface ObstacleHolder : CCNode

@property (nonatomic, strong) CCNode *obstacles;

- (void) reinitialize;

@end
