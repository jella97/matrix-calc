//
//  ResultViewController.m
//  matrixcalc
//
//  Created by vienna on 2/3/13.
//  Copyright (c) 2013年 a1. All rights reserved.
//

#import "ResultViewController.h"

@interface ResultViewController ()

@end

@implementation ResultViewController

- (IBAction)dismissResultView:(UIButton *)sender {
    
    // free memory
    if (self.resultMatrix)
        NMatrix_Destroy(self.resultMatrix);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
 draw a matrix of textFields,
 textField(1, 1) will locate in rect passed in.
 */
- (void)drawMatrixFields:(CGRect *)pRect
{
    CGRect newFrame = *pRect;
    UITextField *newTextField = nil;
    
    for (int y = 0; y < self.resultMatrix->rows; ++y) {
        // make move
        newFrame.origin.y = pRect->origin.y;
        newFrame.origin.y += y * pRect->size.height;
        
        for (int x = 0; x < self.resultMatrix->columns; ++x) {
            
            newTextField = [[UITextField alloc] initWithFrame:*pRect];
            
            newTextField.delegate = self;
            newTextField.text = [NSString stringWithFormat:@"%+.2f", self.resultMatrix->data[y][x]];
            
            // make move
            newFrame.origin.x = pRect->origin.x;
            newFrame.origin.x += x * pRect->size.width;
            
            
            [newTextField setFrame:newFrame];
            [newTextField setBorderStyle:UITextBorderStyleRoundedRect];

            [self.view addSubview:newTextField];
        }
    }
}

- (NSString *)formatResultString:(NMatrix *)resultMatrix
{
    NSString *strResult = [NSString new];
    
   	for (int i = 0; i < resultMatrix->rows; ++i)
	{
		for (int j = 0; j < resultMatrix->columns; ++j)
		{
            strResult = [NSString stringWithFormat:@"%@%+.2f ", strResult, self.resultMatrix->data[i][j]];
		}
		strResult = [NSString stringWithFormat:@"%@\n", strResult];
	}
    
    return strResult;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // print result
    PrintMatrix(self.resultMatrix);
    
    // draw result fields
    CGRect frameOfMatrixResult = CGRectMake(20, 230, 55, 30);
    [self drawMatrixFields:&frameOfMatrixResult];
    
    // print result in textview
    // [self.resultTextView setFont:[UIFont systemFontOfSize:22]];
    self.resultTextView.text = [self formatResultString:self.resultMatrix];
    self.resultTextView.delegate = self;
    
    // add observer to catch the keyboard hide notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
 when press return key, cancel first responser
 */
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
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


@end
