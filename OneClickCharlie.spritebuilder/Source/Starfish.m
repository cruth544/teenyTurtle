//
//  Starfish.m
//  OneClickCharlie
//
//  Created by Chad Rutherford on 8/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Starfish.h"

@implementation Starfish
{
}

- (void) didLoadFromCCB
{
    self.physicsBody.collisionType = @"starfish";
    self.physicsBody.sensor = YES;
}

@end
