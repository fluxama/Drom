//
//  HelpScene.m
//  Drom
//
//  Created by Shawn Wallace on 7/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HelpScene.h"
#import "MenuScene.h"


@implementation HelpScene
- (id) init {
    self = [super init];
    if (self != nil) {
        CCSprite * bg = [CCSprite spriteWithFile:@"menuBackground.png"];
        
        [bg setPosition:ccp(SCREEN_CENTER_X, SCREEN_CENTER_Y)];   
        if (IS_IPAD()) {
            bg.scale = 2.5;
        }
        [self addChild:bg z:0];
        
		hl = [HelpLayer node];
        [self addChild:hl z:1];
    }
	
    return self;
}

-(void) dealloc
{
    CCLOG(@"Releasing HelpScene");
	[super dealloc];
}

@end

@implementation AboutLayer

CGPoint startTouch;
CGPoint endLocation;
float origX;
float deltaX;
float incX;
float xAtFirstTouch;
float xAtLastMove;
float menuWidth;

- (id) init {
    self = [super init];
    if (self != nil) {
        menu = [CCMenu menuWithItems:nil ];
        
        CCMenuItemImage *exitButton = [CCMenuItemImage 
                                       itemWithNormalImage:@"AboutButton.png"
                                       selectedImage:@"AboutButton.png"
                                       target:self
                                       selector:@selector(exitAbout:)];
        [menu addChild:exitButton z:30];
		[menu setAnchorPoint:ccp(0,0)];
        if (IS_IPAD()) {
            [menu setPosition:ccp(240*IPAD_MULT, 15*IPAD_MULT+IPAD_BOT_TRIM+20)]; 
        } else {
		    [menu setPosition:ccp(240, 15)];
        }
        [self addChild:menu z:50];
        
        self.isTouchEnabled = YES;
        screenIsTouched = FALSE;
        endLocation = ccp(menu.position.x, menu.position.y);
        startTouch = ccp(menu.position.x, menu.position.y);
        
        CCSprite * bg = [CCSprite spriteWithFile:@"AboutLayer.png"];
        //[bg setAnchorPoint:ccp(0,0)];
        [bg setPosition:ccp(SCREEN_CENTER_X, SCREEN_CENTER_Y)];
        [self addChild:bg z:0];
    }
    
    return self;
}

-(void)exitHelp: (id) sender {
	MenuScene *ms = [MenuScene node];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFlipY transitionWithDuration:0.5f scene:ms]];
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
}

-(void) dealloc
{ 
    CCLOG(@"Releasing AboutLayer");
	[super dealloc];
    
}

@end
