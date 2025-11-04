//
//  EmployerTabbarViewController.m
//  Toil Life
//
//  Created by Rajat Lakhina on 20/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import "EmployerTabbarViewController.h"
#import "EmployerDashboardViewController.h"

@interface EmployerTabbarViewController ()
{
    AppDelegate *del;
}

@end

@implementation EmployerTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isEmployer"];
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
                //[self showAlert:@"You need to register before you can make and view bids."];
                 message = @"You need to register before you can make and view bids.";
                [alertDict setObject:message forKey:@"message"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowCustomAlertView" object:self userInfo:alertDict];
                break;
                
            case 1:
                //[self showAlert:@"You need to register before you can access chat."];
                message = @"You need to register before you can access chat.";
                [alertDict setObject:message forKey:@"message"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowCustomAlertView" object:self userInfo:alertDict];
                break;
            case 2:
                
                break;
            case 3:
                //[self showAlert:@"You need to register before you can manage and create jobs."];
                message = @"You need to register before you can manage and create jobs.";
                [alertDict setObject:message forKey:@"message"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowCustomAlertView" object:self userInfo:alertDict];
                break;
            case 4:
                //[self showAlert:@"You need to register before you can view and manage your profile."];
                message = @"You need to register before you can view and manage your profile.";
                [alertDict setObject:message forKey:@"message"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowCustomAlertView" object:self userInfo:alertDict];
                break;
            default:
                break;
        }
        
        
    }

}


@end
