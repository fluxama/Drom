//
//  HelpLayer.h
//  Drom
//
//  Created by Shawn Wallace on 8/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Control.h"

@interface HelpLayer : CCNode {
	CCSprite *img;
    float firstTouch;
    float origY;
}

@property float firstTouch;
@property float origY;

- (void) updateView:(CGPoint) location;

@end
