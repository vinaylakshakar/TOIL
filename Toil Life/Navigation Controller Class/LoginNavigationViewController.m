//
//  LoginNavigationViewController.m
//  Toil Life
//
//  Created by Rajat Lakhina on 22/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import "LoginNavigationViewController.h"

@interface LoginNavigationViewController ()

@end

@implementation LoginNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
        NetworkEngine *sharedNetwork = [NetworkEngine sharedNetworkEngine];
        sharedNetwork.isNewUser = YES;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
