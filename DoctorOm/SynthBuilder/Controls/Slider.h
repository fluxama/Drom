/*
 *  Slider.h
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

@interface Slider : Control
{   
	float control_min;
	float control_max;
    float prevAngle;
    bool pinnedLow;
    bool pinnedHigh;
    bool crossedLowClockwise;
    bool crossedLowCC;
    bool crossedHighClockwise;
    bool crossedHighCC;
}

@property float control_min;
@property float control_max;

- (id) initWithDictionary: (NSDictionary *) params;
- (void) updateView:(CGPoint) location;
- (void) showHighlight;
- (void) hideHighlight;
- (void) showSeqHighlight;
- (void) hideSeqHighlight;

@end
