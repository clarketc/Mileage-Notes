//
//  main.m
//  mileage
//
//  Created by Chris Clarke on 11/10/11.
//  Copyright (c) 2011 Freehand LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "SCClassUtils.h"

int main(int argc, char *argv[])
{
    [SCClassUtils swizzleSelector:@selector(insertSubview:atIndex:)
                          ofClass:[UINavigationBar class]
                     withSelector:@selector(scInsertSubview:atIndex:)];
    [SCClassUtils swizzleSelector:@selector(sendSubviewToBack:)
                          ofClass:[UINavigationBar class]
                     withSelector:@selector(scSendSubviewToBack:)];
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}

