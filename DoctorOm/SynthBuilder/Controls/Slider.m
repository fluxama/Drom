/*
 *  Slider.m
 *  Drom
 *  http://www.fluxama.com
 *  http://github.com/fluxama
 *
 *  Created by Elliot Clapp, Shawn Greenlee, and Shawn Wallace
 *  Copyright (c) 2012 by Shawn Wallace of the Fluxama Group. 
 *  For information on usage and redistribution, and for a DISCLAIMER OF ALL
 *  WARRANTIES, see the file, "Drom-LICENSE.txt," in this distribution.  */

#import "Slider.h"

@implementation Slider

@synthesize control_min;
@synthesize control_max;

-(id) initWithDictionary: (NSDictionary *) params {
	if( (self=[super initWithDictionary: params] )) {
		
		self.control_min = [[params objectForKey:@"min"] floatValue];
		self.control_max = [[params objectForKey:@"max"] floatValue];
        if (IS_IPAD()) {
            self.control_min = self.control_min * IPAD_MULT;
            self.control_max = self.control_max * IPAD_MULT;
        }
        
		self.control_value = [[params objectForKey:@"value"] floatValue];
        
        pinnedLow = NO;
        pinnedHigh = NO;
        
		sprite = [CCSprite spriteWithFile:@"Slider.png"];
		sprite.position = ccp(0, 0);
		sprite.visible = YES;
		[self addChild:sprite z:3];
	}
	return self;
}

-(void) updateView:(CGPoint) location {
	float d1 = location.x;
    if (d1 < control_min) {
        d1 = control_min;
    }
    if (d1 > control_max) {
        d1 = control_max;
    }
    
    self.position = ccp(d1, self.position.y);
    control_value = (d1-control_min) / (control_max-control_min);
    //CCLOG(@"%3.3f",control_value);
}

-(void) updateViewWithValue {	
    self.position = ccp(control_value*(control_max-control_min)+control_min, self.position.y);
}

- (void) showHighlight {
}

- (void) hideHighlight {
}

- (void) showSeqHighlight {
}

- (void) hideSeqHighlight {
}

-(void) touchRemoved:(UITouch *) touch { 

}

- (void) dealloc {
    // CCLOG(@"Dealloc Pot");
    [super dealloc];
}

@end
