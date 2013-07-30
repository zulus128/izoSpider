//
//  HudLayer.m
//  izoSpider
//
//  Created by Zul on 7/26/13.
//  Copyright (c) 2013 Zul. All rights reserved.
//

#import "HudLayer.h"
#import "Common.h"

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
        
        CCSprite *spider = [CCSprite spriteWithFile:@"come_to_the_spider_button.png"];
        CCSprite *spider_t1 = [CCSprite spriteWithFile:@"come_to_the_spider_button_active.png"];
        CCMenuItemSprite *itemspider = [CCMenuItemSprite itemWithNormalSprite:spider selectedSprite:spider_t1 block:^(id sender) {
            
//            NSLog(@"spider pressed");
            [[Common instance] setViewpointCenterToHero];
            
        }];
        [itemspider setPosition:ccp(75, size.height - 50)];
        
        CCMenu* menu1 = [CCMenu menuWithItems: itemspider, nil];
        [self addChild: menu1 z:107];
        [menu1 setPosition:ccp(0, 0)];
        
	}
	return self;
}
@end
