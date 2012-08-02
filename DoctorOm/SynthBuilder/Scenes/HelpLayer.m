//
//  HelpLayer.m
//  Drom
//
//  Created by Shawn Wallace on 8/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HelpLayer.h"

@implementation HelpLayer
@synthesize firstTouch;
@synthesize origY;

-(id) init {
	if( self=[super init]) {
        img = [CCSprite spriteWithFile:@"AboutLayer.png"];
        [self addChild:img z:100];
	}
	return self;
}

-(void) updateView:(CGPoint) location {
	float d1 = location.y;
    float diff = firstTouch - d1;
    
    if ((origY-diff) > (SCREEN_CENTER_Y-(HELP_SCREEN_H/2-SCREEN_CENTER_Y)) &&
        (origY-diff) < (HELP_SCREEN_H/2)) {
        //CCLOG(@"d1: %3.3f diff: %3.3f",d1, diff);
        //CCLOG(@"y: %3f min: %3d",(origY-diff), (SCREEN_CENTER_Y-(HELP_SCREEN_H/2-SCREEN_CENTER_Y)));
        self.position = ccp(self.position.x, origY-diff);
    }
}


@end
