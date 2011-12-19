//
//  ViewLogEntry.h
//  mileage
//
//  Created by Chris Clarke on 11/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditLogEntry.h"

@class MileageLog;

@interface ViewLogEntry : UIViewController{
    NSManagedObjectContext *managedObjectContext;
	NSFetchedResultsController *fetchedResultsController;
    IBOutlet UILabel *date;
    IBOutlet UILabel *oStart;
    IBOutlet UILabel *oEnd;
    IBOutlet UILabel *distance;
    IBOutlet UITextView *notes;
    UIBarButtonItem *editButton;
    UIBarButtonItem *saveButton;    
    MileageLog *miles;

}
@property (nonatomic, retain) IBOutlet UILabel *distance;
@property (nonatomic, retain) IBOutlet UILabel *oEnd;
@property (nonatomic, retain) IBOutlet UILabel *oStart;
@property (nonatomic, retain) IBOutlet UILabel *date;
@property (nonatomic, retain) IBOutlet UITextView *notes;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) MileageLog *miles;
@property (nonatomic,retain) UIBarButtonItem *editButton;
@property (nonatomic,retain) UIBarButtonItem *saveButton;


- (void) editAction;
- (void) saveAction;

@end
