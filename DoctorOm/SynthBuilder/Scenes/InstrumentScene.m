/*
 *  InstrumentScene.m
 *  Noisemusick
 *
 *  Created by Shawn Wallace on 10/1/11.
 *  Copyright (c) 2011-2012 by Shawn Wallace of the Fluxama Group. 
 *  For information on usage and redistribution, and for a DISCLAIMER OF ALL
 *  WARRANTIES, see the file, "Noisemusick-LICENSE.txt," in this distribution.  */

#import "AppDelegate.h"
#import "InstrumentScene.h"
#import "ccMacros.h"
#import "Control.h"
#import "Instrument.h"
#import "Sequence.h"
#import "Pot.h"

#define NUM_STEPS 16
#define BASEBEATS 30.0f

@implementation InstrumentScene
@synthesize instrument_name;
@synthesize helpLayer;

-(id) init {
    self = [super init];
    if (self != nil) {
	    layer = [InstrumentLayer node];
        [self addChild:layer z:1 ]; 
		instrument_name = [NSString alloc];
        nav_menu = [NavMenu node];
        if (IS_IPAD()) {
            [nav_menu setPosition:ccp(932, 25)];
        } else {
            [nav_menu setPosition:ccp(410, 15)];
        }
        [self addChild:nav_menu z:50];
        [nav_menu moveToClosedState];
        
        // Create the Info Menu
        infoLayer = [CCSprite spriteWithFile:@"InfoLayer.png"];
        [infoLayer setPosition:ccp(SCREEN_CENTER_X, SCREEN_CENTER_Y)];
        [infoLayer setVisible:false];
        [self addChild:infoLayer z:100];
        
        infoMenu = [CCMenu menuWithItems:nil ];
        
        CCMenuItemImage *infoNM = [CCMenuItemImage 
                                   itemWithNormalImage:@"InfoNM.png"
                                   selectedImage:@"InfoNMSelected.png"
                                   target:self
                                   selector:@selector(gotoNM:)];
        CCMenuItemImage *infoDrom = [CCMenuItemImage 
                                     itemWithNormalImage:@"InfoDrom.png"
                                     selectedImage:@"InfoDromSelected.png"
                                     target:self
                                     selector:@selector(gotoDrom:)];
        
        CCMenuItemImage *infoFB = [CCMenuItemImage 
                                   itemWithNormalImage:@"InfoFacebook.png"
                                   selectedImage:@"InfoFacebookSelected.png"
                                   target:self
                                   selector:@selector(gotoFB:)];
        
        CCMenuItemImage *infoTwitter = [CCMenuItemImage 
                                        itemWithNormalImage:@"InfoTwitter.png"
                                        selectedImage:@"InfoTwitterSelected.png"
                                        target:self
                                        selector:@selector(gotoTwitter:)];
        
        CCMenuItemImage *infoWeb = [CCMenuItemImage 
                                    itemWithNormalImage:@"InfoFluxama.png"
                                    selectedImage:@"InfoFluxamaSelected.png"
                                    target:self
                                    selector:@selector(gotoWeb:)];
        
        [infoMenu addChild:infoNM];
        [infoMenu addChild:infoDrom];
        [infoMenu addChild:infoFB];
        [infoMenu addChild:infoTwitter];
        [infoMenu addChild:infoWeb];

        [infoMenu alignItemsHorizontallyWithPadding:5];
        [infoMenu setVisible:false];
        [self addChild:infoMenu z:150];
        
        CCMenu *exitButtonMenu = [CCMenu menuWithItems:nil ];
        
        CCMenuItemImage *exitInfoButton = [CCMenuItemImage 
                                           itemWithNormalImage:@"navMenuExit.png"
                                           selectedImage:@"navMenuExit.png"
                                           target:self
                                           selector:@selector(toggleInfo:)];
        [exitButtonMenu addChild:exitInfoButton];
        if (IS_IPAD()) {
            [exitButtonMenu setPosition:ccp(1000, 25)]; 
        } else {
		    [exitButtonMenu setPosition:ccp(465, 15)];
        }
        [infoLayer addChild:exitButtonMenu z:151];
        
    }
    return self;
}

-(void) loadInstrument {
    [layer loadInstrument:instrument_name];
    CCSprite *background = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@.png",instrument_name]];
    [background setAnchorPoint:ccp(0.0f, 0.0f)];
    [layer addChild:background z:-10];
}

-(void) toggleInfo: (id)sender {
    infoMenu.visible = !infoLayer.visible;
    infoLayer.visible = !infoLayer.visible;
    layer.visible = !layer.visible;
    nav_menu.visible = !nav_menu.visible;
}

-(void) toggleHelp: (id)sender {
    [layer toggleHelp:sender];
}

-(void) toggleNav {
  nav_menu.visible = !nav_menu.visible;
}

- (void) gotoNM: (id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.com/apps/Noisemusick"]];
}
- (void) gotoDrom: (id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.com/apps/Drom"]];
}
- (void) gotoFB: (id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/fluxamacorp"]];
}
- (void) gotoTwitter: (id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.twitter.com/fluxama"]];
}
- (void) gotoWeb: (id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.fluxama.com"]];
}

- (void) dealloc
{	
    //CCLOG(@"Dealloc InstrumentScene");
    [instrument_name release];
    //CCLOG(@"call super");
    //layer = nil;
	[super dealloc];
}

@end

@implementation InstrumentLayer

//@synthesize audioController = _audioController;
//@synthesize fileReference = fileReference_;

Instrument *instrument_def;
int selectedControl;

-(id) init {
	if( (self=[super init] )) {
  
		// enable touches
       [self setIsTouchEnabled:YES];
        
		// enable accelerometer
        [self setIsAccelerometerEnabled:YES];
        
        touchCount = 0;
        touchList = CFDictionaryCreateMutable(NULL, 0, 
                                              &kCFTypeDictionaryKeyCallBacks, 
                                              &kCFTypeDictionaryValueCallBacks);
        // Read the saved state
        
        NSString *errorDesc = nil;
        NSError *error = nil;
        BOOL success;
        NSPropertyListFormat format;
        NSString *plistPath;
        NSFileManager* fileManager = [NSFileManager defaultManager]; 
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *savedStatePath = [documentsDirectory stringByAppendingPathComponent:@"savedState.plist"];
        success = [fileManager fileExistsAtPath:savedStatePath];
        if (!success) {
            plistPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"savedState.plist"];
            success = [fileManager copyItemAtPath:plistPath toPath:savedStatePath error:&error]; 
        }

        /*NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
																  NSUserDomainMask, YES) objectAtIndex:0];
        plistPath = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"savedState.plist"]];
        if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
            plistPath = [[NSBundle mainBundle] pathForResource:@"savedState" ofType:@"plist"];
        }
         */
		CCLOG(@"Path: %@",savedStatePath);
		
        NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:savedStatePath];
        savedState = (NSMutableDictionary *)[NSPropertyListSerialization
											  propertyListFromData:plistXML
											  mutabilityOption:NSPropertyListMutableContainersAndLeaves
											  format:&format
											  errorDescription:&errorDesc];
        if (!savedState) {
            NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
        }
        
        [savedState retain];
        
        CCLOG(@"Retrieved value: %3.3f",[[savedState objectForKey:@"pot_a1"] floatValue]);
        
        beats = BASEBEATS;
		[self schedule: @selector(tick:) ];
        
	}
	return self;
}

- (void) loadInstrument: (NSString *) name {
	instrument_def = [[Instrument alloc] initWithName:name];
    
	for (int i=0; i<[instrument_def.interactive_inputs count]; i++) {
		Control *c = [instrument_def.interactive_inputs objectAtIndex:i];
		c.position = ccp(c.control_x, c.control_y);
        c.tag = CONTROL_TAG;
        if (savedState) {
            CCLOG(@"Key: %@",c.control_id);
            CCLOG(@"Retrieved value: %3.3f",[[savedState objectForKey:c.control_id] floatValue]);
            c.control_value = [[savedState valueForKey:c.control_id] floatValue];
            [c updateViewWithValue];
		}
        [c sendControlValues];
        [self addChild:c z:4];
	}
    [(AppController*)[[UIApplication sharedApplication] delegate] turnOnSound];
    LEDLayer = [CCSprite spriteWithFile:@"LedGlow.png"];
    //[LEDLayer setBlendFunc: (ccBlendFunc) { GL_SRC_ALPHA, GL_ONE }];
    [LEDLayer setBlendFunc: (ccBlendFunc) { GL_ONE, GL_ONE_MINUS_SRC_COLOR }];
    
    if (IS_IPAD()) {
        LEDLayer.position = ccp(241*IPAD_MULT-1,106*IPAD_MULT+IPAD_BOT_TRIM-1); 
    } else {
        LEDLayer.position = ccp(240,239);
    }
    LEDState = FALSE;
    [self addChild:LEDLayer z:-3];
    
    // Create the Help Menu
    
    helpMenu = [CCMenu menuWithItems:nil ];
    
    CCMenuItemImage *exitHelpButton = [CCMenuItemImage 
                                       itemWithNormalImage:@"navMenuExit.png"
                                       selectedImage:@"navMenuExit.png"
                                       target:self
                                       selector:@selector(toggleHelp:)];
    
    [helpMenu addChild:exitHelpButton];
    if (IS_IPAD()) {
        [helpMenu setPosition:ccp(1000, 25)]; 
    } else {
        [helpMenu setPosition:ccp(465, 15)];
    }
    [helpMenu setVisible:false];
    [self addChild:helpMenu z:150];
    
    helpLayer = [HelpLayer node];
    [helpLayer setPosition:ccp(SCREEN_CENTER_X,SCREEN_CENTER_Y-(HELP_SCREEN_H/2-SCREEN_CENTER_Y))];
    [helpLayer setVisible:false];

    [self addChild:helpLayer z:100];
}

- (void) draw {
    [super draw];
}

-(void) tick: (ccTime) dt {
    if (beat_count < 0) {
        beat_count = beats;
        LEDState = !LEDState;
        LEDLayer.visible = LEDState;
    }
    beat_count--;
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGPoint location;
    
    for (UITouch *touch in touches) {
        location = [touch locationInView: [touch view]];
        location  = [[CCDirector sharedDirector] convertToGL:location ];
        if ((self.visible) && !(helpLayer.visible)) {
            bool touchedAlready = FALSE;
            for (int i=0; i<[instrument_def.interactive_inputs count]; i++) {
                Control *c = [instrument_def.interactive_inputs objectAtIndex:i];
                if ([c withinBounds:location] && !touchedAlready) {
                    CFDictionarySetValue(touchList, touch, c);
                    
                    [c showHighlight];
                    [c sendOnValues];
                    [c touchAdded:touch];
                    [c updateView:location];
                    [c sendControlValues]; 
                    touchedAlready = TRUE;
                }
            }
        }
        if (helpLayer.visible) {
            helpLayer.firstTouch = location.y;
            helpLayer.origY = helpLayer.position.y;
        }
    }
    
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGPoint location;
    for (UITouch *touch in touches) {
        location = [touch locationInView: [touch view]];
        location  = [[CCDirector sharedDirector] convertToGL:location ];
        if (!(helpLayer.visible)) {
            Control *c = (Control*)CFDictionaryGetValue(touchList, touch);
            if (c != NULL) {
                if ([c.control_id isEqualToString:@"pot1"]) {
                    beats = (1.05-c.control_value)*BASEBEATS;
                    //CCLOG(@"beats %@, %4f",c.control_id, beats);
                }
                if ((c.control_type == TOUCH_AREA) || (c.control_type == ROUND_TOUCH_AREA) || 
                    (c.control_type == TOGGLE_TOUCH) || (c.control_type == PLASMA_MULTI_TOUCH))  {
                    if ([c withinBounds:location]) {
                        [c updateView:location];
                        [c sendControlValues]; 
                    }
                } else {
                    [c updateView:location];
                    if (c.control_sequenced_by == 0) {
                        [c sendControlValues];
                    }   
                }
            }
        } else {
            [helpLayer updateView:location];
        }
    }
    
    
}


- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        Control *c = (Control*)CFDictionaryGetValue(touchList, touch);
        if (c != NULL) {
            [c touchRemoved:touch];
            if (c.control_type == TOGGLE_TOUCH) {   
                c.control_value = 0;
                [c sendOffValues];
            }
            [c hideHighlight];
            CFDictionaryRemoveValue(touchList, touch);
        }
    }
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{
}

- (void) openPatch:(NSString *) patch {  
}

- (void) closePatch {
}

-(void) toggleHelp: (id)sender {
    helpMenu.visible = !helpLayer.visible;
    helpLayer.visible = !helpLayer.visible;
    [(InstrumentScene *)self.parent toggleNav];
}

-(void)showInfo: (id) sender{
}

-(void) nothing:(id)sender {
    //CCLOG(@"Do nothing");
}

- (void) dealloc
{	
    for (int i=0; i<[instrument_def.interactive_inputs count]; i++) {
        Control *c = [instrument_def.interactive_inputs objectAtIndex:i];
        [c sendOffValues];
		[c sendZeroValues];
        CCLOG(@"Retrieved value: %@",c.control_id);
        [savedState setValue:[NSNumber numberWithFloat:c.control_value] forKey:c.control_id];
        CCLOG(@"Retrieved value: %3.3f",[[savedState objectForKey:c.control_id] floatValue]);
	}
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
                      stringByAppendingPathComponent:[NSString stringWithFormat:@"savedState.plist"]];
    if ([savedState writeToFile:path atomically:YES]) {
        CCLOG(@"Wrote saved state file! %@",path);
    } else {
        CCLOG(@"Failed! %@",path);
    }
    [(AppController*)[[UIApplication sharedApplication] delegate] turnOffSound];
    [PdBase sendFloat:0.0f toReceiver:@"kit_number"];
    [self removeAllChildrenWithCleanup:YES];
    [(id)touchList release];
    [savedState release];
    [instrument_def dealloc];
	[super dealloc];

}
@end
