//
//  Character.h
//  OneClickCharlie
//
//  Created by Chad Rutherford on 7/3/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

// sets if character collided with wall


@interface Character : CCNode

@property (nonatomic, strong) CCNode *characterTeleport;
@property (nonatomic, assign) bool didCollide;
@property (nonatomic, assign) float characterSpeed;
@property (nonatomic, assign) BOOL crossedWater;
@property (nonatomic, assign) bool reverseGravityTriggered;
@property (nonatomic) CGPoint waterBuoyancy;
@property (nonatomic, strong) Character *selfRef;


- (void) jump;
- (void) upGravity;
- (void) downGravity;
- (void) outOfWaterGravity;
- (void) teleport;

@end
