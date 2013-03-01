//
//  MatrixViewController.h
//  MatrixCalc
//
//  Created by vienna on 23/2/13.
//  Copyright (c) 2013年 a1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatrixViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labelMatrixSize;

@property (assign, nonatomic) int matrixSize;
@property (weak, nonatomic) IBOutlet UITextField *onePointOneOfMatrixA;
@property (weak, nonatomic) IBOutlet UITextField *onePointOneOfMatrixB;
@property (weak, nonatomic) IBOutlet UITextField *onePointOneOfMatrixResult;


// NSMutableArray<NSMutableArray>
@property (strong, nonatomic) NSMutableArray *rowsOfAllMatrix;

// when begin editing in one of textField, keep withch is
@property (weak, nonatomic) UITextField *textFieldBeginEditing;

// close keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
- (IBAction)matrixSizeChanged:(UIStepper *)sender;

- (void)drawFields;

@end
