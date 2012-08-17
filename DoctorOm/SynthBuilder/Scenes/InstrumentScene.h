/*
 *  InstrumentScene.h
 *  Drom
 *  http://www.fluxama.com
 *  http://github.com/fluxama
 *
 *  Created by Elliot Clapp, Shawn Greenlee, and Shawn Wallace
 *  Copyright (c) 2012 by Shawn Wallace of the Fluxama Group. 
 *  For information on usage and redistribution, and for a DISCLAIMER OF ALL
 *  WARRANTIES, see the file, "Drom-LICENSE.txt," in this distribution.  */


#import "cocos2d.h"
#import "Control.h"
#import "PdDispatcher.h"
#import "PdAudioController.h"
#import "NavMenu.h"
#import "HelpLayer.h"

@class InstrumentLayer;

// Instrument Layer
@interface InstrumentScene : CCScene
{
	NSString *instrument_name;
	InstrumentLayer *layer;
    CCLayer *infoLayer;
    CCMenu *infoMenu1;
    CCMenu *infoMenu2;
    CCMenu *exitButtonMenu;
    NavMenu *nav_menu;
}

-(void) loadInstrument;
- (void) toggleHelp: (id)sender;
- (void) toggleInfo: (id)sender;
- (void) toggleHelp: (id)sender;
- (void) toggleNav;

- (void) gotoNM: (id)sender;
- (void) gotoDrom: (id)sender;
- (void) gotoFB: (id)sender;
- (void) gotoTwitter: (id)sender;
- (void) gotoWeb: (id)sender;

@property (copy, nonatomic) NSString *instrument_name;
@property (copy, nonatomic) HelpLayer *helpLayer;

@end

@interface InstrumentLayer : CCLayer 
{
    //NSValue *fileReference;
   //PdDispatcher *dispatcher;
    NSUInteger touchCount;
    CFMutableDictionaryRef touchList;
    NSMutableDictionary *savedState;
    CCSprite *LEDLayer;
    CCSprite *LED2Layer;
    CCMenu *helpMenu;
    HelpLayer *helpLayer;
    bool LEDState;
    bool LED2State;
    float beat_count;
    float beats;
    int padsTouched;
    bool screenIsTouched;
    float masterVolume;
    bool instrumentOn;
    NSString *masterVolumeInput;
}   

- (void) loadInstrument: (NSString *) name;
- (void) setMasterVolumeOn;
- (void) setMasterVolumeOff;
- (void) setMasterVolumeValue:(float) val;
- (void) openPatch:(NSString *) patch;
- (void) closePatch;
- (void) toggleHelp: (id)sender;

//@property (nonatomic, retain) PdAudioController *audioController;

@end
