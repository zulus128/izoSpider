//
//  Common.m
//  izoSpider
//
//  Created by Zul on 7/24/13.
//  Copyright (c) 2013 Zul. All rights reserved.
//

#import "Common.h"

@implementation Common

+ (Common*) instance  {
	
	static Common* instance;
	
	@synchronized(self) {
		
		if(!instance) {
			
			instance = [[Common alloc] init];
            
		}
	}
	return instance;
}

- (id) init {
	
	self = [super init];
	if(self !=nil) {
        
        self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"map1.tmx"];
        
        [self.tileMap layerNamed:@"bg"] setZOrder:-1];
        //zOrder:0 for hero
        [self.tileMap layerNamed:@"FrontBorderLayer"] setZOrder:1];

    }
	return self;
}

@end
