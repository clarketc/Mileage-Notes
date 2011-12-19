//
//  Settings.m
//  mileage
//
//  Created by Chris Clarke on 11/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Settings.h"
#import "AppDelegate.h"
#import "SCAppUtils.h"

@implementation Settings
@synthesize managedObjectContext, fetchedResultsController,mil;


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
//- (void)loadView
//{
//  
//}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{

    [SCAppUtils customizeNavigationBar:navBar];

    
    id appDelegate = (id)[[UIApplication sharedApplication] delegate]; 
    managedObjectContext = [appDelegate managedObjectContext];

    
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    self.fetchedResultsController = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"OK"])
    {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Miles" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSError *error;
        NSArray *items = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        
        for (NSManagedObject *managedObject in items) {
            [managedObjectContext deleteObject:managedObject];
            NSLog(@"object deleted Miles");
        }
        if (![managedObjectContext save:&error]) {
            NSLog(@"Error deleting %@ - error:%",error);
        }
        
        id appDelegate = (id)[[UIApplication sharedApplication] delegate]; 
        [[super.tabBarController.viewControllers objectAtIndex:0] tabBarItem].badgeValue = [appDelegate getDistance];

    }
    else if([title isEqualToString:@"Cancel"])
    {
        return;
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
}

-(IBAction) emailAction:(id)sender{
    
    
    NSError *error;
    
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }

    
    //Create the dateformatter object
    NSDateFormatter* formatter1 = [[NSDateFormatter alloc] init];
    NSDate* date = [NSDate date];
    
    //Set the required date format
    [formatter1 setDateFormat:@"yyyy-MM-dd"];
    NSString *fName = [@"mileageLog-" 
                       stringByAppendingString:[formatter1 stringFromDate:date]];
    fName = [fName stringByAppendingString:@".txt"];

    // File we want to create in the documents directory 
    NSString *documentsDirectory = [NSHomeDirectory() 
                                    stringByAppendingPathComponent:@"Documents"];
    
    NSString *rootPath = documentsDirectory;
    NSString *filePath = [rootPath 
                          stringByAppendingPathComponent:fName];
    
    // Get data log and write it in a readable format    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterShortStyle];
  
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;

    NSString *dateString;
    NSString *str = @"";
    NSString *str2;
    
    //Make sure there are notes to email
    if([[fetchedResultsController fetchedObjects] count] > 0){

            //loop through data and create file
            for (MileageLog *entry in self.fetchedResultsController.fetchedObjects)
            {    
                
                dateString = [dateFormat stringFromDate:entry.date];
                
                str = [str stringByAppendingString:@"\n"]; 
                str = [str stringByAppendingString:dateString];

                
                if(![entry.status isEqualToString:@""]){
                    str = [str stringByAppendingString:@" Draft"];                      
                }

                str = [str stringByAppendingString:@"\n-----------------------------\n"];          
                str = [str stringByAppendingString:@"Start: "];
              
                if(entry.oStart > 0){
                    str = [str stringByAppendingString:[formatter stringFromNumber:entry.oStart]];               
                }
                str = [str stringByAppendingString:@"\nEnd: "];
                if(entry.oEnd > 0){
                    str = [str stringByAppendingString:[formatter stringFromNumber:entry.oEnd]];               
                }
              
                str = [str stringByAppendingString:@"\nDistance: "];
                if(entry.distance > 0){
                    str = [str stringByAppendingString:[formatter stringFromNumber:entry.distance]];               
                }
                    
                str = [str stringByAppendingString:@" miles \nNotes:\n"];   
                if(![entry.notes isEqualToString:@""]){
                    str = [str stringByAppendingString:entry.notes];                         
                }
                
                str = [str stringByAppendingString:@"\n"]; 
                
            }
        
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
                                       
            //prepend distance to top along with header, change "Append" below
           str2 = [@"Mileage Notes Created By the App " stringByAppendingString:[formatter1 stringFromDate:date]];
           str2 = [str2 stringByAppendingString:@"\nYou can even sync your mileage notes with your Google Docs account.  Check it out in the app settings!  It's safe and secure."]; 

           id appDelegate = (id)[[UIApplication sharedApplication] delegate]; 
           
           str2 = [str2 stringByAppendingString:@"\n\n"]; 
           str2 = [str2 stringByAppendingString:@"Total Distance: "]; 
        
           str2 = [str2 stringByAppendingString:[appDelegate getDistance]];
           str2 = [str2 stringByAppendingString:@" miles\n"]; 
           str2 = [str2 stringByAppendingString:str]; 
                                       
    }else{
    
        UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"Hey There!" 
                                                        message:@"There are no notes to email"
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert2 show];
        return;
    }    
    
    NSError *error2;
    
    // CREATE FILE
    BOOL ok = [str2 writeToFile:filePath atomically:YES encoding:NSUnicodeStringEncoding error:&error2];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])		//Does file exist?
    {
        NSLog(@"This file does exists");
    }else
    {
        NSLog(@"This file DOES NOT exists");
    }
    
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
	controller.mailComposeDelegate = self;    
    
    NSString *bodyMessage;
    
    bodyMessage = @"Attached is your mileage notes file:";
    
    //ATTACH FILE
    
    NSLog(@"Attaching file: %@", filePath);
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])		//Does file exist?
    {
        NSLog(@"File exists to attach");
        
        NSData *myData = [NSData dataWithContentsOfFile:filePath];
        
        [controller addAttachmentData:myData mimeType:@"application/octet-stream" fileName:fName];
    }
    
	[controller setSubject:@"Your Mileage Notes"];
	[controller setMessageBody:bodyMessage isHTML:NO];
	[self presentModalViewController:controller animated:YES];
    
}

- (IBAction)deleteAllAction:(id)sender {
    
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }

    //Make sure there are notes to email
    if([[fetchedResultsController fetchedObjects] count] > 0){

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete all Notes" 
                                                        
                                                    message:@"This deletes all data.  Are you sure? "
                                                       delegate:self 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:@"Cancel", nil];
        [alert show];
     
        return;
    }else{

        UIAlertView *alert3 = [[UIAlertView alloc] initWithTitle:@"Hey There!" 
                                                         message:@"There are no notes to delete"
                                                        delegate:nil 
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        [alert3 show];
        return;    
    
    }
}

- (IBAction)linkGoogleAction:(id)sender {
}

/**
 Returns the fetched results controller. Creates and configures the controller if necessary.
 */
- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
    
	// Create and configure a fetch request with the Book entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Miles" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	// Create the sort descriptors array.
	NSSortDescriptor *dateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:dateDescriptor, nil];
    
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	// Create and initialize the fetch results controller.
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
	self.fetchedResultsController = aFetchedResultsController;
	fetchedResultsController.delegate = self;
	
	
    return fetchedResultsController;
}    

@end
