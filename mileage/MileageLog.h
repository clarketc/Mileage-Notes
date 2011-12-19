//
//  MileageLog.h
//  mileage
//
//  Created by Chris Clarke on 11/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MileageLog : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSNumber * oEnd;
@property (nonatomic, retain) NSNumber * oStart;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * notes;

@end
