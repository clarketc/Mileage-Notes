//
//  Settings.h
//  mileage
//
//  Created by Chris Clarke on 11/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MileageLog.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>


@interface Settings : UIViewController <UIAlertViewDelegate, MFMailComposeViewControllerDelegate>{
    NSManagedObjectContext *managedObjectContext;
    NSFetchedResultsController *fetchedResultsController;
    MileageLog *mil;
    IBOutlet UINavigationBar *navBar;
    
}
- (IBAction)deleteAllAction:(id)sender;
- (IBAction)linkGoogleAction:(id)sender;
- (IBAction)emailAction:(id)sender;

@property (nonatomic, retain) MileageLog *mil;
@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end
