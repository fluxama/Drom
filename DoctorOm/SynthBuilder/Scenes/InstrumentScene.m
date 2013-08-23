/*
 *  InstrumentScene.m
 *  Drom
 *  http://www.fluxama.com
 *  http://github.com/fluxama
 *
 *  Created by Elliot Clapp, Shawn Greenlee, and Shawn Wallace
 *  Copyright (c) 2012 by Shawn Wallace of the Fluxama Group. 
 *  For information on usage and redistribution, and for a DISCLAIMER OF ALL
 *  WARRANTIES, see the file, "Drom-LICENSE.txt," in this distribution.  
 */

#import "AppDelegate.h"
#import "InstrumentScene.h"
#import "ccMacros.h"
#import "Control.h"
#import "Instrument.h"
#import "Sequence.h"
#import "Pot.h"
#import "PGMidi.h"

#define NUM_STEPS 16
#define BASEBEATS 10.0f

@implementation InstrumentScene
@synthesize instrument_name;
@synthesize helpLayer;

-(id) init {
    self = [super init];
    if (self != nil) {
        
        midi=[[PGMidi alloc]init];
        [midi setNetworkEnabled:YES];
        [midi setVirtualDestinationEnabled:NO];
        [midi.virtualDestinationSource addDelegate:self];
        
        //midi setup
        midi.delegate=self;
        if([midi.sources count]>0){
            if([midi.sources count] == 2){
              [self setMidiSourceIndex:1];
            } else {
              [self setMidiSourceIndex:0];
            }
        }
       // if([midi.destinations count]>0){
       //     [self setMidiDestinationIndex:0];//connect to first device in MIDI source list
       // }

        layer = [InstrumentLayer node];
        [self addChild:layer z:1 ]; 
		instrument_name = [NSString alloc];
        nav_menu = [NavMenu node];
        if (IS_IPAD) {
            [nav_menu setPosition:ccp(933, 25)];
        } else if (IS_IPHONE_5) {
            [nav_menu setPosition:ccp(498, 15)];
        } else {
            [nav_menu setPosition:ccp(410, 15)];
        }
        [self addChild:nav_menu z:50];
        [nav_menu moveToClosedState];
        
        // Create the Info Menu
        infoLayer = [CCSprite spriteWithFile:@"MenuBackground.png"];
        [infoLayer setPosition:ccp(SCREEN_CENTER_X, SCREEN_CENTER_Y)];
        [infoLayer setVisible:false];
        [self addChild:infoLayer z:100];
        
        infoMenu1 = [CCMenu menuWithItems:nil ];
        infoMenu2 = [CCMenu menuWithItems:nil ];
        
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
        
        [infoMenu1 addChild:infoNM];
        [infoMenu1 addChild:infoDrom];
        
        [infoMenu2 addChild:infoFB];
        [infoMenu2 addChild:infoTwitter];
        [infoMenu2 addChild:infoWeb];

        [infoMenu1 alignItemsHorizontallyWithPadding:5];
        [infoMenu1 setVisible:false];
        [infoMenu1 setPosition:ccp(SCREEN_CENTER_X, SCREEN_CENTER_Y+INFO_ICON_H/2-3)];
        [self addChild:infoMenu1 z:150];
        
        [infoMenu2 alignItemsHorizontallyWithPadding:5];
        [infoMenu2 setVisible:false];
        [infoMenu2 setPosition:ccp(SCREEN_CENTER_X, SCREEN_CENTER_Y-INFO_ICON_H/2-3)];
        [self addChild:infoMenu2 z:150];
        
        exitButtonMenu = [CCMenu menuWithItems:nil ];
        [exitButtonMenu setVisible:false];
        CCMenuItemImage *exitInfoButton = [CCMenuItemImage 
                                           itemWithNormalImage:@"navMenuExit.png"
                                           selectedImage:@"navMenuExit.png"
                                           target:self
                                           selector:@selector(toggleInfo:)];
        [exitButtonMenu addChild:exitInfoButton];
        [exitButtonMenu alignItemsHorizontallyWithPadding:0];
        if (IS_IPAD) {
            [exitButtonMenu setPosition:ccp(1000, 25)];
        } else if (IS_IPHONE_5) {
            [exitButtonMenu setPosition:ccp(551, 15)];
        } else {
		    [exitButtonMenu setPosition:ccp(463, 15)];
        }
        [self addChild:exitButtonMenu z:150];
        //[infoLayer addChild:exitButtonMenu z:151];
        
    }
    return self;
}

-(void) loadInstrument {
    [layer loadInstrument:instrument_name];
    CCSprite *background = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@.png",instrument_name]];
    [background setPosition:ccp(SCREEN_CENTER_X, SCREEN_CENTER_Y)];
    
    [layer addChild:background z:-10];
}

-(void) toggleInfo: (id)sender {
    infoMenu1.visible = !infoLayer.visible;
    infoMenu2.visible = !infoLayer.visible;
    exitButtonMenu.visible = !exitButtonMenu.visible;
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
    [[UIApplication sharedApplication] 
     openURL:[NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=555409573"]];
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

-(PGMidi*) midi{
    return midi;
}

//==== pgmidi delegate methods
- (void) midi:(PGMidi*)midi sourceAdded:(PGMidiSource *)source
{
    printf("\nmidi source added");
    
}

- (void) midi:(PGMidi*)midi sourceRemoved:(PGMidiSource *)source{
}


- (void) midi:(PGMidi*)midi destinationAdded:(PGMidiDestination *)destination{
    NSLog(@"added %@", destination.name);
}

- (void) midi:(PGMidi*)midi destinationRemoved:(PGMidiDestination *)destination{
    NSLog(@"removed %@", destination.name);
}


-(NSMutableArray*)midiSourcesArray{//of PGMIDIConnection, get name connection.name
	return midi.sources;
}

-(void)setMidiSourceIndex:(int)inIndex{
	currMidiSourceIndex=inIndex;
	[currMidiSource removeDelegate:self];
    currMidiSource = [midi.sources objectAtIndex:inIndex];
	[currMidiSource addDelegate:self];
    NSLog(@"set MidiSourceIndex to %d, %@", inIndex, currMidiSource.name);
}

-(void)setMidiDestinationIndex:(int)inIndex{
    currMidiDestinationIndex = inIndex;
    //[currMidiDestination]
    currMidiDestination=[midi.destinations objectAtIndex:inIndex];
    NSLog(@"set MidiDestinationIndex to %d, %@", inIndex, currMidiDestination.name);
}


#if TARGET_CPU_ARM
// MIDIPacket must be 4-byte aligned
#define MyMIDIPacketNext(pkt)	((MIDIPacket *)(((uintptr_t)(&(pkt)->data[(pkt)->length]) + 3) & ~3))
#else
#define MyMIDIPacketNext(pkt)	((MIDIPacket *)&(pkt)->data[(pkt)->length])
#endif

- (void) midiSource:(PGMidiSource*)midi midiReceived:(const MIDIPacketList *)packetList{
    
    const MIDIPacket *packet = &packetList->packet[0];
	
    for (int i = 0; i < packetList->numPackets; ++i){
		//chop packets into messages, there could be more than one!
		
		int messageLength;//2 or 3
		/*Byte**/ const unsigned char* statusByte=nil;
		for(int i=0;i<packet->length;i++){//step throguh each byte, i
			if(((packet->data[i] >>7) & 0x01) ==1){//if a newstatus byte
				//send existing
				if(statusByte!=nil)[self performSelectorOnMainThread:@selector(parseMessageData:) withObject:[NSData dataWithBytes:statusByte length:messageLength] waitUntilDone:NO];
				messageLength=0;
				//now point to new start
				statusByte=&packet->data[i];
			}
			messageLength++;
		}
		//send what is left
		[self performSelectorOnMainThread:@selector(parseMessageData:) withObject:[NSData dataWithBytes:statusByte length:messageLength] waitUntilDone:NO];
        
        packet = MyMIDIPacketNext(packet);
    }
	
}

//take messageData, derive the MIDI message type, and send it into PD to be picked up by PD's midi objects
-(void)parseMessageData:(NSData*)messageData{//2 or 3 bytes
	
	
	Byte* bytePtr = ((Byte*)([messageData bytes]));
	char type = ( bytePtr[0] >> 4) & 0x07 ;//remove leading 1 bit 0-7
	char channel = (bytePtr[0] & 0x0F);
    
    for(int i=0;i<[messageData length];i++)
        [PdBase sendMidiByte:currMidiSourceIndex byte:(int)bytePtr[i]];
	
	
    switch (type) {
        case 0://noteoff
            [PdBase sendNoteOn:(int)channel pitch:(int)bytePtr[1] velocity:0];
            break;
        case 1://noteon
            [PdBase sendNoteOn:(int)channel pitch:(int)bytePtr[1] velocity:(int)bytePtr[2]];
            break;
        case 2://poly aftertouch
            [PdBase sendPolyAftertouch:(int)channel pitch:(int)bytePtr[1] value:(int)bytePtr[2]];
            break;
        case 3://CC
            [PdBase sendControlChange:(int)channel controller:(int)bytePtr[1] value:(int)bytePtr[2]];
            break;
        case 4://prgm change
            [PdBase sendProgramChange:(int)channel value:(int)bytePtr[1]];
            break;
        case 5://aftertouch
            [PdBase sendAftertouch:(int)channel value:(int)bytePtr[1]];
            break;
        case 6://pitch bend - lsb, msb
        {
            int bendValue;
            if([messageData length]==3)
                bendValue= (bytePtr[1] | bytePtr[2]<<7) -8192;
            else //2
                bendValue=(bytePtr[1] | bytePtr[1]<<7)-8192;
            [PdBase sendPitchBend:(int)channel value:bendValue];
        }
            break;
            
        default:
            break;
    }
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
		//CCLOG(@"Path: %@",savedStatePath);
		
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
        
        //CCLOG(@"Retrieved value: %3.3f",[[savedState objectForKey:@"pot_a1"] floatValue]);
        
        beats = BASEBEATS;
		[self schedule: @selector(tick:) interval:0.1f ];
	}
	return self;
}

- (void) loadInstrument: (NSString *) name {
    [self setMasterVolumeOff];
	instrument_def = [[Instrument alloc] initWithName:name];
    
	for (int i=0; i<[instrument_def.interactive_inputs count]; i++) {
		Control *c = [instrument_def.interactive_inputs objectAtIndex:i];
		c.position = ccp(c.control_x, c.control_y);
        c.tag = CONTROL_TAG;
        [self addChild:c z:4];
        if (savedState) {
            //CCLOG(@"Key: %@",c.control_id);
            //CCLOG(@"Retrieved value: %3.3f",[[savedState objectForKey:c.control_id] floatValue]);
            c.control_value = [[savedState valueForKey:c.control_id] floatValue];
            [c updateViewWithValue];
		}
        // Note that the following means than an on/off switch has to occur before a volume control in the plist
        if ((c.control_type == VOL_POT)) {
            masterVolumeInput = c.control_patch_input;
            masterVolume = c.control_value;
            if (instrumentOn) {
                [c sendControlValues];
            }
        } else {  
            [c sendControlValues];
        }
	}
    
    if (instrumentOn) {
       //CCLOG(@"Set instrument master volume");
      [self setMasterVolumeOn];
    }
    
   // [(AppController*)[[UIApplication sharedApplication] delegate] turnOnSound];
    LEDLayer = [CCSprite spriteWithFile:@"LedGlow.png"];
    //[LEDLayer setBlendFunc: (ccBlendFunc) { GL_SRC_ALPHA, GL_ONE }];
    [LEDLayer setBlendFunc: (ccBlendFunc) { GL_ONE, GL_ONE_MINUS_SRC_COLOR }];
    
    if (IS_IPAD) {
        LEDLayer.position = ccp(512, 548);
    } else if (IS_IPHONE_5) {
        LEDLayer.position = ccp(284,236);
    } else {
        LEDLayer.position = ccp(240,236);
    }
    LEDState = FALSE;
    LEDLayer.visible = NO;

    [self addChild:LEDLayer z:-3];
    
        // Create the Help Menu
    
    helpMenu = [CCMenu menuWithItems:nil ];
    
    CCMenuItemImage *exitHelpButton = [CCMenuItemImage 
                                       itemWithNormalImage:@"navMenuExit.png"
                                       selectedImage:@"navMenuExit.png"
                                       target:self
                                       selector:@selector(toggleHelp:)];
    
    [helpMenu addChild:exitHelpButton];
    if (IS_IPAD) {
        [helpMenu setPosition:ccp(1000, 25)]; 
    } else if (IS_IPHONE_5) {
        [helpMenu setPosition:ccp(551, 15)];
    } else {
        [helpMenu setPosition:ccp(463, 15)];
    }
    [helpMenu setVisible:false];
    [self addChild:helpMenu z:200];
    
    helpLayer = [HelpLayer node];
    [helpLayer setAnchorPoint:ccp(0,0)];
    [helpLayer setPosition:ccp(0, 0)];
    [helpLayer setVisible:false];

    [self addChild:helpLayer z:100];
}

- (void) draw {
    [super draw];
}

-(void) tick: (ccTime) dt {
    if (instrumentOn) {
        if (beat_count < 0) {
            beat_count = beats;
            LEDLayer.visible = !LEDLayer.visible;
        }
        beat_count--;;
    } else {
         LEDLayer.visible = NO;
    }
}

-(void) setMasterVolumeOn {
    instrumentOn = YES;
    [(AppController*)[[UIApplication sharedApplication] delegate] turnOnSound];
    soundOn = 1;
    [PdBase sendFloat:masterVolume toReceiver:@"masterVolume"];
}

-(void) setMasterVolumeOff {
    instrumentOn = NO;
    soundOn = 0;
    [PdBase sendFloat:0 toReceiver:@"masterVolume"];
}

-(void) setMasterVolumeValue:(float) val {
    //Kind of a hack
    masterVolume = val;
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
                    if ((c.control_type != VOL_POT)) {
                        [c sendControlValues]; 
                    } else {
                        if (instrumentOn) {
                            [c sendControlValues]; 
                        }
                    }
                    touchedAlready = TRUE;
                    // Kind of a hack
                    if ((c.control_type == VOL_POT)) {
                        masterVolume = c.control_value;
                    }

                }
            }
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
                if ([c.control_id isEqualToString:@"speed"]) {
                    beats = (1.05-c.control_value)*BASEBEATS;
                    //CCLOG(@"beats %@, %4f",c.control_id, beats);
                }
                // Kind of a hack
                if ((c.control_type == VOL_POT)) {
                    masterVolume = c.control_value;
                }
                if ((c.control_type == TOUCH_AREA) || (c.control_type == ROUND_TOUCH_AREA) || 
                    (c.control_type == TOGGLE_TOUCH) || (c.control_type == PLASMA_MULTI_TOUCH))  {
                    if ([c withinBounds:location]) {
                        [c updateView:location];
                        [c sendControlValues]; 
                    }
                } else {
                    [c updateView:location];
                    if ((c.control_type != VOL_POT)) {
                        if (c.control_sequenced_by == 0) {
                            [c sendControlValues];
                        }  
                    } else {
                        if (instrumentOn) {
                            [c sendControlValues]; 
                        }
                    }
                }
            }
        } 
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        Control *c = (Control*)CFDictionaryGetValue(touchList, touch);
        if (c != NULL) {
            if (c.control_type == LED_BUTTON) {
                for (int i=0; i<[instrument_def.interactive_inputs count]; i++) {
                    Control *c2 = [instrument_def.interactive_inputs objectAtIndex:i];
                    if (c2.control_type == LED_BUTTON) {
                        c2.control_state = 0;
                     //   [c2 turnOff ];
                    }
                }
            }
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


- (void) dealloc {	
    [PdBase sendFloat:0.0f toReceiver:@"kit_number"];
    for (int i=0; i<[instrument_def.interactive_inputs count]; i++) {
        Control *c = [instrument_def.interactive_inputs objectAtIndex:i];
        //CCLOG(@"Retrieved value: %@",c.control_id);
        [savedState setValue:[NSNumber numberWithFloat:c.control_value] forKey:c.control_id];
        //CCLOG(@"Retrieved value: %3.3f",[[savedState objectForKey:c.control_id] floatValue]);
	}
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
                      stringByAppendingPathComponent:[NSString stringWithFormat:@"savedState.plist"]];
    if ([savedState writeToFile:path atomically:YES]) {
        //CCLOG(@"Wrote saved state file! %@",path);
    } else {
        //CCLOG(@"Failed! %@",path);
    }
    
    [self removeAllChildrenWithCleanup:YES];
    [(id)touchList release];
    [savedState release];
    [instrument_def dealloc];
	[super dealloc];

}
@end
