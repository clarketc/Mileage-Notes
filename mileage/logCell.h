//
//  logCell.h
//  mileage
//
//  Created by Chris Clarke on 11/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface logCell : UITableViewCell{
    IBOutlet UILabel *date;
	IBOutlet UILabel *status;
}

@property (nonatomic,retain) IBOutlet UILabel *date;
@property (nonatomic,retain) IBOutlet UILabel *status;

@end
