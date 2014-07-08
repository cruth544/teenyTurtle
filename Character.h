//
//  Character.h
//  OneClickCharlie
//
//  Created by Chad Rutherford on 7/3/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface Character : CCNode


-(void)jump;
-(void)reverseGravity;
-(void)stopMoving;
-(void)teleport;

@end
