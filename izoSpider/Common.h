//
//  Common.h
//  izoSpider
//
//  Created by Zul on 7/24/13.
//  Copyright (c) 2013 Zul. All rights reserved.
//

//http://www.raywenderlich.com/4970/how-to-implement-a-pathfinding-with-cocos2d-tutorial

#import "cocos2d.h"

#define BACK_LAYER @"bg"

@interface Common : NSObject

+ (Common*) instance;

- (CGPoint) ort2iso:(CGPoint) pos;
- (CGPoint) iso2ort:(CGPoint) pos;
- (CGPoint)tileCoordForPosition:(CGPoint)position;
- (CGPoint)positionForTileCoord:(CGPoint)tile;

@property (nonatomic, retain) CCTMXTiledMap *tileMap;

@end
