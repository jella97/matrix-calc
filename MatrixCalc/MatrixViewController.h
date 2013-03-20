//
//  MatrixViewController.h
//  MatrixCalc
//
//  Created by vienna on 23/2/13.
//  Copyright (c) 2013年 a1. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MatrixViewController : UIViewController <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UILabel *matrixLable;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)matrixSizeChange:(UIStepper *)sender;
- (IBAction)calculate:(UIButton *)sender;
- (IBAction)reset:(UIButton *)sender;

@property (assign, nonatomic) unsigned int matrixSize;



@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

// NSMutableArray<NSMutableArray>
@property (strong, nonatomic) NSMutableArray *rowsOfAllMatrix;
@property (strong, nonatomic) NSMutableArray *oneRowInMatrix;
@property (assign, nonatomic) NSInteger sectionNow;

// when begin editing in one of textField, keep withch is
@property (weak, nonatomic) UITextField *textFieldBeginEditing;

// close keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField;

// - (void)drawFields;




@end
