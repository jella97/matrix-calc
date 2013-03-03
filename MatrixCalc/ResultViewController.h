//
//  ResultViewController.h
//  matrixcalc
//
//  Created by vienna on 2/3/13.
//  Copyright (c) 2013年 a1. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "NMatrix.h"

static void PrintMatrix(const NMatrix* mat)
{
	integer i, j;
	for (i = 0; i < mat->rows; ++i)
	{
		for (j = 0; j < mat->columns; ++j)
		{
			printf("%+lf ", mat->data[i][j]);
		}
		putchar('\n');
	}
}

@interface ResultViewController : UIViewController

@property (assign, nonatomic) NMatrix *resultMatrix;

- (IBAction)dismissResultView:(UIButton *)sender;

@end
