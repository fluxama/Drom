//
//  HelpScene.h
//  Drom
//
//  Created by Shawn Wallace on 7/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@class HelpLayer;

@interface HelpScene : CCScene 
{
    HelpLayer *hl;
}

@end

@interface HelpLayer : CCLayer 
{
	CCMenu *menu;
	float menu_x;
	float menu_y;
    float row;
    float col;
	float current_col;
    bool screenIsTouched;
}

-(void)exitAbout: (id) sender;

@end
