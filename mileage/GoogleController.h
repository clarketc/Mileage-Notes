//
//  GoogleController.h
//  mileage
//
//  Created by Chris Clarke on 12/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface GoogleController : UIViewController <MBProgressHUDDelegate> {
    IBOutlet UIBarButtonItem *cancelButton; 
    IBOutlet UIBarButtonItem *saveButton; 
    MBProgressHUD *HUD;
    IBOutlet UINavigationBar *navBar;

}
@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;


-(IBAction) cancelAction:(id)sender;
-(IBAction) saveAction:(id)sender;
-(IBAction) showWithGradient:(id)sender;

- (void)myTask;
- (void)myProgressTask;
- (void)myMixedTask;

@end


