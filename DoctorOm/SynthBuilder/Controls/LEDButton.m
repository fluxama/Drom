//
//  LEDButton.m
//  Drom
//
//  Created by Shawn Wallace on 8/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "LEDButton.h"


@implementation LEDButton

-(id) initWithDictionary: (NSDictionary *) params {
if( (self=[super initWithDictionary: params] )) {
    sprite_highlight = [CCSprite spriteWithFile:@"LedGlow2.png"];
    sprite_highlight.position = ccp(0, 0);
    if (control_state == 0) {
        sprite_highlight.visible = NO;            
    }
    [self addChild:sprite_highlight];
}
return self;
}

-(void) touchRemoved:(UITouch *) touch {
	if (control_state == 0) {
		control_state = 1;
        //sprite.visible = NO;
        sprite_highlight.visible = YES;
	} else {
		control_state = 0;
        //sprite.visible = YES;
        sprite_highlight.visible = NO;
	}
        [self sendControlValues];
}

-(void) turnOff {	
    sprite_highlight.visible = NO;

}

-(void) sendControlValues {
    if (control_state == 1) {
        //CCLOG(@"%@ %3.3f",self.control_patch_input, self.control_value);
        [PdBase sendBangToReceiver:self.control_patch_input];
    } 
}

@end