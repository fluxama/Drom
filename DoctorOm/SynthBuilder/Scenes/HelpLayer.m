/*
 *  HelpLayer.m
 *  Drom
 *  http://www.fluxama.com
 *  http://github.com/fluxama
 *
 *  Created by Elliot Clapp, Shawn Greenlee, and Shawn Wallace
 *  Copyright (c) 2012 by Shawn Wallace of the Fluxama Group. 
 *  For information on usage and redistribution, and for a DISCLAIMER OF ALL
 *  WARRANTIES, see the file, "Drom-LICENSE.txt," in this distribution.  *///

#import "HelpLayer.h"

@implementation HelpLayer
@synthesize firstTouch;
@synthesize origY;

-(id) init {
	if( self=[super init]) {
        //img = [CCSprite spriteWithFile:@"AboutLayer.png"];
        //[self addChild:img z:100];
        CCSprite * bg = [CCSprite spriteWithFile:@"MenuBackground.png"];
        [bg setPosition:ccp(SCREEN_CENTER_X, SCREEN_CENTER_Y)];
        [self addChild:bg];
        img = [CCMenu menuWithItems:nil ];
        
        CCMenuItemImage *helpImage = [CCMenuItemImage 
                                           itemWithNormalImage:@"AboutLayer0.png"
                                           selectedImage:@"AboutLayer1.png"
                                           target:self
                                           selector:@selector(nothing:)];

        [img addChild:helpImage];
        if (IS_IPAD()) {
            [img setPosition:ccp(475,SCREEN_CENTER_Y)];
        } else {
            [img setPosition:ccp(225,SCREEN_CENTER_Y)];
        }
        //[img setVisible:false];
        [self addChild:img];
	}
	return self;
}

-(void) updateView:(CGPoint) location {
	/*float d1 = location.y;
    float diff = firstTouch - d1;
    
    if ((origY-diff) > (SCREEN_CENTER_Y-(HELP_SCREEN_H/2-SCREEN_CENTER_Y)) &&
        (origY-diff) < (HELP_SCREEN_H/2)) {
        //CCLOG(@"d1: %3.3f diff: %3.3f",d1, diff);
        //CCLOG(@"y: %3f min: %3d",(origY-diff), (SCREEN_CENTER_Y-(HELP_SCREEN_H/2-SCREEN_CENTER_Y)));
        self.position = ccp(self.position.x, origY-diff);
    }
     */
}

-(void) nothing:(id)sender {
    //CCLOG(@"Do nothing");
}



@end
