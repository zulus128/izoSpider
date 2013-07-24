//
//  Common.h
//  izoSpider
//
//  Created by Zul on 7/24/13.
//  Copyright (c) 2013 Zul. All rights reserved.
//

#import "cocos2d.h"

@interface Common : NSObject

+ (Common*) instance;

@property (nonatomic, retain) CCTMXTiledMap *tileMap;

@end
