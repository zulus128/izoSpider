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
        
        [[self.tileMap layerNamed:BACK_LAYER] setZOrder:-1];
        //zOrder:0 for hero
        [[self.tileMap layerNamed:@"cools"] setZOrder:1];
        [[self.tileMap layerNamed:@"trees"] setZOrder:2];
        [[self.tileMap layerNamed:@"f1"] setZOrder:3];
        [[self.tileMap layerNamed:@"f2"] setZOrder:4];
        [[self.tileMap layerNamed:@"f3"] setZOrder:5];
        [[self.tileMap layerNamed:@"f4"] setZOrder:6];


    }
	return self;
}

- (CGPoint) ort2iso:(CGPoint) pos {
    
    //    CCTMXLayer* l = [[Common instance].tileMap layerNamed:@"BackBackgroundLayer"];
    //    return [l positionForIsoAt:pos];
    
    float mapHeight = _tileMap.mapSize.height;
    float mapWidth = _tileMap.mapSize.width;
    float tileHeight = _tileMap.tileSize.height;
    float tileWidth = _tileMap.tileSize.width;
    float ratio = tileWidth / tileHeight;
    
    float x = tileWidth /2 * ( mapWidth + pos.x/(tileWidth / ratio) - pos.y/tileHeight);// + 0.49f;
    float y = tileHeight /2 * (( mapHeight * 2 - pos.x/(tileWidth / ratio) - pos.y/tileHeight) +1);// + 0.49f;
    return ccp(x / CC_CONTENT_SCALE_FACTOR(), (y - 0.5f * tileHeight) / CC_CONTENT_SCALE_FACTOR());
    //    return ccp(x , (y - 0.5f * tileHeight) );
}

- (CGPoint) iso2ort:(CGPoint) pos {
    
    float mapHeight = _tileMap.mapSize.height;
    float mapWidth = _tileMap.mapSize.width;
    float tileHeight = _tileMap.tileSize.height;
    float tileWidth = _tileMap.tileSize.width;
    float ratio = tileWidth / tileHeight;
    
    float xx = pos.x * CC_CONTENT_SCALE_FACTOR();
    float yy = pos.y * CC_CONTENT_SCALE_FACTOR();
    float px1 = mapHeight * 2 - mapWidth + xx / tileWidth * 2 - yy / tileHeight * 2;
    float px = px1;// * CC_CONTENT_SCALE_FACTOR();
    float x = px / 2 * (tileWidth /ratio);
    float py = (mapWidth + px1 - xx / tileWidth * 2);// * CC_CONTENT_SCALE_FACTOR();
    float y = py * tileHeight - x;
    return ccp(x,y);
}

- (CGPoint)tileCoordForPosition:(CGPoint)position {
    
    float halfMapWidth = self.tileMap.mapSize.width * 0.5f;
    float mapHeight = self.tileMap.mapSize.height;
    float tileWidth = self.tileMap.tileSize.width;
    float tileHeight = self.tileMap.tileSize.height;
    
    CGPoint tilePosDiv = CGPointMake(position.x / tileWidth, position.y / tileHeight);
    float inverseTileY = mapHeight - tilePosDiv.y;
    
    float posX = (int)(inverseTileY + tilePosDiv.x - halfMapWidth);
    float posY = (int)(inverseTileY - tilePosDiv.x + halfMapWidth);
    
    return ccp(posX, posY);
}

- (CGPoint)positionForTileCoord:(CGPoint)tile {

    tile = ccp(tile.x, tile.y - 1);

    return [[self.tileMap layerNamed:BACK_LAYER] positionAt:tile];

}

@end
