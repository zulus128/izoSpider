//
//  Hero.h
//  izoSpider
//
//  Created by Zul on 7/28/13.
//  Copyright (c) 2013 Zul. All rights reserved.
//

#import "cocos2d.h"

#define ANIM_DELAY 0.2f
#define SPRITE_SIZE 117

enum {
  
    kDirW,
    kDirN,
    kDirE,
    kDirS
};

@interface Hero : CCNode {
    
    int direction;
    CCSprite* me;
}

- (void)popStepAndAnimate;
- (void) go;

@property (nonatomic, retain) NSMutableArray *shortestPath;
//@property (assign, readwrite) BOOL moving;

@end
