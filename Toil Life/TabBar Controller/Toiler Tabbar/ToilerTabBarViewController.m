//
//  ToilerTabBarViewController.m
//  Toil Life
//
//  Created by Rajat Lakhina on 14/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import "ToilerTabBarViewController.h"

@interface ToilerTabBarViewController ()
{
    AppDelegate *del;
}

@end

@implementation ToilerTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"isEmployer"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"alreadyLoggedIn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.delegate= self;
}

- (void)tabBarController:(UITabBarController *)theTabBarController didSelectViewController:(UIViewController *)viewController {
    NSUInteger indexOfTab = [theTabBarController.viewControllers indexOfObject:viewController];
    NSLog(@"Tab index = %u (%u)", (int)indexOfTab);
    
    if ([[USERDEFAULTS valueForKey:userData] valueForKey:@"Id"]==nil)
    {
        theTabBarController.selectedIndex =2;
        del.isSameTabIndex =YES;
        NSMutableDictionary *alertDict =[[NSMutableDictionary alloc]init];
        NSString * message;
        
        switch (indexOfTab)
        {
            case 0:
                //[self showAlert:@"You need to register before you can view job invites."];
                message = @"You need to register before you can view job invites.";
                [alertDict setObject:message forKey:@"message"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowToilerAlertView" object:self userInfo:alertDict];
                break;
                
            case 1:
                //[self showAlert:@"You need to register before you can access chat."];
                message = @"You need to register before you can access chat";
                [alertDict setObject:message forKey:@"message"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowToilerAlertView" object:self userInfo:alertDict];
                break;
            case 2:
                
                break;
            case 3:
                //[self showAlert:@"You need to register before you can manage and view your jobs."];
                message = @"You need to register before you can manage and view your jobs.";
                [alertDict setObject:message forKey:@"message"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowToilerAlertView" object:self userInfo:alertDict];
                break;
            case 4:
                //[self showAlert:@"You need to register before you can view and manage your profile."];
                message = @"You need to register before you can view and manage your profile.";
                [alertDict setObject:message forKey:@"message"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowToilerAlertView" object:self userInfo:alertDict];
                break;
            default:
                break;
        }
        
        
    }
    
}


@end
