//
//  HeaderViewController.h
//  matrixcalc
//
//  Created by vienna on 20/3/13.
//  Copyright (c) 2013年 a1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderViewController : UICollectionReusableView


// connect to the UIStepper, and keep the matrix size.
@property (weak, nonatomic) IBOutlet UIStepper *stepper;

// operations

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (weak, nonatomic) IBOutlet UILabel *labelMatrixSize;


@end
