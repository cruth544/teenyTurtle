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

static float characterPosition;

@implementation Character
{
    BOOL _didJump;
    BOOL _teleportCD;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        _characterSpeed = 100.f;
        _waterBuoyancy = CGPointMake(0, 2000);
    }
    return self;
}
-(void)didLoadFromCCB
{
    self.userInteractionEnabled = YES;
    self.physicsBody.collisionType = @"character";
    self.paused = YES;
}

-(void) onEnter
{
    [super onEnter];
    self.physicsBody.body.body->velocity_func = playerUpdateVelocity;
}

static void
playerUpdateVelocity(cpBody *body, cpVect gravity, cpFloat damping, cpFloat dt)
{
    cpAssertSoft(body->m > 0.0f && body->i > 0.0f, "Body's mass and moment must be positive to simulate. (Mass: %f Moment: %f)", body->m, body->i);
    
	body->v = cpvadd(cpvmult(body->v, damping), cpvmult(cpvadd(gravity, cpvmult(body->f, body->m_inv)), dt));
	body->w = body->w*damping + body->t*body->i_inv*dt;
    
    Character *selfRef = (Character *)[[cpBodyGetUserData(body) userData] node];
    
    float distanceBelow = 300 - selfRef.position.y - selfRef.boundingBox.size.height / 2;
    distanceBelow = clampf(distanceBelow, 0, selfRef.boundingBox.size.height);
    float forceValue = (distanceBelow / selfRef.boundingBox.size.height) * selfRef.waterBuoyancy.y / 1.4;
    if (forceValue == 0) {
        forceValue -= body->v.y * 4;
    }
    forceValue -= body->v.y * 4;
    
    CGPoint appliedForce = CGPointMake(0, forceValue);
    if (selfRef.reverseGravityTriggered && selfRef.position.y < 300) {
        body->f = appliedForce;
    } else {
        body->f = cpvzero;
    }

	body->t = 0.0f;
    
    if (selfRef.didCollide == false) {
        if (body->v.x <= selfRef.characterSpeed) {
            float increasingVelocity = body->v.x + 1.5f;
            body->v.x = increasingVelocity;
        } else {
            body->v.x = selfRef.characterSpeed;
        }
    }
}

- (void) jump
{
    //Character Jump function
    [self.physicsBody.chipmunkObjects[0] eachArbiter:^void(cpArbiter *arbiter) {
        if (!_didJump) {
            [self.physicsBody applyImpulse:ccp(0, 300)];
            _didJump = TRUE;
            [self performSelector:@selector(resetJump) withObject:nil afterDelay:0.3f];
        }
    }];
}


#pragma mark - gravity methods

- (void) upGravity
{
    if (self.position.y < 300) {
        _reverseGravityTriggered = true;
    }
}
- (void) downGravity
{
    if (self.position.y < 310) {
        _reverseGravityTriggered = false;
    }
}

- (void) outOfWaterGravity
{
    _crossedWater = !_crossedWater;
}

- (void) reduceOutOfWaterForce
{
    
}

+ (float) characterPosition
{
    return characterPosition;
}

#pragma mark - teleport method

- (void)teleport
{
    if (!_teleportCD) {
        self.cascadeOpacityEnabled = YES;
        CCActionFadeOut *fadeOut = [CCActionFadeOut actionWithDuration:.5f];
        CCActionFadeIn *fadeIn = [CCActionFadeIn actionWithDuration:.25f];
        
        float randomTeleportPoint = arc4random() % 72 + 72;
        
        CCActionMoveBy *offsetPosition = [CCActionMoveBy actionWithDuration:0.f position:ccp(randomTeleportPoint, .5)];
        CCActionSequence *teleportFadeIn = [CCActionSequence actions:fadeOut, offsetPosition, fadeIn, nil];
        
        [self runAction:teleportFadeIn];
        _teleportCD = YES;
        _didCollide = NO;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _teleportCD = NO;
        });
    }
}


#pragma mark - reset jump

- (void)resetJump
{
    _didJump = FALSE;
}

- (void) update:(CCTime)delta
{
    characterPosition = self.position.y;
}


@end
