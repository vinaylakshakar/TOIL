//
//  TypeofUsersViewController.m
//  Toil Life
//
//  Created by Developer on 10/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import "TypeofUsersViewController.h"

@interface TypeofUsersViewController ()

@end

@implementation TypeofUsersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Button Action

- (IBAction)actionBackBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionToilerBtn:(UIButton *)sender {
    
    //UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if ([USERDEFAULTS valueForKey:MobileNo]!=nil) {
        ToilerPersonalInformationViewController *toilerPersonalInformationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ToilerPersonalInformationVC"];
        
        [self.navigationController pushViewController:toilerPersonalInformationVC animated:YES];
    } else
    {
        ToilerTabBarViewController *toilerTabBarVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ToilerTabbarVC"];
        
        toilerTabBarVC.selectedIndex = 2;
        
        [self.navigationController pushViewController:toilerTabBarVC animated:YES];
    }

    
}
- (IBAction)actionEmployerBtn:(UIButton *)sender {
    
    //UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if ([USERDEFAULTS valueForKey:MobileNo]!=nil)
    {
        EmployerPersonalInformationViewController *toilerPersonalInformationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployerPersonalInformationVC"];
        
        [self.navigationController pushViewController:toilerPersonalInformationVC animated:YES];
    } else
    {
        EmployerTabbarViewController *toilerTabBarVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployerTabbarVC"];
        
        toilerTabBarVC.selectedIndex = 2;
        
        [self.navigationController pushViewController:toilerTabBarVC animated:YES];
    }
    

    
    
}




@end
