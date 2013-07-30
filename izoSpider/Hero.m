//
//  Hero.m
//  izoSpider
//
//  Created by Zul on 7/28/13.
//  Copyright (c) 2013 Zul. All rights reserved.
//

#import "Hero.h"

@implementation Hero


-(id) init {
    
	if( (self=[super init]) ) {
		
        CCSprite* me = [CCSprite spriteWithFile:@"spider_4 (1).png"];
        me.position = ccp(0,0);
        [self addChild:me];
        
        
	}
	return self;
}


@end
