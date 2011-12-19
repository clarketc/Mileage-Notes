//
//  EditLogEntry.h
//  mileage
//
//  Created by Chris Clarke on 12/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MileageLog.h"

@interface EditLogEntry : UIView{
    MileageLog *miles;
    UIDatePicker *picker;
	UIBarButtonItem *doneButton;	// this button appears only when the date picker is open
    IBOutlet UINavigationBar *mil;
	NSDateFormatter *dateFormatter;  
    UITextView *activeField;
    BOOL keyboardShown;
    BOOL viewMoved;
    IBOutlet UIBarButtonItem *saveButton;
    IBOutlet UIBarButtonItem *cancelButton;    
    UIScrollView* scroller;
}

@property (nonatomic, retain) MileageLog *miles;
@property (nonatomic, retain) IBOutlet UIScrollView *scroller;
@property (nonatomic, retain) IBOutlet UITextField *dateInput;
@property (nonatomic, retain) IBOutlet UITextField *oStartInput;
@property (nonatomic, retain) IBOutlet UITextField *oEndInput;
@property (nonatomic, retain) IBOutlet UITextView *notesInput;

@property (nonatomic, retain) UIDatePicker *picker;
@property (nonatomic, retain) UIBarButtonItem *doneButton;
@property (nonatomic, retain) NSDateFormatter *dateFormatter; 
@property (nonatomic, retain) IBOutlet UINavigationBar *mil; 


@end
