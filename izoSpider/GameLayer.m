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

        hero = [[Hero alloc] init];
        [[Common instance].tileMap addChild:hero z:0];
        
//        [self addChild:hero z:5];
        
//        hero.position = ccp(1650, 1000);
        hero.position = [[Common instance] positionForTileCoord:ccp(8, 10)];

	}
	return self;
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    touchLocation = [touch locationInView:touch.view];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    oldPos = [Common instance].tileMap.position;
    
    CGPoint touchLocation11 = [[Common instance].tileMap convertToNodeSpace:touchLocation];
    NSLog(@"start x = %f, y = %f", touchLocation11.x, touchLocation11.y);
    CGPoint tile = [[Common instance] tileCoordForPosition:touchLocation11];
    NSLog(@"tile x = %f, y = %f", tile.x, tile.y);
    
    CGPoint pos = [[Common instance] positionForTileCoord:tile];
    NSLog(@"pos from tile x = %f, y = %f", pos.x, pos.y);
    hero.position = pos;

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
