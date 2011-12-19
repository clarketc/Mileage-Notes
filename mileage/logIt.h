//
//  logIt.h
//  mileage
//
//  Created by Chris Clarke on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "ViewLog.h"


@interface logIt : UIViewController <UITextFieldDelegate,UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>{    
    NSManagedObjectContext *managedObjectContext;
    UIDatePicker *picker;
	UIBarButtonItem *doneButton;	// this button appears only when the date picker is open
    IBOutlet UINavigationBar *mil;
	NSDateFormatter *dateFormatter;  
    UITextView *activeField;
    BOOL keyboardShown;
    BOOL viewMoved;
    IBOutlet UIBarButtonItem *saveButton;
    IBOutlet UIBarButtonItem *cancelButton;    
    ViewLog *viewLogTable;
    UIScrollView* scroller;
    IBOutlet UINavigationBar *navBar;
    
}

-(IBAction) sButton:(id)sender;
-(IBAction) cButton:(id)sender;
@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;
@property (nonatomic, retain) IBOutlet UIScrollView *scroller;
@property (nonatomic, retain) IBOutlet UITextField *dateInput;
@property (nonatomic, retain) IBOutlet UITextField *oStartInput;
@property (nonatomic, retain) IBOutlet UITextField *oEndInput;
@property (nonatomic, retain) IBOutlet UITextView *notesInput;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) UIDatePicker *picker;
@property (nonatomic, retain) UIBarButtonItem *doneButton;
@property (nonatomic, retain) NSDateFormatter *dateFormatter; 
@property (nonatomic, retain) IBOutlet UINavigationBar *mil; 

@end
