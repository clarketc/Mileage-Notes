/*
 * Copyright (c) 2010-2010 Sebastian Celis
 * All rights reserved.
 */

#import "SCAppUtils.h"

@implementation SCAppUtils

+ (void)customizeNavigationController:(UINavigationController *)navController
{
    

    UINavigationBar *navBar = [navController navigationBar];
    //[navBar setTintColor:kSCNavigationBarTintColor];

    
    if ([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [navBar setBackgroundImage:[UIImage imageNamed:@"toolbar.png"] forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        UIImageView *imageView = (UIImageView *)[navBar viewWithTag:kSCNavigationBarBackgroundImageTag];
        if (imageView == nil)
        {
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toolbar.png"]];
            [imageView setTag:kSCNavigationBarBackgroundImageTag];
            [navBar insertSubview:imageView atIndex:0];
        }
    }
}

+ (void)customizeNavigationBar:(UINavigationBar *)navBar{
    
    if ([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [navBar setBackgroundImage:[UIImage imageNamed:@"toolbar.png"] forBarMetrics:UIBarMetricsDefault];
        NSLog(@"HI");
    }
    else
    {
        UIImageView *imageView = (UIImageView *)[navBar viewWithTag:kSCNavigationBarBackgroundImageTag];
        if (imageView == nil)
        {
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toolbar.png"]];
            [imageView setTag:kSCNavigationBarBackgroundImageTag];
            [navBar insertSubview:imageView atIndex:0];
        }
    }

}

@end
