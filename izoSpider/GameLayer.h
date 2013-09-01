//
//  GameLayer.h
//  izoSpider
//
//  Created by Zul on 7/24/13.
//  Copyright (c) 2013 Zul. All rights reserved.
//

#import "cocos2d.h"
#import "Hero.h"
#import "ShortestPathStep.h"

@interface GameLayer : CCLayer {
    
    
    CGPoint touchLocation;
    CGPoint oldPos;
    
@private
	NSMutableArray *spOpenSteps;
	NSMutableArray *spClosedSteps;
}

+(CCScene *) scene;

@property (nonatomic, retain) NSMutableArray *spOpenSteps;
@property (nonatomic, retain) NSMutableArray *spClosedSteps;

// In "private properties and methods" section
- (void)insertInOpenSteps:(ShortestPathStep *)step;
- (int)computeHScoreFromCoord:(CGPoint)fromCoord toCoord:(CGPoint)toCoord;
- (int)costToMoveFromStep:(ShortestPathStep *)fromStep toAdjacentStep:(ShortestPathStep *)toStep;

@end
