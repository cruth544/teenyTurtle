//
//  GameOver.m
//  OneClickCharlie
//
//  Created by Chad Rutherford on 7/15/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameOver.h"
#import <Social/Social.h>


@implementation GameOver
{
    CCLabelTTF *_gameOverMessage;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void) onEnter
{
    [super onEnter];
    CCLOG(@"Distance traveled for Game Over Message: %i", _distanceForGameOverMessage);
    _gameOverMessage.string = [NSString stringWithFormat:@"You went %im\nbefore getting dying!", _distanceForGameOverMessage];
}

- (void) restartGame
{
    CCScene *gamePlayScene = [CCBReader loadAsScene:@"GamePlayScene"];
    [[CCDirector sharedDirector] replaceScene:gamePlayScene];
}

- (void) gameOverPopUp
{
    self.paused = YES;
}

- (void) showTweetSheet
{
    SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType: SLServiceTypeTwitter];

    // Sets the completion handler.  Note that we don't know which thread the
    // block will be called on, so we need to ensure that any required UI
    // updates occur on the main queue
    tweetSheet.completionHandler = ^(SLComposeViewControllerResult result) {
        switch(result) {
                //  This means the user cancelled without sending the Tweet
            case SLComposeViewControllerResultCancelled:
                break;
                //  This means the user hit 'Send'
            case SLComposeViewControllerResultDone:
                break;
        }
    };
    
    //  Set the initial body of the Tweet
    [tweetSheet setInitialText:[NSString stringWithFormat:@"This game is dope!!! I went %im before dying! @idontknow544", _distanceForGameOverMessage]];
    
    //  Adds an image to the Tweet.  For demo purposes, assume we have an
    //  image named 'larry.png' that we wish to attach
    if (![tweetSheet addImage:[UIImage imageNamed:@"larry.png"]]) {
        NSLog(@"Unable to add the image!");
    }
    
    //  Add an URL to the Tweet.  You can add multiple URLs.
    if (![tweetSheet addURL:[NSURL URLWithString:@"http://twitter.com/"]]){
        NSLog(@"Unable to add the URL!");
    }
    
    //  Presents the Tweet Sheet to the user
    [[CCDirector sharedDirector] presentViewController:tweetSheet animated:NO completion:^{
        NSLog(@"Tweet sheet has been presented.");
    }];
}

- (void) showFacebookSheet
{
    SLComposeViewController *facebookSheet = [SLComposeViewController composeViewControllerForServiceType: SLServiceTypeFacebook];
    // Sets the completion handler.  Note that we don't know which thread the
    // block will be called on, so we need to ensure that any required UI
    // updates occur on the main queue
    facebookSheet.completionHandler = ^(SLComposeViewControllerResult result) {
        switch(result) {
                //  This means the user cancelled without sending the Tweet
            case SLComposeViewControllerResultCancelled:
                break;
                //  This means the user hit 'Send'
            case SLComposeViewControllerResultDone:
                break;
        }
    };
    
    //  Set the initial body of the Tweet
    [facebookSheet setInitialText:[NSString stringWithFormat:@"This game is dope!!! I went %im before dying! @Chad Rutherford", _distanceForGameOverMessage]];
    
    //  Adds an image to the Tweet.  For demo purposes, assume we have an
    //  image named 'larry.png' that we wish to attach
    if (![facebookSheet addImage:[UIImage imageNamed:@"larry.png"]]) {
        NSLog(@"Unable to add the image!");
    }
    
    //  Add an URL to the Tweet.  You can add multiple URLs.
    if (![facebookSheet addURL:[NSURL URLWithString:@"http://facebook.com/"]]){
        NSLog(@"Unable to add the URL!");
    }
    
    //  Presents the Tweet Sheet to the user
    [[CCDirector sharedDirector] presentViewController:facebookSheet animated:NO completion:^{
        NSLog(@"Tweet sheet has been presented.");
    }];
}


@end
