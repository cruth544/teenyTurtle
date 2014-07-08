//
//  GamePlayScene.m
//  OneClickCharlie
//
//  Created by Chad Rutherford on 7/3/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GamePlayScene.h"
#import "Character.h"
#import "Levels.h"


typedef NS_ENUM(NSInteger, CharacterFunction) {
    Jump,
    ReverseGravity,
    Teleport
};

@implementation GamePlayScene {
    CCPhysicsNode *_physicsNode;
    int _levelCounter;
    Character *_character;
    int _methodChooser;
    CharacterFunction _currentFunction;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _currentFunction = Jump;
    }
    
    return self;
}

-(void)didLoadFromCCB {
    
    //enabling userinteraction
    self.userInteractionEnabled = YES;
    //adding level to gamePlayScene Node
    CCScene *level = [CCBReader loadAsScene:[NSString stringWithFormat:@"Levels/Level1"]];
    [_physicsNode addChild:level];
    
    
    
    
}



-(void)onEnter {
    [super onEnter];
}

//switch statement to choose which character function to call on touch
-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    switch (_currentFunction) {
            
        case Jump:
            [_character jump];
            break;
            
        case ReverseGravity:
            [_character reverseGravity];
            break;
            
        case Teleport:
//            [_character teleport];
            break;
        default:
            break;
    }
}



@end
