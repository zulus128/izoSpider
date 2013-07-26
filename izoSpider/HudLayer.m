//
//  HudLayer.m
//  izoSpider
//
//  Created by Zul on 7/26/13.
//  Copyright (c) 2013 Zul. All rights reserved.
//

#import "HudLayer.h"

@implementation HudLayer

+(CCScene *) scene {
    
	CCScene *scene = [CCScene node];
	HudLayer *layer = [HudLayer node];
	[scene addChild: layer];
	return scene;
}

-(id) init {
    
	if( (self=[super init]) ) {
		
        self.touchEnabled = YES;
        
		CGSize size = [[CCDirector sharedDirector] winSize];
        
        
        
	}
	return self;
}
@end
