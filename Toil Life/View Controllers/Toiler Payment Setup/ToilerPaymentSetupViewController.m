//
//  ToilerPaymentSetupViewController.m
//  Toil Life
//
//  Created by Developer on 10/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import "ToilerPaymentSetupViewController.h"

@interface ToilerPaymentSetupViewController ()

@end

@implementation ToilerPaymentSetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkStripeUpdate) name:@"updateStripe"
                                               object:nil];
    // Do any additional setup after loading the view.
}

-(void)checkStripeUpdate
{
    ToilerCompleteViewController *loginOTP = [self.storyboard instantiateViewControllerWithIdentifier:@"ToilerCompleteVC"];
    
    [self.navigationController pushViewController:loginOTP animated:YES];
}

#pragma mark - Btn action

- (IBAction)actionBackBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionSetupStripe:(UIButton *)sender {
    
    NSDictionary *dic = [[NSDictionary alloc]init];
    NSString *str =[NSString stringWithFormat:@"https://connect.stripe.com/oauth/authorize?response_type=code&client_id=%@&scope=read_write&redirect_uri=%@",stripe_Client_id,stripe_redirect_uri];
    NSURL *URL = [NSURL URLWithString:str];
    [[UIApplication sharedApplication]openURL:URL options:dic completionHandler:^(BOOL success) {
        NSLog(@"%d",success);
        
    }];
}

- (IBAction)actionSkipBtn:(UIButton *)sender {
    
    //UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    ToilerCompleteViewController *loginOTP = [self.storyboard instantiateViewControllerWithIdentifier:@"ToilerCompleteVC"];
//
//    [self.navigationController pushViewController:loginOTP animated:YES];
    ToilerTabBarViewController *toilerTabBarVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ToilerTabbarVC"];
    
    toilerTabBarVC.selectedIndex = 2;
    
    [self.navigationController pushViewController:toilerTabBarVC animated:YES];
}

@end
