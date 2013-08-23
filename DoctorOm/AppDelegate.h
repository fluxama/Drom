/*
 *  AppDelegate.h
 *  Drom
 *
 *  Created by Elliot Clapp, Shawn Greenlee, and Shawn Wallace
 *  Copyright (c) 2012 by Shawn Wallace of the Fluxama Group. 
 *  For information on usage and redistribution, and for a DISCLAIMER OF ALL
 *  WARRANTIES, see the file, "Drom-LICENSE.txt," in this distribution.  */



#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "cocos2d.h"
#import "PdAudioController.h"
#import "PdDispatcher.h"
#import "Audiobus.h"

@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate>
{
	UIWindow *window_;
	UINavigationController *navController_;
	CCDirectorIOS	*director_;							// weak ref
}

@property (nonatomic, retain) PdAudioController *audioController;
@property (nonatomic, retain) UIWindow *window;
@property (readonly) UINavigationController *navController;
@property (readonly) CCDirectorIOS *director;
-(void) turnOffSound;
-(void) turnOnSound;
@property (strong, nonatomic) ABAudiobusController *audiobusController;
@property (strong, nonatomic) ABAudiobusAudioUnitWrapper *audiobusAudioUnitWrapper;
//- (void) copyDemoPatchesToUserDomain;

@end
