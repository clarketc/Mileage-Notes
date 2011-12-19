//
//  ViewLogEntry.m
//  mileage
//
//  Created by Chris Clarke on 11/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewLogEntry.h"
#import "MileageLog.h"

@implementation ViewLogEntry

@synthesize distance;
@synthesize oEnd;
@synthesize oStart;
@synthesize date;
@synthesize notes;
@synthesize managedObjectContext,fetchedResultsController,miles, editButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
//- (void)loadView
//{
//  }

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    
    if(editButton == nil){
        editButton = [[UIBarButtonItem alloc]
                      initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                      target:self
                      action:@selector(editAction:)];
    } 
   
    self.navigationItem.rightBarButtonItem = editButton;

    
    //add tab bar button for edit here
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterShortStyle];
    NSString *dateString = [dateFormat stringFromDate:miles.date];
    
    self.title = dateString;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    oStart.text = [formatter stringFromNumber:miles.oStart];
    oEnd.text = [formatter stringFromNumber:miles.oEnd];
    
    distance.text = [formatter stringFromNumber:miles.distance];
    notes.text = miles.notes;

    [super viewDidLoad];
}

- (IBAction)editAction:(id)sender
{

    
    //if(saveButton == nil){
    //    saveButton = [[UITabBarItem alloc] init];
    //}
    
	// remove the "Done" button in the nav bar
	//self.navigationItem.rightBarButtonItem = saveButton;
    
     EditLogEntry *editView = [[EditLogEntry alloc] init];
     //editView.miles = miles;
    
    [UIView transitionFromView:self.view
                        toView:editView
                      duration:3.0
                       options:UIViewAnimationTransitionCurlDown
                    completion:nil
     ];


}

- (IBAction)saveAction:(id)sender
{
    
//    if(editButton == nil){
//        editButton = [[UITabBarItem alloc] init];
//    }
    
	// remove the "Done" button in the nav bar
	//self.navigationItem.rightBarButtonItem = editButton;
}
- (void)viewDidUnload
{
    [self setDistance:nil];
    [self setOEnd:nil];
    [self setOStart:nil];
    [self setDate:nil];
    [self setNotes:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
