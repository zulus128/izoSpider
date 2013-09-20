//
//  Mosq.m
//  izoSpider
//
//  Created by вадим on 9/8/13.
//  Copyright (c) 2013 Zul. All rights reserved.
//

#import "Mosq.h"

@implementation Mosq

-(id) init {
    
	if( (self=[super init]) ) {
		
        me = [CCSprite spriteWithFile:@"mos_fly_ w (1).png"];
        me.position = ccp(0,0);
        [self addChild:me];
        
	}
	return self;
}
@end
