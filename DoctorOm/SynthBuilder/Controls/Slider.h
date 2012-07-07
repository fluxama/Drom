//
//  Slider.h
//  DoctorOm
//
//  Created by Shawn Wallace on 5/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

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
