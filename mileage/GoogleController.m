//
//  GoogleController.m
//  mileage
//
//  Created by Chris Clarke on 12/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GoogleController.h"
#import "SCAppUtils.h"

@implementation GoogleController

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
- (IBAction)cancelAction:(id)sender:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)saveAction {
    // Do something usefull in here instead of sleeping ...
    sleep(3);
}
-(IBAction) showWithGradient:(id)sender{

    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	
	HUD.dimBackground = YES;
	
	// Regiser for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
	
    // Show the HUD while the provided method executes in a new thread
    [HUD showWhileExecuting:@selector(saveAction) onTarget:self withObject:nil animated:YES];
}


#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [SCAppUtils customizeNavigationBar:navBar];

    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
