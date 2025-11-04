//
//  EmployerPaymentSetupViewController.m
//  Toil Life
//
//  Created by Rajat Lakhina on 12/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import "EmployerPaymentSetupViewController.h"

@interface EmployerPaymentSetupViewController ()

@end

@implementation EmployerPaymentSetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Button action

- (IBAction)actionBackBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)actionSetupStripe:(UIButton *)sender {
}

- (IBAction)actionSkipBtn:(UIButton *)sender {
    
    //UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EmployerCompleteViewController *loginOTP = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployerCompleteVC"];
    
    [self.navigationController pushViewController:loginOTP animated:YES];
    
}

@end
