/*
 *  TwoPosSwitch.m
 *  Drom
 *  http://www.fluxama.com
 *  http://github.com/fluxama
 *
 *  Created by Elliot Clapp, Shawn Greenlee, and Shawn Wallace
 *  Copyright (c) 2012 by Shawn Wallace of the Fluxama Group. 
 *  For information on usage and redistribution, and for a DISCLAIMER OF ALL
 *  WARRANTIES, see the file, "Drom-LICENSE.txt," in this distribution.  */


#import "TwoPosSwitch.h"
#import "instrumentScene.h"

@implementation TwoPosSwitch

-(id) initWithDictionary: (NSDictionary *) params {
	if( (self=[super initWithDictionary: params] )) {
		sprite = [CCSprite spriteWithFile:@"twoPosSwitch0.png"];
		sprite.position = ccp(0, 0);
        [self addChild:sprite];
		sprite_highlight = [CCSprite spriteWithFile:@"twoPosSwitch1.png"];
		sprite_highlight.position = ccp(0, 0);
        CCLOG(@"Switch cv: %3.3f",control_value);
        sprite.visible = NO;
        sprite_highlight.visible = NO;
        [self addChild:sprite_highlight];
    }
	return self;
}

-(void) updateViewWithValue {
    if (control_value == 1) {
        sprite.visible = NO;
        sprite_highlight.visible = YES;
        
    } else {
        sprite.visible = YES;
        sprite_highlight.visible = NO;
    }
}

-(void) touchRemoved:(UITouch *) touch {
	if (control_value == 0) {
		control_value = 1;
        sprite.visible = NO;
        sprite_highlight.visible = YES;

	} else {
		control_value = 0;
        sprite.visible = YES;
        sprite_highlight.visible = NO;
	}
            CCLOG(@"Switch cv: %3.3f",control_value);
    [self sendControlValues];
}

-(void) sendControlValues {
    
    if (control_value == 0) {
      [(InstrumentLayer *)self.parent setMasterVolumeOff];
        CCLOG(@"OFF");
    } else {
      [(InstrumentLayer *)self.parent setMasterVolumeOn];
              CCLOG(@"ON");
    }
}

@end
