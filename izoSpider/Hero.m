//
//  Hero.m
//  izoSpider
//
//  Created by Zul on 7/28/13.
//  Copyright (c) 2013 Zul. All rights reserved.
//

#import "Hero.h"
#import "ShortestPathStep.h"

@implementation Hero


-(id) init {
    
	if( (self=[super init]) ) {
		
        me = [CCSprite spriteWithFile:@"spider_calm_w (1).png"];
        me.position = ccp(0,0);
        [self addChild:me];
        
        direction = kDirE;
        
        [self refreshAnimation];
        
	}
	return self;
}

- (void) refreshAnimation {
    
    [me stopAllActions];
    
    NSString* act = @"calm";
    int cnt = 10;
    if(self.shortestPath != nil) {

        act = @"walk";
        cnt = 14;
    }
    
    NSString* dir = @"w";
    BOOL reflectX = NO;
//    BOOL reflectY = NO;
    switch (direction) {
        case kDirW:
            dir = @"w";
            reflectX = NO;
//            reflectY = NO;
            break;
        case kDirN:
            dir = @"w";
            reflectX = YES;
//            reflectY = NO;
            break;
        case kDirE:
            dir = @"s";
            reflectX = YES;
//            reflectY = NO;
            break;
        case kDirS:
            dir = @"s";
            reflectX = NO;
//            reflectY = NO;
            break;
    }
    
    CCAnimation* anim = [CCAnimation animation];
    for (int i = 1; i <= cnt; i++) {

        [anim addSpriteFrameWithFilename:[NSString stringWithFormat:@"spider_%@_%@ (%d).png", act, dir, i]];
    }
    anim.delayPerUnit = ANIM_DELAY;
    CCAnimate *animate = [CCAnimate actionWithAnimation:anim];
    [me runAction:[CCRepeatForever actionWithAction:animate]];
    CCFlipX *flipOnX = [CCFlipX actionWithFlipX:reflectX];
    [me runAction:flipOnX];
//    CCFlipX *flipOnY = [CCFlipX actionWithFlipX:reflectY];
//    [me runAction:flipOnY];
}

- (void) go {

    [self refreshAnimation];
    [self popStepAndAnimate];
}

- (void)popStepAndAnimate {
    
	// Check if there remains path steps to go through
	if ([self.shortestPath count] == 0) {
		
        self.shortestPath = nil;

        [self refreshAnimation];

		return;
	}
    
	// Get the next step to move to
	ShortestPathStep *s = [self.shortestPath objectAtIndex:0];
    
    CGPoint curr = [[Common instance] tileCoordForPosition:self.position];
    if(s.position.x > curr.x)
        direction = kDirE;
    if(s.position.x < curr.x)
        direction = kDirW;
    if(s.position.y > curr.y)
        direction = kDirS;
    if(s.position.y < curr.y)
        direction = kDirN;
    [self refreshAnimation];

//    NSLog(@"direction = %d", direction);
//    NSLog(@"curr = %f, %f", curr.x, curr.y);
    
	// Prepare the action and the callback
	id moveAction = [CCMoveTo actionWithDuration:0.8f position:[[Common instance] positionForTileCoord:s.position]];
	id moveCallback = [CCCallFunc actionWithTarget:self selector:@selector(popStepAndAnimate)]; // set the method itself as the callback
    
	// Remove the step
	[self.shortestPath removeObjectAtIndex:0];
    
	// Play actions
	[self runAction:[CCSequence actions:moveAction, moveCallback, nil]];
}

@end
