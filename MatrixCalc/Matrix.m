//
//  Matrix.m
//  MatrixCalc
//
//  Created by vienna on 23/2/13.
//  Copyright (c) 2013年 a1. All rights reserved.
//

#import "Matrix.h"

@interface Matrix ()

@end

@implementation Matrix

@synthesize row = _row;
@synthesize column = _column;

- (id)init:(unsigned int)row column:(unsigned int)col
{
    if (self = [self init]) {
        
        [self setRow:row];
        [self setColumn:col];
    
        self.data = malloc(row * col);
    }
    
    return self;
}


@end
