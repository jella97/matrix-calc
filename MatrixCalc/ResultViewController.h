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
			printf("%+.2f ", mat->data[i][j]);
		}
		putchar('\n');
	}
}



@interface ResultViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate>

@property (assign, nonatomic) NMatrix *resultMatrix;
@property (weak, nonatomic) IBOutlet UITextView *resultTextView;
@property (weak, nonatomic) UITextField *textFieldBeginEditing;

- (IBAction)dismissResultView:(UIButton *)sender;

- (NSString *)formatResultString:(NMatrix *)resultMatrix;

@end
