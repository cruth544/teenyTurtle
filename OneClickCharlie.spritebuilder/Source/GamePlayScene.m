//
//  GamePlayScene.m
//  OneClickCharlie
//
//  Created by Chad Rutherford on 7/3/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GamePlayScene.h"
#import "Character.h"
#import "ObstacleHolder.h"
#import "GameOver.h"
#import "Shark.h"
#import "Starfish.h"


static BOOL hasGameBeenPlayed;

@implementation GamePlayScene
{
    CCPhysicsNode *_physicsNode;

    Character *_characterNode;
    Shark *_sharkNode;
    Starfish *_starfishNode;
    
    int _scoreNumber;
    CCLabelTTF *_score;
    
    CCNode *_mainMenu;
    
    GameOver *gameOverVar;
    
    NSMutableArray *_levelsGroup;
    CCNode *_obstacles;
    
//TODO: finish Tutorial
    BOOL _finishedTutorial;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _levelsGroup = [NSMutableArray array];
        _scoreNumber = 0;
    }
    
    return self;
}


#pragma mark - Did Load From CCB

-(void) didLoadFromCCB
{
    //enabling userinteraction
    self.userInteractionEnabled = YES;
    //adding level to gamePlayScene Node
    CCNode *level = [CCBReader load:@"Levels/MainLevel"];
    [_physicsNode addChild:level];

    _characterNode = (Character *)[CCBReader load:@"Character"];
    [_physicsNode addChild:_characterNode z:99];
    _characterNode.physicsBody.collisionType = @"character";
    [_characterNode setPosition:ccp(25, 36)];
    
    _sharkNode = (Shark *)[CCBReader load:@"Shark"];
    _sharkNode.turtleTarget = _characterNode;
    [_physicsNode addChild:_sharkNode z:100];
    _sharkNode.physicsBody.collisionType = @"shark";
    [_sharkNode setPosition:ccp(0, 0)];
    
    self.paused = YES;
    
    if (!hasGameBeenPlayed) {
        _mainMenu = [CCBReader load:@"MainMenu" owner:self];
        [self addChild:_mainMenu];
    } else {
        self.paused = NO;
        _characterNode.paused = NO;
        _sharkNode.paused = NO;
    }
    
    for (int i = 0; i < 5; i++) {
        CCNode *looper = [CCBReader load:@"Levels/LoopingLevel"];
        [_levelsGroup addObject:looper];
        [_physicsNode addChild:looper];

        if (i == 0) {
            looper.position = ccp(648, 0);
        } else {
            looper.position = ccp(looper.contentSize.width * i + 648, 0);
        }
    }
    
    _physicsNode.collisionDelegate = self;

//    left Swipe Recognizer
    UISwipeGestureRecognizer *backwardRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backwardSwipeHandle:)];
    backwardRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:backwardRecognizer];

//    right Swipe Recognizer
    UISwipeGestureRecognizer *forwardRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(forwardSwipeHandle:)];
    forwardRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:forwardRecognizer];
    
//    up Swipe Recognizer
    UISwipeGestureRecognizer *upwardRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(upwardSwipeHandle:)];
    upwardRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:upwardRecognizer];
//    down Swipe Recognizer
    UISwipeGestureRecognizer *downwardRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(downwardSwipeHandle:)];
    downwardRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:downwardRecognizer];
}


#pragma mark - On Enter

- (void) onEnter
{
    [super onEnter];
    CGFloat width = [[CCDirector sharedDirector] viewSize].width;
    CCActionFollow *follow = [CCActionFollow actionWithTarget:_characterNode worldBoundary:CGRectMake(0.f, 0.f, CGFLOAT_MAX, width)];
    [_physicsNode runAction:follow];
}


#pragma mark - Touch Methods

//switch statement to choose which character function to call on touch
- (void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{

}

- (void) touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

- (void) touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

- (void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
//    [_characterNode jump];
}


#pragma mark - Swipe Handlers

- (void) backwardSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer
{
    
}

- (void) forwardSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [_characterNode teleport];
}

- (void) upwardSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [_characterNode upGravity];
}

- (void) downwardSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [_characterNode downGravity];
}


#pragma mark - Collision Delegate

- (BOOL) ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair character:(Character *)character wall:(CCNode *)wall
{
    character.didCollide = true;
    character.characterSpeed = 40.f;
    return YES;
}

-(void)ccPhysicsCollisionSeparate:(CCPhysicsCollisionPair *)pair character:(Character *)character wall:(CCNode *)wall;
{
    character.characterSpeed = 0.f;
}

- (BOOL) ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair character:(Character *)character ground:(CCNode *)ground
{
    character.didCollide = false;
    character.characterSpeed = 100.f;
    return YES;
}

- (BOOL) ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair character:(Character *)character clam:(CCNode *)clam
{
    self.paused = YES;
    [self gameOverPopup];
    return YES;
}

- (BOOL) ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair character:(Character *)character shark:(CCNode *)shark
{
    self.paused = YES;
    [self gameOverPopup];
    return YES;
}

- (BOOL) ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair character:(Character *)character starfish:(CCNode *)starfish
{
    [self removeStarfish:starfish];
    CCLOG(@"got starfish");
    return YES;
}


#pragma mark - Custom Methods

- (void) startGame
{
    [_mainMenu removeFromParent];
    self.paused = NO;
    _characterNode.paused = NO;
    _sharkNode.paused = NO;
    _score.visible = YES;
}

- (void) tutorial
{
    
//    CCScene *tutorialPageScene = [[CCScene alloc] init];
//    Tutorial *tutorialNode = (Tutorial *)[CCBReader load:[NSString stringWithFormat:@"Tutorials/Tutorial%i", _tutorialPage]];
//    tutorialNode.tutorialPage = self.tutorialPage + 1;
//    [tutorialPageScene addChild:tutorialNode];
//    [[CCDirector sharedDirector] replaceScene:tutorialPageScene];
    
}

- (void) loopLevel
{
    for (ObstacleHolder *_level in _levelsGroup) {
        // get the world position of the ground
        float levelSize = _level.contentSize.width;
        CGPoint levelWorldPosition = [_physicsNode convertToWorldSpace:_level.position];
        // get the screen position of the ground
        CGPoint levelScreenPosition = [self convertToNodeSpace:levelWorldPosition];
        // if the left corner is one complete width off the screen, move it to the right
        
        if (levelScreenPosition.x <= (-1 * levelSize)) {
            _level.position = ccp(_level.position.x + 5 * _level.contentSize.width, _level.position.y);
            [_level reinitialize];
        }
    }
}

- (void) removeStarfish:(CCNode *)starfish
{
//    [[OALSimpleAudio sharedInstance] playEffect:@"GruntBirthdayParty.mp3"];
    [starfish removeFromParent];
}

- (void) gameOverPopup
{
    hasGameBeenPlayed = YES;
    GameOver *popup = (GameOver *)[CCBReader load:@"GameOver" owner:self];
    popup.positionType = CCPositionTypeNormalized;
    popup.position = ccp(0.5, 0.5);
    [self addChild:popup];
}

- (void) scoreCounter
{
        _scoreNumber ++;
        _score.string = [NSString stringWithFormat:@"%d", _scoreNumber];
}

//TODO: Add distance from shark
- (void) findDistance
{
    CGFloat distanceBetweenCharAndShark = ccpDistance(_characterNode.position, _sharkNode.position);
}

#pragma mark - Update Method

- (void) update:(CCTime)delta
{
    [self loopLevel];
    
    if (_characterNode.position.y > 275) {
        if (_characterNode.characterSpeed > 30.f) {
            _characterNode.characterSpeed -= 1.f;
        } else {
            _characterNode.characterSpeed = 30.f;
            _characterNode.didCollide = false;
        }
    }
    if (_characterNode.position.x > 600) {
        [self scoreCounter];
    }
    
    if (_characterNode.position.y > 300 && !_characterNode.crossedWater && _characterNode.reverseGravityTriggered) {
        [_characterNode outOfWaterGravity];
    } else if (_characterNode.position.y < 300 && _characterNode.crossedWater) {
        [_characterNode outOfWaterGravity];
    }
    
    if (CGRectGetMinY(_characterNode.boundingBox) < CGRectGetMinY(_physicsNode.boundingBox)) {
        self.paused = YES;
        [self gameOverPopup];
    }
}

@end