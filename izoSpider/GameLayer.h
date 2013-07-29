//
//  GameLayer.h
//  izoSpider
//
//  Created by Zul on 7/24/13.
//  Copyright (c) 2013 Zul. All rights reserved.
//

#import "cocos2d.h"
#import "Hero.h"

@interface GameLayer : CCLayer {
    
    Hero* hero;
    
    CGPoint touchLocation;
    CGPoint oldPos;
}

+(CCScene *) scene;

@end
