//
//  logIt.m
//  mileage
//
//  Created by Chris Clarke on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import <CoreData/CoreData.h>
#import "AppDelegate.h";
#import "MileageLog.h";
#import "logIt.h";
#import "SCAppUtils.h"

@implementation logIt

@synthesize dateInput;
@synthesize oStartInput;
@synthesize oEndInput;
@synthesize notesInput;
@synthesize managedObjectContext, picker;
@synthesize dateFormatter, mil,scroller;

#define PICKER_ANIMATION_DELAY	0.1
#define PICKER_ANIMATION_DURATION	0.3

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void)viewWillDisappear:(BOOL)animated {
    if(self.picker.superview != nil){
        [self.picker removeFromSuperview];
        self.picker = nil;
    }

    [super viewWillAppear:animated];
}

- (BOOL)textViewShouldBeginEditing:(UITextField *)textView{
    
    activeField = textView;
 
    if(self.picker.superview != nil){
        [self.picker removeFromSuperview];
        self.picker = nil;
    }
    
    [textView becomeFirstResponder];
    
    if(doneButton == nil){
        doneButton = [[UIBarButtonItem alloc]
                      initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                      target:self
                      action:@selector(doneAction:)];
    } 

    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Mileage Entry"];
    item.rightBarButtonItem = doneButton;
    item.hidesBackButton = YES;
    [mil pushNavigationItem:item animated:NO];
    
    return YES;
}    

- (void)textViewDidEndEditing:(UITextView *)textView {
    activeField = textView;

}

- (void)textFieldDidEndEditing:(UITextField *)textField {

    if(activeField == notesInput){
        
        NSTimeInterval animationDuration = 0.300000011920929;
        CGPoint bottomOffset = CGPointMake(0, [scroller contentSize].height - scroller.frame.size.height  - 50);
        
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        [scroller setContentOffset: bottomOffset animated: YES];
        [UIView commitAnimations];
        
        viewMoved = YES;
    }

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    activeField = textField;
                
    if(doneButton == nil){
       
        doneButton = [[UIBarButtonItem alloc]
                      initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                      target:self
                      action:@selector(doneAction:)];
    } 
 
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Mileage Entry"];
    item.rightBarButtonItem = doneButton;
    item.hidesBackButton = YES;
    [mil pushNavigationItem:item animated:NO];
    
    
    // If true, user clicked on date field. Bring up date picker.
    if ((textField.tag & 1) == 0) {
        
       
        [scroller setScrollEnabled:YES];
        
        [oStartInput resignFirstResponder];
        [oEndInput resignFirstResponder];
        [notesInput resignFirstResponder];  

        // Have done buttons for the Picker choice ready to go
            
        // Set up time picker if none present
        if (self.picker.superview == nil) {
            picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,0,320,216)];
            picker.datePickerMode = UIDatePickerModeDate;
            picker.minuteInterval = 15.0;
            [picker addTarget:self
                         action:@selector(dateAction:)
               forControlEvents:UIControlEventValueChanged];
            
        }
        
        self.picker.date = [self.dateFormatter dateFromString:textField.text];
        self.picker.tag = textField.tag;	// Ensure that the tag value gets forwarded to the action handler
        
        // Check if our date picker is already on screen. If not, perform picker view creation stuff.
        if (self.picker.superview == nil)
        {
            
           
            // Add the picker		
            [self.view.window addSubview:self.picker];
            
            // size up the picker view to our screen and compute the start/end frame origin for our slide up animation
            //
            // compute the start frame
            
            CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
            CGSize pickerSize = [self.picker sizeThatFits:CGSizeZero];
            CGRect startRect = CGRectMake(0.0,
                                          screenRect.origin.y + screenRect.size.height,
                                          pickerSize.width, pickerSize.height);
            self.picker.frame = startRect;
            
            // compute the end frame
            CGRect pickerRect = CGRectMake(0.0,
                                           screenRect.origin.y + screenRect.size.height - pickerSize.height,
                                           pickerSize.width,
                                           pickerSize.height);
            // start the slide up animation
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:PICKER_ANIMATION_DURATION];
            [UIView setAnimationDelay:PICKER_ANIMATION_DELAY];			// Give time for the table to scroll before animating the picker's appearance
            
            // we need to perform some post operations after the animation is complete
            
            [UIView setAnimationDelegate:self];
            
            self.picker.frame = pickerRect;
            
            [UIView commitAnimations];
             return NO;
        }    
    }else{
            
        //If picker is already displayed remove it
        if(self.picker.superview != nil){
        	[self.picker removeFromSuperview];
            self.picker = nil;
        }
        return YES;
    } 
}

#pragma mark -
#pragma mark UIPickerViewDataSource

//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
//{
//	return [setPointPickerViewArray count];
//}

//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
//{
//	return 1;
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	

}
// Set the size of the component wheel on the picker
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	CGFloat componentWidth = 60.0;
	
	return componentWidth;
}

- (IBAction)dateAction:(id)sender
{
	// Fetch the tag in order to derive that column, row, and textfield of the picker choice
	NSUInteger tag = picker.tag;			
	NSUInteger row = (tag % 100) / 10;
	NSUInteger section = (tag / 100);
}

- (IBAction)doneAction:(id)sender
{
    [scroller setScrollEnabled:NO];
    
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
	CGRect endFrame = self.picker.frame;
	endFrame.origin.y = screenRect.origin.y + screenRect.size.height;
    
    if(self.picker.superview != nil){
            
        // Create date object  
        NSDate *date = self.picker.date;
        
        // Create date formatter
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yy"];
        
        // Create date string from formatter, using the current date
        NSString *dateString = [dateFormatter stringFromDate:date];  

        dateInput.text = dateString;
  
        // start the slide down animation
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:PICKER_ANIMATION_DURATION];
        
        // we need to perform some post operations after the animation is complete
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(slideDownDidStop)];
        
        self.picker.frame = endFrame;
        [UIView commitAnimations];
    }else{
          [oStartInput resignFirstResponder];
          [oEndInput resignFirstResponder];
          [notesInput resignFirstResponder];   
    }    
	
    if(saveButton == nil){
        saveButton = [[UIBarButtonItem alloc]
                        initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                        target:self
                        action:@selector(sButton:)];
    }
    
    if(cancelButton == nil){
        cancelButton = [[UIBarButtonItem alloc]
                      initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                      target:self
                      action:@selector(cButton:)];
    }
    
	// remove the "Done" button in the nav bar
    
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Mileage Entry"];
    item.rightBarButtonItem = saveButton;
    item.leftBarButtonItem = cancelButton;
    [mil pushNavigationItem:item animated:NO];
 
}


- (void)slideDownDidStop
{
	
	// the date picker has finished sliding downwards, so remove it
	[self.picker removeFromSuperview];
	self.picker = nil;
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [SCAppUtils customizeNavigationBar:navBar];
    
    [scroller setScrollEnabled:NO];
    [scroller setContentSize:CGSizeMake(320, 700)];

    id appDelegate = (id)[[UIApplication sharedApplication] delegate]; 
    managedObjectContext = [appDelegate managedObjectContext];
    NSManagedObjectContext *context = [self managedObjectContext];
    
	self.dateFormatter = [[NSDateFormatter alloc] init];
	[self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
	[self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    // Create date object  
    NSDate *date = [NSDate date];
    
    // Create date formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yy"];
    
    // Create date string from formatter, using the current date
    NSString *dateString = [dateFormatter stringFromDate:date];  
    
    dateInput.text = dateString;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasHidden:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    [super viewDidLoad];
}

- (void)keyboardWasShown:(NSNotification *)aNotification {
      
    [scroller setScrollEnabled:YES];
    if (keyboardShown)
        return;
   
    if(activeField == notesInput){
        
        NSDictionary *info = [aNotification userInfo];
        NSValue *aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey];
        CGSize keyboardSize = [aValue CGRectValue].size;
        
        NSTimeInterval animationDuration = 0.300000011920929;
        CGPoint bottomOffset = CGPointMake(0, [scroller contentSize].height - scroller.frame.size.height  - 50);
        
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        [scroller setContentOffset: bottomOffset animated: YES];
        [UIView commitAnimations];
        
        viewMoved = YES;
    }
    
    keyboardShown = YES;
}

- (void)keyboardWasHidden:(NSNotification *)aNotification {
    
    if (viewMoved) {
        NSDictionary *info = [aNotification userInfo];
        NSValue *aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey];
        CGSize keyboardSize = [aValue CGRectValue].size;
        
        NSTimeInterval animationDuration = 0.300000011920929;

        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        [scroller scrollRectToVisible:CGRectMake(0,0,1,1) animated:YES];
        [UIView commitAnimations];
        
        viewMoved = NO;
    }
    
    keyboardShown = NO;
}

- (void)viewDidUnload
{
    [self setDateInput:nil];
    [self setOStartInput:nil];
    [self setOEndInput:nil];
    [self setNotesInput:nil];
    self.dateFormatter = nil;
    self.scroller = nil;

    saveButton = nil;
    mil = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

// return the picker frame based on its size, positioned at the bottom of the page
- (CGRect)pickerFrameWithSize:(CGSize)size
{
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    CGRect pickerRect = CGRectMake(	0.0,
                                   screenRect.size.height - size.height,
                                   size.width,
                                   size.height);
    return pickerRect;
}
    
    
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)cButton:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)sButton:(id)sender {
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *mileage = [NSEntityDescription
                                insertNewObjectForEntityForName:@"Miles" 
                                inManagedObjectContext:context];
     
    if([oStartInput.text isEqualToString:@""] && ![oEndInput.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Missing Input" 
                                                    message:@"Please enter a value for odometer start"
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
        [alert show];
        return;
    }  
    
    //convert input to interger values
    int sInt = [oStartInput.text intValue];
    int eInt = [oEndInput.text intValue];  

    
    NSNumber *startS = [NSNumber numberWithInt: sInt];
    NSNumber *endS = [NSNumber numberWithInt: eInt];    
    
    if(![oStartInput.text isEqualToString:@""] && ![oEndInput.text isEqualToString:@""]){
        
        if (sInt > eInt) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incorrect Value" 
                                                            message:@"Odometer end needs to be more than odometer start"
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
            
        }else{
            //compute distance
            int distance = eInt - sInt;
        
            NSNumber *distanceS = [NSNumber numberWithInt: distance];    
      
            [mileage setValue:distanceS forKey:@"distance"];
            
        }
    }

    NSDate *dateFromString = [[NSDate alloc] init]; // <- non freed instance
    dateFromString = [dateFormatter dateFromString:dateInput.text];
    
    [mileage setValue: dateFromString forKey:@"date"];
    [mileage setValue: startS forKey:@"oStart"];
    [mileage setValue: endS forKey:@"oEnd"];
    
    if([oStartInput.text isEqualToString:@""] || [oEndInput.text isEqualToString:@""]){
        [mileage setValue:@"draft" forKey:@"status"];
    }else{
        [mileage setValue:@"" forKey:@"status"];
    }
      [mileage setValue:notesInput.text forKey:@"notes"];  
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    id appDelegate = (id)[[UIApplication sharedApplication] delegate]; 
    [[super.tabBarController.viewControllers objectAtIndex:0] tabBarItem].badgeValue = [appDelegate getDistance];
    
    
    [self dismissModalViewControllerAnimated:YES];
}



@end
