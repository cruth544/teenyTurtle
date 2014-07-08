//
//  Character.m
//  OneClickCharlie
//
//  Created by Chad Rutherford on 7/3/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Character.h"
#define CP_ALLOW_PRIVATE_ACCESS 1
#import "CCPhysics+ObjectiveChipmunk.h"






@implementation Character {
    BOOL _didJump;
    CCNode *_characterTeleport;
}

-(void)didLoadFromCCB {
    self.userInteractionEnabled = YES;
    
    //sets velocity for Character
}

-(void) onEnter {
    [super onEnter];
    self.physicsBody.body.body->velocity_func = playerUpdateVelocity;
//    [self teleport];
}

static void
playerUpdateVelocity(cpBody *body, cpVect gravity, cpFloat damping, cpFloat dt)
{
    cpAssertSoft(body->m > 0.0f && body->i > 0.0f, "Body's mass and moment must be positive to simulate. (Mass: %f Moment: %f)", body->m, body->i);
    
	body->v = cpvadd(cpvmult(body->v, damping), cpvmult(cpvadd(gravity, cpvmult(body->f, body->m_inv)), dt));
	body->w = body->w*damping + body->t*body->i_inv*dt;
    
	// Reset forces.
	body->f = cpvzero;
	body->t = 0.0f;
    
	body->v.x = 40.f;
}

- (void)stopMoving {

}

- (void)jump {
    //Character Jump function
    [self.physicsBody.chipmunkObjects[0] eachArbiter:^void(cpArbiter *arbiter) {
        if (!_didJump) {
            [self.physicsBody applyImpulse:ccp(0, 600)];
            _didJump = TRUE;
            [self performSelector:@selector(resetJump) withObject:nil afterDelay:0.3f];
        }
    }];
}

//method for reversing gravity
- (void)reverseGravity {
//  saves current gravity y value then inverses it and applies changes
    CGFloat _gravityReverser = self.parent.physicsNode.gravity.y;
    [self.parent.physicsNode setGravity:CGPointMake(0, _gravityReverser *-1)];
}

- (void)teleport {
    
    _characterTeleport = [CCBReader load:@"CharacterTeleport"];
    [self addChild:_characterTeleport];
    _characterTeleport.position = ccp(36, 0);
    CCActionInterval *moveForward = [CCActionMoveTo actionWithDuration:1.f position:ccp(72, 0)];
    CCActionInterval *moveBackward = [CCActionMoveTo actionWithDuration:1.f position:ccp(36, 0)];
    CCActionSequence *moveForwardAndBack = [CCActionSequence actionOne:moveForward two:moveBackward];
    CCActionRepeatForever *oscilatingAction = [CCActionRepeatForever actionWithAction:moveForwardAndBack];
    [_characterTeleport runAction:oscilatingAction];
    CCActionInstant *teleportCharacter = [CCActionPlace actionWithPosition:_characterTeleport.positionInPoints];
    [self runAction:teleportCharacter];
}

- (void)resetJump {
    _didJump = FALSE;
}



@end
