//
//  GameLayer.m
//  izoSpider
//
//  Created by Zul on 7/24/13.
//  Copyright (c) 2013 Zul. All rights reserved.
//

#import "GameLayer.h"
#import "Common.h"
#import "HudLayer.h"

@implementation GameLayer

+(CCScene *) scene {
    
	CCScene *scene = [CCScene node];
	
	GameLayer *layer = [GameLayer node];
	[scene addChild: layer];

    HudLayer *hlayer = [HudLayer node];
	[scene addChild: hlayer];
	
    return scene;
}

-(id) init {
    
	if( (self=[super init]) ) {
		
        self.touchEnabled = YES;
        
		CGSize size = [[CCDirector sharedDirector] winSize];

//		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];
//		label.position =  ccp( size.width /2 , size.height/2 );
//		[self addChild: label];
		
        [Common instance].tileMap.position = ccp(-1211, -712);
        [self addChild:[Common instance].tileMap z:0];

//        [Common instance].hero = [[Hero alloc] init];
//        [[Common instance].tileMap addChild:hero z:0];
        
//        [self addChild:hero z:5];
        
//        hero.position = ccp(1650, 1000);
//        hero.position = [[Common instance] positionForTileCoord:ccp(8, 10)];

	}
	return self;
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    touchLocation = [touch locationInView:touch.view];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    oldPos = [Common instance].tileMap.position;
    
    CGPoint touchLocation11 = [[Common instance].tileMap convertToNodeSpace:touchLocation];
//    NSLog(@"start x = %f, y = %f", touchLocation11.x, touchLocation11.y);
    CGPoint tile = [[Common instance] tileCoordForPosition:touchLocation11];
    NSLog(@"tile x = %f, y = %f", tile.x, tile.y);
    
    CGPoint pos = [[Common instance] positionForTileCoord:tile];
//    NSLog(@"pos from tile x = %f, y = %f", pos.x, pos.y);
    [Common instance].hero.position = pos;

//    NSLog(@"oldPos x = %f, y = %f", oldPos.x, oldPos.y);
    
    int gid = [[Common instance] tileIdforTileCoord:tile];
    NSLog(@"gid = %d", gid);
}

- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation1 = [touch locationInView:touch.view];
    touchLocation1 = [[CCDirector sharedDirector] convertToGL:touchLocation1];

    CGPoint diff = ccpSub(touchLocation1, touchLocation);

    CGPoint newPos = ccpAdd(oldPos, diff);
    
    [Common instance].tileMap.position = newPos;
    
//    NSLog(@"moved x = %f, y = %f", touchLocation1.x, touchLocation1.y);
    
}

- (void)moveToward:(CGPoint)target {
    
    // Get current tile coordinate and desired tile coord
    CGPoint fromTileCoord = [[Common instance] tileCoordForPosition:[Common instance].hero.position];
    CGPoint toTileCoord = [[Common instance] tileCoordForPosition:target];
    
    // Check that there is a path to compute ;-)
    if (CGPointEqualToPoint(fromTileCoord, toTileCoord)) {
        NSLog(@"You're already there! :P");
        return;
    }
    
    // Must check that the desired location is walkable
    // In our case it's really easy, because only wall are unwalkable
    if ([[Common instance] isWallAtTileCoord:toTileCoord]) {
//        [[SimpleAudioEngine sharedEngine] playEffect:@"hitWall.wav"];
        return;
    }
    
    NSLog(@"From: %@", NSStringFromCGPoint(fromTileCoord));
    NSLog(@"To: %@", NSStringFromCGPoint(toTileCoord));
}

/*
// In "private properties and methods" section
- (void)insertInOpenSteps:(ShortestPathStep *)step;
- (int)computeHScoreFromCoord:(CGPoint)fromCoord toCoord:(CGPoint)toCoord;
- (int)costToMoveFromStep:(ShortestPathStep *)fromStep toAdjacentStep:(ShortestPathStep *)toStep;

// Add these new methods after moveToward

// Insert a path step (ShortestPathStep) in the ordered open steps list (spOpenSteps)
- (void)insertInOpenSteps:(ShortestPathStep *)step
{
	int stepFScore = [step fScore]; // Compute the step's F score
	int count = [self.spOpenSteps count];
	int i = 0; // This will be the index at which we will insert the step
	for (; i < count; i++) {
		if (stepFScore <= [[self.spOpenSteps objectAtIndex:i] fScore]) { // If the step's F score is lower or equals to the step at index i
			// Then we found the index at which we have to insert the new step
            // Basically we want the list sorted by F score
			break;
		}
	}
	// Insert the new step at the determined index to preserve the F score ordering
	[self.spOpenSteps insertObject:step atIndex:i];
}

// Compute the H score from a position to another (from the current position to the final desired position
- (int)computeHScoreFromCoord:(CGPoint)fromCoord toCoord:(CGPoint)toCoord
{
	// Here we use the Manhattan method, which calculates the total number of step moved horizontally and vertically to reach the
	// final desired step from the current step, ignoring any obstacles that may be in the way
	return abs(toCoord.x - fromCoord.x) + abs(toCoord.y - fromCoord.y);
}

// Compute the cost of moving from a step to an adjacent one
- (int)costToMoveFromStep:(ShortestPathStep *)fromStep toAdjacentStep:(ShortestPathStep *)toStep
{
	// Because we can't move diagonally and because terrain is just walkable or unwalkable the cost is always the same.
	// But it have to be different if we can move diagonally and/or if there is swamps, hills, etc...
	return 1;
}
*/
@end
