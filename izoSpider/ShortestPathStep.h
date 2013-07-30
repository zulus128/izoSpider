//
//  ShortestPathStep.h
//  izoSpider
//
//  Created by Zul on 7/29/13.
//  Copyright (c) 2013 Zul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShortestPathStep : NSObject {
    
	CGPoint position;
	int gScore;
	int hScore;
	ShortestPathStep *parent;
}

@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) int gScore;
@property (nonatomic, assign) int hScore;
@property (nonatomic, assign) ShortestPathStep *parent;

- (id)initWithPosition:(CGPoint)pos;
- (int)fScore;

@end
