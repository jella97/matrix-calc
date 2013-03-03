//
//  MatrixViewController.m
//  MatrixCalc
//
//  Created by vienna on 23/2/13.
//  Copyright (c) 2013年 a1. All rights reserved.
//

#import "MatrixViewController.h"
#import "ResultViewController.h"

#include "NMatrix.h"

@interface MatrixViewController ()

@end

@implementation MatrixViewController

enum MATRIX_OPERATION {
    OPERATION_ADD = 0,
    OPERATION_SUB,
    OPERATION_MUL,
    OPERATION_INV
};

#define MATRIX_A_INDEX 0
#define MATRIX_B_INDEX 1


@synthesize matrixSize = _matrixSize;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    

    // init the matrix size with 1
    self.matrixSize = 3;

    [self labelMatrixSize].text = [[NSString alloc] initWithFormat:@"Matrix Size: %d X %d", self.matrixSize, self.matrixSize];
    
    self.rowsOfAllMatrix = [NSMutableArray new];
    
    // hide the textFields locator
    self.onePointOneOfMatrixA.hidden = YES;
    self.onePointOneOfMatrixB.hidden = YES;
    self.onePointOneOfMatrixResult.hidden = YES;
    
    
    // init the segmented control options
    [self.segmentedControl removeAllSegments];
    [self.segmentedControl insertSegmentWithTitle:@"+" atIndex:OPERATION_ADD animated:YES];
    [self.segmentedControl insertSegmentWithTitle:@"-" atIndex:OPERATION_SUB animated:YES];
    [self.segmentedControl insertSegmentWithTitle:@"*" atIndex:OPERATION_MUL animated:YES];
    [self.segmentedControl insertSegmentWithTitle:@"Inv(A)" atIndex:OPERATION_INV animated:YES];
    // operation add default selected
    [self.segmentedControl setSelectedSegmentIndex:OPERATION_ADD];
    
    
    // add observer to catch the keyboard hide notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
     
    [self drawFields];
}

- (void)keyboardDidHide:(NSNotification *)notification
{
    // if it moved, restore it
    if (self.view.frame.origin.y != 20) {
        
        [UIView beginAnimations:@"RestoreViewSize" context:nil];
        [UIView setAnimationDuration:0.3f];
        
        CGRect frame = self.view.frame;
        frame.origin.y += 216;
        [self.view setFrame:frame];
        
        [UIView commitAnimations];
    }
}

/*
 when press return key, cancel first responser
 */
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
    CGRect frameOfMatrixA11 = CGRectMake(5, 94, 55, 30);
    [self drawMatrixFields:&frameOfMatrixA11];
    
    CGRect frameOfMatrixB11 = CGRectMake(5, 250, 55, 30);
    [self drawMatrixFields:&frameOfMatrixB11];

    /*
    CGRect frameOfMatrixResult11 = CGRectMake(5, 369, 30, 30);
    [self drawMatrixFields:&frameOfMatrixResult11];
     */
}


/*
 for cancling virtual keyboard.
 when begin editing, keep which textfield is.
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.textFieldBeginEditing = textField;
    
    int heightOfTextField = [self.view frame].size.height - textField.frame.origin.y - textField.frame.size.height;
    
    // it will hide the field & it doesn't moved
    if (heightOfTextField < 216 &&
        self.view.frame.origin.y == 20)
    {
        [UIView beginAnimations:@"ViewResize" context:nil];
        [UIView setAnimationDuration:0.3f];
        
        CGRect frame = [self.view frame];
        frame.origin.y -= 216;
        [self.view setFrame:frame];
        
        [UIView commitAnimations];
    }
}

/*
 for canceling virtual keyboard.
 when touch the white area, cancel the first responser of textfield.
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

/*
 dispatch operations
 */
- (IBAction)calculate:(UIButton *)sender {
    
    ResultViewController *resultView = [self.storyboard  instantiateViewControllerWithIdentifier:@"ResultView"];
    
    
    NMatrix *matrixA = NULL;
    NMatrix *matrixB = NULL;
    int matrixSize = self.matrixSize;
    
    matrixA = NMatrix_Create(matrixSize, matrixSize);
    matrixB = NMatrix_Create(matrixSize, matrixSize);
    
    for (int i = 0; i < self.matrixSize; ++i) {
        for (int j = 0; j < self.matrixSize; ++j) {
            // one row operation
            // value of matrix A
            UITextField *textFieldA =
            [[self.rowsOfAllMatrix objectAtIndex:(i + MATRIX_A_INDEX * self.matrixSize)]objectAtIndex:j];
            matrixA->data[i][j] = [[textFieldA text] intValue];
            
            // value of matrix B
            UITextField *textFieldB =
            [[self.rowsOfAllMatrix objectAtIndex:(i + MATRIX_B_INDEX * self.matrixSize)] objectAtIndex:j];
            matrixB->data[i][j] = [[textFieldB text] intValue];
            
        }
    }
    
    switch (self.segmentedControl.selectedSegmentIndex) {
        case OPERATION_ADD:
            
            resultView.resultMatrix = NMatrix_Sum(matrixA, matrixB);
            break;
        case OPERATION_SUB:
            

            break;
        case OPERATION_MUL:
            [self operationMul];
            break;
        case OPERATION_INV:
            break;
            
        default:
            break;
    }
    
    [self presentViewController:resultView animated:YES completion:nil];
}



/*

- (NSMutableArray *)operationAdd
{
    NSMutableArray *rowsOfResultArray = [NSMutableArray new];
    NSMutableArray *row = [NSMutableArray new];
    
    for (int i = 0; i < self.matrixSize; ++i) {
        for (int j = 0; j < self.matrixSize; ++j) {
            // one row operation
            // value of matrix A
            UITextField *textFieldA =
            [[self.rowsOfAllMatrix objectAtIndex:(i + MATRIX_A_INDEX * self.matrixSize)]objectAtIndex:j];
            int valueA = [[textFieldA text] intValue];
            
            // value of matrix B
            UITextField *textFieldB =
            [[self.rowsOfAllMatrix objectAtIndex:(i + MATRIX_B_INDEX * self.matrixSize)] objectAtIndex:j];
            int valueB = [[textFieldB text] intValue];
            
            [row addObject:[[NSNumber alloc] initWithInt:valueA + valueB]];
        }
        [rowsOfResultArray addObject:row];
        row = [NSMutableArray new];
    }
    
    return rowsOfResultArray;
}

- (NSMutableArray *)operationSub
{
    NSMutableArray *rowsOfResultArray = [NSMutableArray new];
    NSMutableArray *row = [NSMutableArray new];
    
    for (int i = 0; i < self.matrixSize; ++i) {
        for (int j = 0; j < self.matrixSize; ++j) {
            // one row operation
            // value of matrix A
            UITextField *textFieldA =
            [[self.rowsOfAllMatrix objectAtIndex:(i + MATRIX_A_INDEX * self.matrixSize)]objectAtIndex:j];
            int valueA = [[textFieldA text] intValue];
            
            // value of matrix B
            UITextField *textFieldB =
            [[self.rowsOfAllMatrix objectAtIndex:(i + MATRIX_B_INDEX * self.matrixSize)] objectAtIndex:j];
            int valueB = [[textFieldB text] intValue];
            
            [row addObject:[[NSNumber alloc] initWithInt:valueA - valueB]];
        }
        [rowsOfResultArray addObject:row];
        row = [NSMutableArray new];
    }
    
    return rowsOfResultArray;

}

- (NSMutableArray *)operationMul
{
    
}
*/

- (IBAction)reset:(UIButton *)sender {
    // I told the value changed..it wasn't.
    [self matrixSizeChanged: self.stepper];
}



@end
