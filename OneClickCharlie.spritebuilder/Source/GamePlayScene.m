//
//  GamePlayScene.m
//  OneClickCharlie
//
//  Created by Chad Rutherford on 7/3/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GamePlaySceneProtected.h"
#import "Character.h"
#import "ObstacleHolder.h"
#import "GameOver.h"
#import "Shark.h"
#import "Starfish.h"
#import "NSUserDefaults+Encryption.h"



static BOOL hasGameBeenPlayed;
//TODO: finish Tutorial

@implementation GamePlayScene
{
    CCPhysicsNode *_physicsNode;

    Character *_characterNode;
    Shark *_sharkNode;
    BOOL _sharkHasLoaded;
    
    Starfish *_starfishNode;
    
    int _starfishCollectedThisGame;
    NSNumber *_numberOfStarfish;
    CCLabelTTF *_numberOfStarsCollected;
    
    CCNode *_turtleReferencePosition;
    CCSprite *_sharkReferenceSprite;
    
    int _distanceNumber;
    CCLabelTTF *_score;
    
    CCNodeColor *_oxygenMeter;
    
    CCNode *_mainMenu;
    
    GameOver *gameOverVar;
    
    NSMutableArray *_levelsGroup;
//    CCNode *_obstacles;
    ObstacleHolder *obstacleHolderClassVar;
    CCNode *_obstacleForTutorial;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _levelsGroup = [NSMutableArray array];
        _distanceNumber = 0;
    }
    
    return self;
}


#pragma mark - Did Load From CCB

-(void) didLoadFromCCB
{
    //enabling userinteraction
    self.userInteractionEnabled = YES;
    
    if (runningTutorial) {
        [self loadTutorial];
    } else {
        
        //adding level to gamePlayScene Node
        CCNode *level = [CCBReader load:@"Levels/Beach"];
        [_physicsNode addChild:level];
        
        [self loadTurtle];
//        [self loadShark];
//            _sharkNode.visible = NO;
        
        self.paused = YES;
        
        if (!hasGameBeenPlayed) {
            _mainMenu = [CCBReader load:@"MainMenu" owner:self];
            [self addChild:_mainMenu];
        } else {
            self.paused = NO;
            _characterNode.paused = NO;
        }
        
        [self loadLevel];
    }
    
    _physicsNode.collisionDelegate = self;

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
    
    [[NSUserDefaults standardUserDefaults] setEncryptionKey:@"myencryptionkey!"];
}


#pragma mark - Touch Methods

//switch statement to choose which character function to call on touch
- (void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{

}

- (void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
//    [_characterNode jump];
}


#pragma mark - Swipe Handlers

- (void) forwardSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer
{
//    [_characterNode teleport];
//    _characterNode.didCollide = true;
}

- (void) upwardSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer
{
    if (!runningTutorial) {
        [_characterNode upGravity];
    }
}

- (void) downwardSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer
{
    if (!runningTutorial) {
        [_characterNode downGravity];
    }
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
    [self gameOverPopup];
    return YES;
}

- (BOOL) ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair character:(Character *)character shark:(CCNode *)shark
{
    [self gameOverPopup];
    return YES;
}

- (BOOL) ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair character:(Character *)character starfish:(CCNode *)starfish
{
    [self removeStarfish:starfish];
    _starfishCollectedThisGame ++;
    return YES;
}

#pragma mark - Custom Methods

#pragma mark Loading Methods
- (void) loadTurtle
{
    _characterNode = (Character *)[CCBReader load:@"Turtle"];
    [_physicsNode addChild:_characterNode z:99];
    _characterNode.physicsBody.collisionType = @"character";
    [_characterNode setPosition:ccp(50, 330)];
}

- (void) loadShark
{
    _sharkNode = (Shark *)[CCBReader load:@"Shark"];
    _sharkNode.turtleTarget = _characterNode;
    [_physicsNode addChild:_sharkNode z:100];
    _sharkNode.physicsBody.collisionType = @"shark";
    [_sharkNode setPosition:ccp(600, -100)];
    _sharkHasLoaded = YES;
}

- (void) loadLevel
{
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
}

#pragma mark Begining Methods
- (void) startGame
{
    [_mainMenu removeFromParent];
    
    [self unpauseEverything];
}

- (void) unpauseEverything
{
    self.paused = NO;
    _characterNode.paused = NO;
}

- (void) showDistanceSprites
{
    _score.visible = YES;
    _oxygenMeter.visible = YES;
    
    _turtleReferencePosition.visible = YES;
    _sharkReferenceSprite.visible = YES;
}

#pragma mark Tutorial

- (void) startTutorial
{
    runningTutorial = YES;
    CCScene *startTutorial = [CCBReader loadAsScene:@"GamePlayScene"];
    [[CCDirector sharedDirector] replaceScene:startTutorial];
    [self loadTurtle];
        [_characterNode setPosition:ccp(20, 18)];
}

- (void) loadTutorial
{
    obstacleHolderClassVar.tutorialIsRunning = YES;
    for (int i = 0; i < 12; i++) {
        CCNode *looper = [CCBReader load:@"Levels/LevelForTutorial"];
        [_levelsGroup addObject:looper];
        [_physicsNode addChild:looper];
        looper.position = ccp(looper.contentSize.width * i, 0);
        
        if (i <= 5 || i == 7 || i == 10) {
            CCNode *addGap = [CCBReader load:@"Gap"];
            [_obstacleForTutorial addChild:addGap];
            [addGap setPosition:ccp(0, 0)];
        } else if (i == 6) {
            CCNode *addFirstWall = [CCBReader load:@"Wall"];
            [_obstacleForTutorial addChild:addFirstWall];
            CCNode *swipeUpGesture = [CCBReader load:@"Live Tutorial/TutorialSwipeUp"];
            swipeUpGesture.position = ccp(looper.contentSize.width * 5, 0);
        } else if (i == 8) {
            CCNode *addSecondWall = [CCBReader load:@"Wall"];
            [_obstacleForTutorial addChild:addSecondWall];
            [addSecondWall setPosition:ccp(0, 200)];
            CCNode *swipeUpGesture = [CCBReader load:@"Live Tutorial/TutorialSwipeUp"];
            swipeUpGesture.position = ccp(looper.contentSize.width * 5, 0);
        } else if (i == 9) {
            CCNode *addClam = [CCBReader load:@"Clam"];
            [_obstacleForTutorial addChild:addClam];
        } else if (i == 11) {
            CCNode *wallForSharkAttack = [CCBReader load:@"Wall"];
            [_obstacleForTutorial addChild:wallForSharkAttack];
        }
    }
}

#pragma mark Levels


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

#pragma mark Game Over
- (void) gameOverPopup
{
    self.paused = YES;
    hasGameBeenPlayed = YES;

    _numberOfStarfish = [[NSUserDefaults standardUserDefaults] objectEncryptedForKey:@"EB4ZTSTnHS8726Y8"];
    _numberOfStarfish = [NSNumber numberWithInt:[_numberOfStarfish intValue] + _starfishCollectedThisGame];
    
    [[NSUserDefaults standardUserDefaults] setObjectEncrypted:_numberOfStarfish forKey:@"EB4ZTSTnHS8726Y8"];

    GameOver *popup = (GameOver *)[CCBReader load:@"GameOver" owner:self];
    popup.distanceForGameOverMessage = _distanceNumber;
    popup.positionType = CCPositionTypeNormalized;
    popup.position = ccp(0.5, 0.5);
    [self addChild:popup];
}

#pragma mark Oxygen Meters
- (void) increaseOxygen
{
    _oxygenMeter.scaleY += 0.005;
}

- (void) decreaseOxygen
{
    _oxygenMeter.scaleY -= 0.001;
}

#pragma mark Score/Star Counter and  Star Removal
- (void) scoreCounter
{
    _distanceNumber = (_characterNode.position.x - 600) / 2;
    _score.string = [NSString stringWithFormat:@"%dm", _distanceNumber];
}

- (void) starfishScore
{
    _numberOfStarsCollected.string = [NSString stringWithFormat:@"%i", _starfishCollectedThisGame];
}

- (void) removeStarfish:(CCNode *)starfish
{
//    [[OALSimpleAudio sharedInstance] playEffect:@"GruntBirthdayParty.mp3"];
    [starfish removeFromParent];
}

#pragma mark Find Distance
- (CGFloat) findDistance
{
    return (_characterNode.position.x - _sharkNode.position.x) / 3;
}

- (void) setDistanceOfSharkAndTurtle
{
    _turtleReferencePosition.position = ccp([self findDistance] + 20, 0);
}

#pragma mark - Update Method

- (void) update:(CCTime)delta
{
    if (runningTutorial) {
        
    } else {
    
        [self loopLevel];

        if (_characterNode.position.y > 275 && _characterNode.position.x > 600) {
            if (_characterNode.characterSpeed > 30.f) {
                _characterNode.characterSpeed -= 1.f;
            } else {
                _characterNode.characterSpeed = 30.f;
                _characterNode.didCollide = false;
            }
        } else if (_characterNode.position.y > 50 && _characterNode.position.y < 275) {
            if (_characterNode.characterSpeed > 70) {
                _characterNode.characterSpeed -= 1.f;
            } else {
                _characterNode.characterSpeed = 70.f;
                _characterNode.didCollide = false;
            }
        }
        
        [self setDistanceOfSharkAndTurtle];
        [self starfishScore];
        
        if (_characterNode.position.x > 600) {
            [self scoreCounter];
            [self showDistanceSprites];
            _sharkNode.paused = NO;
        }
        
        if (_characterNode.position.x > 600 && !_sharkHasLoaded) {
            [self loadShark];
        }
        
        if (_characterNode.position.y > 280 && _characterNode.position.x > 600 && _oxygenMeter.scaleY <= 1) {
            [self increaseOxygen];
        } else if (_characterNode.position.y < 280 && _characterNode.position.x > 600 && _oxygenMeter.scaleY > 0.002) {
            [self decreaseOxygen];
        } else if (_oxygenMeter.scaleY <= 0.002) {
            [self gameOverPopup];
        }
        
        if (_characterNode.position.y > 300 && !_characterNode.crossedWater && _characterNode.reverseGravityTriggered) {
            [_characterNode outOfWaterGravity];
        } else if (_characterNode.position.y < 300 && _characterNode.crossedWater) {
            [_characterNode outOfWaterGravity];
        }
        
        if (CGRectGetMinY(_characterNode.boundingBox) < CGRectGetMinY(_physicsNode.boundingBox)) {
            [self gameOverPopup];
        }
    }
}

@end
