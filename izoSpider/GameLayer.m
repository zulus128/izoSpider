//
//  GameLayer.m
//  izoSpider
//
//  Created by Zul on 7/24/13.
//  Copyright (c) 2013 Zul. All rights reserved.
//

#import "GameLayer.h"
#import "Common.h"
#import "HudLayer.h"

@implementation GameLayer

+(CCScene *) scene {
    
	CCScene *scene = [CCScene node];
	
	GameLayer *layer = [GameLayer node];
	[scene addChild: layer];

    HudLayer *hlayer = [HudLayer node];
	[scene addChild: hlayer];
	
    return scene;
}

-(id) init {
    
	if( (self=[super init]) ) {
		
        self.touchEnabled = YES;
        
		CGSize size = [[CCDirector sharedDirector] winSize];

//		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];
//		label.position =  ccp( size.width /2 , size.height/2 );
//		[self addChild: label];
		
        [Common instance].tileMap.position = ccp(-1211, -712);
        [self addChild:[Common instance].tileMap z:0];

        
	}
	return self;
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    touchLocation = [touch locationInView:touch.view];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    //    touchLocation = [self convertToNodeSpace:touchLocation];
    oldPos = [Common instance].tileMap.position;
    
//    NSLog(@"start x = %f, y = %f", touchLocation.x, touchLocation.y);
//    NSLog(@"oldPos x = %f, y = %f", oldPos.x, oldPos.y);
    
}

- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation1 = [touch locationInView:touch.view];
    touchLocation1 = [[CCDirector sharedDirector] convertToGL:touchLocation1];

    CGPoint diff = ccpSub(touchLocation1, touchLocation);

    CGPoint newPos = ccpAdd(oldPos, diff);
    
    [Common instance].tileMap.position = newPos;
    
//    NSLog(@"moved x = %f, y = %f", touchLocation1.x, touchLocation1.y);
    
}

@end
