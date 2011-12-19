//
//  AppDelegate.h
//  mileage
//
//  Created by Chris Clarke on 11/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>{

    NSManagedObjectContext *managedObjectContext;
    NSManagedObjectModel *managedObjectModel;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    UINavigationController IBOutlet *myC;
    UIWindow IBOutlet *window;

}
@property (nonatomic, retain) IBOutlet UINavigationController *myC;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) IBOutlet UIWindow *window;

- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;
- (NSString *)getDistance;
@end
