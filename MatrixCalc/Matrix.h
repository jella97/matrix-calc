//
//  Matrix.h
//  MatrixCalc
//
//  Created by vienna on 23/2/13.
//  Copyright (c) 2013年 a1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Matrix : NSObject

@property (assign, nonatomic) unsigned int row;
@property (assign, nonatomic) unsigned int column;
@property (assign, nonatomic) int **data;

- (id)init:(unsigned int)row column:(unsigned int)col;

@end
