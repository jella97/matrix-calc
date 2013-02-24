//
//  MatrixViewController.m
//  MatrixCalc
//
//  Created by vienna on 23/2/13.
//  Copyright (c) 2013年 a1. All rights reserved.
//

#import "MatrixViewController.h"

@interface MatrixViewController ()

@end

@implementation MatrixViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.matrixRow = 3;
    self.matrixColumn = 5;

    [self matrixSize].text = [[NSString alloc] initWithFormat:@"Matrix Size: %d X %d", self.matrixRow, self.matrixColumn];
    
    [self drawFields:self.matrixRow columnCount:self.matrixColumn];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"text field return ");
    [textField resignFirstResponder];
    return NO;
}

-(void)drawFields:(unsigned int)row columnCount:(unsigned int)column
{
    // keyboard close;
    [self matrix11].delegate = self;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
