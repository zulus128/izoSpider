//
//  GameLayer.m
//  izoSpider
//
//  Created by Zul on 7/24/13.
//  Copyright (c) 2013 Zul. All rights reserved.
//

#import "GameLayer.h"
#import "Common.h"

@implementation GameLayer

+(CCScene *) scene {
    
	CCScene *scene = [CCScene node];
	GameLayer *layer = [GameLayer node];
	[scene addChild: layer];
	return scene;
}

-(id) init {
    
	if( (self=[super init]) ) {
		
        
		CGSize size = [[CCDirector sharedDirector] winSize];

//		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];
//		label.position =  ccp( size.width /2 , size.height/2 );
//		[self addChild: label];
		
        [Common instance].tileMap.position = ccp(-1000,-500);
        [self addChild:[Common instance].tileMap z:0];

        
	}
	return self;
}

@end
