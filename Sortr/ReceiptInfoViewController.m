//
//  ReceiptInfoViewController.m
//  Sortr
//
//  Created by KrisMraz on 12/10/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import "ReceiptInfoViewController.h"

#import "ActionSheetCustomPickerDelegate.h"
#import "ActionSheetLocalePicker.h"
#import "ActionSheetStringPicker.h"
#import "AddClientViewController.h"
#import <pop/POP.h>


@interface ReceiptInfoViewController ()  <UIGestureRecognizerDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate>
{
    NSMutableArray *clients;
    UIDatePicker *datepicker;
    
    NSMutableArray *categories;
    CGFloat rotation;
}
@end

@implementation ReceiptInfoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self addGestureRecognizersToPiece];
    
    [self.receiptPreviewHolder setHidden:YES];
    [self.receiptImage setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *receiptPreview = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(previewReceiptImage:)];
    receiptPreview.numberOfTapsRequired = 1;
    receiptPreview.delegate = self;
    
    [self.receiptImage addGestureRecognizer:receiptPreview];
    
    [self.receiptImage setImage: [UIImage imageWithData:self.receiptData.image]];
    [self.receiptPreview setImage: [UIImage imageWithData:self.receiptData.image]];
    
    self.receiptPreviewHolder.layer.borderColor = [UIColor orangeColor].CGColor;
    self.receiptPreviewHolder.layer.borderWidth = 2;
    self.receiptPreviewHolder.layer.cornerRadius = 10;
    
    self.clientNameBtn.layer.cornerRadius = 5;
    self.categoryBtn.layer.cornerRadius = 5;
    
    clients = [NSMutableArray new];
    for (ClientObject *c in [[SortrDataManager sharedInstance] getAllClients]) {
        [clients addObject:c.name];
    }
    
    categories = [NSMutableArray new];
    for (CategoryObject *cn in [[SortrDataManager sharedInstance] getAllCategories]) {
        [categories addObject:cn.name];
    }
    
   // [self setPickerHidden:YES];
    [self displayData];
    [self setDelegatesForTxtfields];
}

- (void) viewWillDisappear:(BOOL)animated
{
        [[SortrDataManager sharedInstance] updateReceipt:_receiptData.receiptId
                                          withOfficialID:_receiptData.receiptId
                                                category:self.categoryBtn.titleLabel.text
                                               withTotal:self.headerTotal.text
                                                     vat:self.vatValue.text
                                                  branch:self.storeName.text
                                             receiptDate:self.receiptDate.text
                                              clientName:self.clientNameBtn.titleLabel.text
                                           receiptStatus:_receiptData.receiptStatus];
    
}

/**
 *  Set delegates for all textfields to be able to change property of keyboards
 */
- (void) setDelegatesForTxtfields
{
    [self.storeName setDelegate:self];
    [self.receiptDate setDelegate:self];
    [self.vatValue setDelegate:self];
    [self.headerTotal setDelegate:self];

    datepicker                = [[UIDatePicker alloc] init];
    datepicker.datePickerMode = UIDatePickerModeDate;
    
    UIToolbar *tb               = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 50, 320, 40)];
    UIBarButtonItem *buttonDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:nil];
    tb.items                    = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], buttonDone];
    
    buttonDone.target = self;
    buttonDone.action = @selector(updateReceiptDate);
    
    self.receiptDate.inputView = datepicker;
    self.receiptDate.inputAccessoryView = tb;
}

/**
 *  Update Receipt Date manually by the user
 */
- (void) updateReceiptDate
{
    NSDate *eDate              = datepicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd, yyyy"];
    
    NSString *dateString = [formatter stringFromDate:eDate];
    self.receiptDate.text = [NSString stringWithFormat:@"%@", dateString ];
    
    [self.receiptDate resignFirstResponder];
 }

/**
 *  Display data of receipt
 */
- (void) displayData {
    BOOL containsLetter = NSNotFound != [self.receiptData.date rangeOfCharacterFromSet:NSCharacterSet.letterCharacterSet].location;
 
    if (containsLetter) {
        self.receiptDate.text = [NSString stringWithFormat:@"%@", self.receiptData.date ];
    }
    else
    {
        NSTimeInterval utcEpoc = [self.receiptData.date doubleValue] / 1000;
        NSDate *eDate = [[NSDate alloc] initWithTimeIntervalSince1970:utcEpoc];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM dd, yyyy"];
        
        NSString *dateString = [formatter stringFromDate:eDate];
        
        self.receiptDate.text = [NSString stringWithFormat:@"%@", dateString ];

    }
    
    self.headerTotal.text = [NSString stringWithFormat:@"%.2f", [self.receiptData.total floatValue]];
    self.totalAmount.text = [NSString stringWithFormat:@"%@", self.receiptData.total ];
    
    self.storeName.text = [[NSString stringWithFormat:@"%@", self.receiptData.branch] capitalizedString];
    self.vatValue.text     = [NSString stringWithFormat:@"%.2f", [self.receiptData.vat floatValue]  ];
    
    [self.clientNameBtn setTitle:self.receiptData.client forState:UIControlStateNormal];
    [self.categoryBtn setTitle:self.receiptData.category forState:UIControlStateNormal];
}


- (void) viewDidAppear:(BOOL)animated {
    
    [clients removeAllObjects];
    for (ClientObject *c in [[SortrDataManager sharedInstance] getAllClients]) {
        [clients addObject:c.name];
    }
}

/**
 *  set client manually by the users
 *
 *  @param sender button
 */
- (IBAction)setClient:(id)sender {
    
    if (clients.count > 0 ) {
        
        [ActionSheetStringPicker showPickerWithTitle:@"Select Client" rows:clients initialSelection:0 target:self successAction:@selector(clientAdded:element:) cancelAction:nil origin:sender];
    }
    else
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Add client problem" message:@"You don't have any client" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add Client", nil];
        av.tag = 001;
        [av show];
    }
    
}

/**
 *  set category manually by the user
 *
 *  @param sender button
 */
- (IBAction)setCategory:(id)sender
{
    if (categories.count > 0) {
           [ActionSheetStringPicker showPickerWithTitle:@"Select Category" rows:categories initialSelection:0 target:self successAction:@selector(categoryUpdated:element:) cancelAction:nil origin:sender];
    }else
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Add category problem" message:@"You don't have any category" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [av show];
    }

}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 001) {
        if (buttonIndex != 0) {
            
            AddClientViewController *acv = [[AddClientViewController alloc] init];
            [self presentViewController:acv animated:YES completion:nil];
            
        }
    }
}


- (void)clientAdded:(NSNumber *)selectedIndex element:(id)element
{
    NSString * clientSelected = [clients objectAtIndex:[selectedIndex intValue]];
    [self.clientNameBtn setTitle:clientSelected forState:UIControlStateNormal];
}

- (void) categoryUpdated : (NSNumber*) index element:(id)element {
    NSString * categorySelected = [categories objectAtIndex:[index intValue]];
    [self.categoryBtn setTitle:categorySelected forState:UIControlStateNormal];
}

/**
 *  receiptPreviewHolder setHidden False here
 *
 *  @param tap tap gesture
 */
- (void) previewReceiptImage : (UITapGestureRecognizer *)tap {
    [self.receiptPreviewHolder setHidden:NO];
}

- (IBAction)closePreview:(id)sender {
    [self.receiptPreviewHolder setHidden:YES];
}

#pragma mark UIIMage Scale

// adds a set of gesture recognizers to one of our piece subviews
- (void)addGestureRecognizersToPiece
{
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotatePiece:)];
    [rotationGesture setDelegate:self];
    [_receiptPreview addGestureRecognizer:rotationGesture];
    
     UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPiece:)];
     [tapGesture setDelegate:self];
     [_receiptPreview addGestureRecognizer:tapGesture];
    
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scalePiece:)];
    [pinchGesture setDelegate:self];
    [_receiptPreview addGestureRecognizer:pinchGesture];
    
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPiece:)];
    [panGesture setMaximumNumberOfTouches:2];
    [panGesture setDelegate:self];
    [_receiptPreview addGestureRecognizer:panGesture];
    
    
}

#pragma mark -
#pragma mark === Utility methods  ===
#pragma mark

// scale and rotation transforms are applied relative to the layer's anchor point
// this method moves a gesture recognizer's view's anchor point between the user's fingers
- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *piece = gestureRecognizer.view;
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
        
        piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
        piece.center = locationInSuperview;
    }
}


#pragma mark -
#pragma mark === Touch handling  ===
#pragma mark

// when tapping on the the image view it toggles between the originial image
// and the processed image
- (void)tapPiece:(UITapGestureRecognizer *)gestureRecognizer
{
    [self.receiptPreviewHolder setHidden:YES];
}
// shift the piece's center by the pan amount
// reset the gesture recognizer's translation to {0, 0} after applying so the next callback is a delta from the current position
- (void)panPiece:(UIPanGestureRecognizer *)gestureRecognizer
{
    
    UIView *piece = [gestureRecognizer view];
    
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gestureRecognizer translationInView:[piece superview]];
        
        [piece setCenter:CGPointMake([piece center].x + translation.x, [piece center].y + translation.y)];
        [gestureRecognizer setTranslation:CGPointZero inView:[piece superview]];
    }
}

// rotate the piece by the current rotation
// reset the gesture recognizer's rotation to 0 after applying so the next callback is a delta from the current rotation
- (void)rotatePiece:(UIRotationGestureRecognizer *)gestureRecognizer
{
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        [gestureRecognizer view].transform = CGAffineTransformRotate([[gestureRecognizer view] transform], [gestureRecognizer rotation]);
        rotation += [gestureRecognizer rotation];
        [gestureRecognizer setRotation:0];
    }
}

// scale the piece by the current scale
// reset the gesture recognizer's rotation to 0 after applying so the next callback is a delta from the current scale
- (void)scalePiece:(UIPinchGestureRecognizer *)gestureRecognizer
{
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        [gestureRecognizer view].transform = CGAffineTransformScale([[gestureRecognizer view] transform], [gestureRecognizer scale], [gestureRecognizer scale]);
        [gestureRecognizer setScale:1];
        
    }
}

// ensure that the pinch, pan and rotate gesture recognizers on a particular view can all recognize simultaneously
// prevent other gesture recognizers from recognizing simultaneously
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // if the gesture recognizers are on different views, don't allow simultaneous recognition
    if (gestureRecognizer.view != otherGestureRecognizer.view)
        return NO;
    
    // if either of the gesture recognizers is the long press, don't allow simultaneous recognition
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]] || [otherGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
        return NO;
    
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)resignKeyboard {
    
    [keyboardToolbar removeFromSuperview];
     ///do nescessary date calculation here
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
