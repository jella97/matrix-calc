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

@synthesize matrixSize = _matrixSize;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    

    // init the matrix size with 1
    self.matrixSize = 1;

    [self labelMatrixSize].text = [[NSString alloc] initWithFormat:@"Matrix Size: %d X %d", self.matrixSize, self.matrixSize];
    
    self.rowsOfAllMatrix = [NSMutableArray new];
    
    // hide the textFields locator
    self.onePointOneOfMatrixA.hidden = YES;
    self.onePointOneOfMatrixB.hidden = YES;
    self.onePointOneOfMatrixResult.hidden = YES;
    
    
    [self drawFields];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"text field return ");
    [textField resignFirstResponder];
    return NO;
}

- (IBAction)matrixSizeChanged:(UIStepper *)sender {
    
    self.matrixSize = [sender value];
    
    // remove all textFields in array
    int rowsCount = self.rowsOfAllMatrix.count;
    int nObjectsInOneRow = [[self.rowsOfAllMatrix objectAtIndex:0] count];
    
    for (int i = 0; i < rowsCount; ++i) {
        for (int j = 0; j < nObjectsInOneRow; ++j) {
            NSLog(@"%@ in array", [[self.rowsOfAllMatrix objectAtIndex:i] objectAtIndex:j]);
            
            // remove from their super view
            [[[self.rowsOfAllMatrix objectAtIndex:i] objectAtIndex:j] removeFromSuperview];
            
        }
    }
    self.rowsOfAllMatrix = [NSMutableArray new];
    
    [self labelMatrixSize].text = [[NSString alloc] initWithFormat:@"Matrix Size: %d X %d", self.matrixSize, self.matrixSize];
    
    [self drawFields];
}

/*
 draw a matrix of textFields, 
 textField(1, 1) will locate in rect passed in.
 */
- (void)drawMatrixFields:(CGRect *)pRect
{
    NSMutableArray *aRowOfTextFieldsOfMatrix = [NSMutableArray new];
    
    CGRect newFrame = *pRect;
    UITextField *newTextField = nil;
    
    for (int y = 0; y < self.matrixSize; ++y) {
        // make move
        newFrame.origin.y = pRect->origin.y;
        newFrame.origin.y += y * pRect->size.height;
        
        for (int x = 0; x < self.matrixSize; ++x) {
            
            newTextField = [[UITextField alloc] initWithFrame:*pRect];
            
            // set delegate for events capturing
            newTextField.delegate = self;
            
            // make move
            newFrame.origin.x = pRect->origin.x;
            newFrame.origin.x += x * pRect->size.width;
            
            
            [newTextField setFrame:newFrame];
            [newTextField setBorderStyle:UITextBorderStyleRoundedRect];
            
            [aRowOfTextFieldsOfMatrix addObject:newTextField];
            
            [self.view addSubview:newTextField];
        }
        
        // add one row to rowsArray
        [self.rowsOfAllMatrix addObject:aRowOfTextFieldsOfMatrix];
        aRowOfTextFieldsOfMatrix = [NSMutableArray new];
    }

}


-(void)drawFields
{
    // generate textfields according to matrix size
    
    
    // generate matrix A
    CGRect frameOfMatrixA11 = CGRectMake(5, 60, 30, 30);
    [self drawMatrixFields:&frameOfMatrixA11];
    
    CGRect frameOfMatrixB11 = CGRectMake(163, 60, 30, 30);
    [self drawMatrixFields:&frameOfMatrixB11];

    CGRect frameOfMatrixResult11 = CGRectMake(85, 369, 30, 30);
    [self drawMatrixFields:&frameOfMatrixResult11];
}


/*
 for cancling virtual keyboard.
 when begin editing, keep which textfield is.
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.textFieldBeginEditing = textField;
}

/*
 for cancling virtual keyboard.
 when touch the white area, cancle the first responser of textfield.
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textFieldBeginEditing resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
