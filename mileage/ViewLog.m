//
//  ViewLog.m
//  mileage
//
//  Created by Chris Clarke on 11/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewLog.h"
#import "AppDelegate.h"
#import "MileageLog.h"

@class MileageLog;
@implementation ViewLog
@synthesize logArray,managedObjectContext,logTable,fetchedResultsController;
@synthesize primaryLabel,secondaryLabel, editButton,addButton;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    id appDelegate = (id)[[UIApplication sharedApplication] delegate]; 
    managedObjectContext = [appDelegate managedObjectContext];
    [[super.tabBarController.viewControllers objectAtIndex:0] tabBarItem].badgeValue = [appDelegate getDistance];

 
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    logTable = [[UITableView alloc] init];
    logTable.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    logTable.delegate = self;
    logTable.dataSource = self;
    [logTable reloadData];
    
    self.view = logTable;
    
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    logTable = nil;
    logTable = nil;
    logTable = nil;
    
    self.fetchedResultsController = nil;
    
    editButton = nil;
    addButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
 
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
    
    if([sectionInfo numberOfObjects] < 1 && !self.editing){
        self.navigationItem.leftBarButtonItem = nil;
    }else{

        if(!self.editing){
            
            if(!editButton){
  
                UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle: @"Edit" 
                                              style: self.navigationController.navigationItem.rightBarButtonItem.style
                                             target: self
                                             action: @selector(EditTable:)];
            } 
            
            self.navigationItem.leftBarButtonItem = editButton;
            [self.navigationItem.leftBarButtonItem setTitle:@"Edit"];
            [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
            
//            
//            if(!emailButton){
//                UIBarButtonItem *emailButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAction                                               target: self action: @selector (emailTable:)];
//            }
               
           // self.navigationItem.rightBarButtonItem = emailButton;
        }
    }
    
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    // Configure the cell to show the book's title
	mil = [fetchedResultsController objectAtIndexPath:indexPath];
    
    NSDate *mileageDate = mil.date;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterShortStyle];
    NSString *dateString = [dateFormat stringFromDate:mileageDate];
    
    primaryLabel = [[UILabel alloc]init];
    primaryLabel.autoresizingMask = NO;
    primaryLabel.textAlignment = UITextAlignmentLeft;
    primaryLabel.font = [UIFont  boldSystemFontOfSize:16];
    primaryLabel.text = dateString;
    
    secondaryLabel = [[UILabel alloc]init];
    secondaryLabel.textAlignment = UITextAlignmentRight;
    secondaryLabel.font = [UIFont  boldSystemFontOfSize:16];
    secondaryLabel.textColor = [UIColor redColor];
    
    if([mil.status isEqualToString:@""]){
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;

        secondaryLabel.text = [[formatter stringFromNumber:mil.distance] stringByAppendingString: @" mil"];
        secondaryLabel.textColor = [UIColor blackColor];

    }else{
       secondaryLabel.text = [mil.status uppercaseString];  
    }

    CGRect contentRect = self.view.bounds;
    CGFloat boundsX = contentRect.origin.x;
    CGRect frame;
    
    [secondaryLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    //[primaryLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];   
    
    frame= CGRectMake(boundsX+10 ,10, 100, 25);
    primaryLabel.frame = frame;
    
    frame= CGRectMake(boundsX+205 ,10, 100, 25);
    secondaryLabel.frame = frame;

    [cell.contentView addSubview:primaryLabel];
    [cell addSubview:secondaryLabel];    
}

 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
     	return tableView.editing;

 }


 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
  
     // Delete the managed object for the given index path
     [managedObjectContext deleteObject:[fetchedResultsController objectAtIndexPath:indexPath]];
     
     // Save the context.
     NSError *error = nil;
     
     if (![managedObjectContext save:&error]) {
         NSLog(@"Error deleting %@ - error:%",error);
     }
     
 // [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }


 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }

 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return NO;
 }


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ViewLogEntry *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"entry"];
    detail.miles = [fetchedResultsController objectAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    [self.navigationController pushViewController:detail animated:YES];
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.logTable beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [logTable insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [logTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[logTable cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [logTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            // Reloading the section inserts a new row and ensures that titles are updated appropriately.
            [logTable reloadSections:[NSIndexSet indexSetWithIndex:newIndexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.logTable insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.logTable deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];

            break;
    }
}




- (IBAction) EditTable:(id)sender{

	if(self.editing)
	{
		[super setEditing:NO animated:YES]; 
		[logTable setEditing:NO animated:YES];
		//[logTable reloadData];
		[self.navigationItem.leftBarButtonItem setTitle:@"Edit"];
		[self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
	}
	else
	{
		[super setEditing:YES animated:YES]; 
		[logTable setEditing:YES animated:YES];
		//[logTable reloadData];
		[self.navigationItem.leftBarButtonItem setTitle:@"Done"];
		[self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStyleDone];
	}
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
//    NSLog(@"Table Should Update");
    
    id appDelegate = (id)[[UIApplication sharedApplication] delegate]; 
    [[super.tabBarController.viewControllers objectAtIndex:0] tabBarItem].badgeValue = [appDelegate getDistance];
    
    [self.logTable endUpdates];
}

@end
