//
//  MatrixViewController.m
//  MatrixCalc
//
//  Created by vienna on 23/2/13.
//  Copyright (c) 2013年 a1. All rights reserved.
//

#import "MatrixViewController.h"
#import "ResultViewController.h"
#import "HeaderViewController.h"
#import "CollectionCell.h"

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

#define WIDTH_OF_TEXTFIELD 55


//@synthesize matrixSize = _matrixSize;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    

    // init the matrix size with 1
    self.matrixSize = 3;

    self.sectionNow = 0;
    
    self.rowsOfAllMatrix = [NSMutableArray new];
    self.oneRowInMatrix = [NSMutableArray new];

    

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


- (IBAction)matrixSizeChange:(UIStepper *)sender {
    
    self.matrixSize = [sender value];
    
    // remove all textFields in array
    /*
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
    */
    // [self drawFields];
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
    
    matrixA = NMatrix_Create(self.matrixSize, self.matrixSize);
    matrixB = NMatrix_Create(self.matrixSize, self.matrixSize);
    
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
            
            
            NSLog(@"i = %d, j = %d count rows = %d \n", i, j, self.rowsOfAllMatrix.count);
        }
    }
    
    switch (self.segmentedControl.selectedSegmentIndex) {
            
        case OPERATION_ADD:
            resultView.resultMatrix = NMatrix_Sum(matrixA, matrixB);
            break;
            
        case OPERATION_SUB:
            resultView.resultMatrix =
                NMatrix_Sum(matrixA, NMatrix_MultiplyWithScalar(matrixB, -1));
            break;
            
        case OPERATION_MUL:
            resultView.resultMatrix = NMatrix_Product(matrixA, matrixB);
            break;
            
        case OPERATION_INV:
            resultView.resultMatrix = NMatrix_Inverse(matrixA);
            break;
            
        default:
            break;
    }
    
    // free memory
    NMatrix_Destroy(matrixA);
    NMatrix_Destroy(matrixB);
    [self presentViewController:resultView animated:YES completion:nil];
}



- (IBAction)reset:(UIButton *)sender {
    // I told the value changed..it wasn't.
    // [self matrixSizeChanged: self.stepper];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.matrixSize;
}

// collection view delegates
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.matrixSize * 3;
    
}

// callback for every cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FieldCell" forIndexPath:indexPath];
    
    if (!cell)
        cell = [CollectionCell new];

    cell.textField.delegate = self;
    
    // change keyboard style
    cell.textField.returnKeyType = UIReturnKeyDone;
    cell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    if (indexPath.section != self.sectionNow) {
        self.sectionNow++;
        [self.rowsOfAllMatrix addObject: self.oneRowInMatrix];
        self.oneRowInMatrix = [NSMutableArray new];
    }
    
    NSLog(@"section = %d \n", indexPath.section);
    
    [self.oneRowInMatrix addObject:cell.textField];
    
    return cell;
}

/*
 size definition in custom cell class.
 */ 
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(55, 30);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{

    UIEdgeInsets edgeInset = {0};
    
    // space in each matrix
    if (section % self.matrixSize == 0) {
        edgeInset = UIEdgeInsetsMake(30, 2, 5, 2);
    } else {
        edgeInset = UIEdgeInsetsMake(5, 2, 5, 2);
    }
    
    return edgeInset;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
