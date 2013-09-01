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
        
//		CGSize size = [[CCDirector sharedDirector] winSize];

        [Common instance].tileMap.position = ccp(-1211, -712);
        [self addChild:[Common instance].tileMap z:0];

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
//    [Common instance].hero.position = pos;
    
    if([Common instance].hero.shortestPath == nil)
        [self moveToward:pos];

//    NSLog(@"oldPos x = %f, y = %f", oldPos.x, oldPos.y);
    
//    int gid = [[Common instance] tileIdforTileCoord:tile];
//    NSLog(@"gid = %d", gid);
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

- (void) moveToward:(CGPoint)target {
    
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

        NSLog(@"A Wall there! :P");

        return;
    }
    
    NSLog(@"From: %@", NSStringFromCGPoint(fromTileCoord));
    NSLog(@"To: %@", NSStringFromCGPoint(toTileCoord));
    
    
//    BOOL pathFound = NO;
    self.spOpenSteps = [[[NSMutableArray alloc] init] autorelease];
    self.spClosedSteps = [[[NSMutableArray alloc] init] autorelease];
    
    // Start by adding the from position to the open list
    [self insertInOpenSteps:[[[ShortestPathStep alloc] initWithPosition:fromTileCoord] autorelease]];
    
    do {
        // Get the lowest F cost step
        // Because the list is ordered, the first step is always the one with the lowest F cost
        ShortestPathStep *currentStep = [self.spOpenSteps objectAtIndex:0];
        
        // Add the current step to the closed set
        [self.spClosedSteps addObject:currentStep];
        
        // Remove it from the open list
        // Note that if we wanted to first removing from the open list, care should be taken to the memory
        [self.spOpenSteps removeObjectAtIndex:0];
        
        // If the currentStep is the desired tile coordinate, we are done!
        if (CGPointEqualToPoint(currentStep.position, toTileCoord)) {
            
            [self constructPathAndStartAnimationFromStep:currentStep];
            [[Common instance].hero go];
            
//            pathFound = YES;
//            ShortestPathStep *tmpStep = currentStep;
//            NSLog(@"PATH FOUND :");
//            do {
//                NSLog(@"%@", tmpStep);
//                tmpStep = tmpStep.parent; // Go backward
//            } while (tmpStep != nil); // Until there is not more parent
            
            self.spOpenSteps = nil; // Set to nil to release unused memory
            self.spClosedSteps = nil; // Set to nil to release unused memory
            break;
        }
        
        // Get the adjacent tiles coord of the current step
        NSArray *adjSteps = [[Common instance] walkableAdjacentTilesCoordForTileCoord:currentStep.position];
        for (NSValue *v in adjSteps) {
            ShortestPathStep *step = [[ShortestPathStep alloc] initWithPosition:[v CGPointValue]];
            
            // Check if the step isn't already in the closed set
            if ([self.spClosedSteps containsObject:step]) {
                [step release]; // Must releasing it to not leaking memory ;-)
                continue; // Ignore it
            }
            
            // Compute the cost from the current step to that step
            int moveCost = [self costToMoveFromStep:currentStep toAdjacentStep:step];
            
            // Check if the step is already in the open list
            NSUInteger index = [self.spOpenSteps indexOfObject:step];
            
            if (index == NSNotFound) { // Not on the open list, so add it
                
                // Set the current step as the parent
                step.parent = currentStep;
                
                // The G score is equal to the parent G score + the cost to move from the parent to it
                step.gScore = currentStep.gScore + moveCost;
                
                // Compute the H score which is the estimated movement cost to move from that step to the desired tile coordinate
                step.hScore = [self computeHScoreFromCoord:step.position toCoord:toTileCoord];
                
                // Adding it with the function which is preserving the list ordered by F score
                [self insertInOpenSteps:step];
                
                // Done, now release the step
                [step release];
            }
            else { // Already in the open list
                
                [step release]; // Release the freshly created one
                step = [self.spOpenSteps objectAtIndex:index]; // To retrieve the old one (which has its scores already computed ;-)
                
                // Check to see if the G score for that step is lower if we use the current step to get there
                if ((currentStep.gScore + moveCost) < step.gScore) {
                    
                    // The G score is equal to the parent G score + the cost to move from the parent to it
                    step.gScore = currentStep.gScore + moveCost;
                    
                    // Because the G Score has changed, the F score may have changed too
                    // So to keep the open list ordered we have to remove the step, and re-insert it with
                    // the insert function which is preserving the list ordered by F score
                    
                    // We have to retain it before removing it from the list
                    [step retain];
                    
                    // Now we can removing it from the list without be afraid that it can be released
                    [self.spOpenSteps removeObjectAtIndex:index];
                    
                    // Re-insert it with the function which is preserving the list ordered by F score
                    [self insertInOpenSteps:step];
                    
                    // Now we can release it because the oredered list retain it
                    [step release];
                }
            }
        }
        
    } while ([self.spOpenSteps count] > 0);
    
//    if (!pathFound) { // No path found
//        
//        NSLog(@"No path found!");
//    }
}


- (void)constructPathAndStartAnimationFromStep:(ShortestPathStep *)step {
    
	[Common instance].hero.shortestPath = [NSMutableArray array];
    
	do {
		if (step.parent != nil) { // Don't add the last step which is the start position (remember we go backward, so the last one is the origin position ;-)
			[[Common instance].hero.shortestPath insertObject:step atIndex:0]; // Always insert at index 0 to reverse the path
		}
		step = step.parent; // Go backward
	} while (step != nil); // Until there is no more parents
    
    for (ShortestPathStep *s in [Common instance].hero.shortestPath) {
        NSLog(@"%@", s);
    }
}
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

@end
