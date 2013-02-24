//
//  MatrixViewController.h
//  MatrixCalc
//
//  Created by vienna on 23/2/13.
//  Copyright (c) 2013年 a1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatrixViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *matrixSize;
@property (assign, nonatomic) unsigned int matrixRow;
@property (assign, nonatomic) unsigned int matrixColumn;
@property (strong, nonatomic) NSMutableArray *matrixRowFields;
@property (strong, nonatomic) NSMutableArray *matrixRows;
@property (weak, nonatomic) IBOutlet UITextField *matrix11;

// close keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField;

- (void)drawFields:(unsigned int)row columnCount:(unsigned int)column;

@end
