//
//  TermsandConditionsViewController.m
//  Toil Life
//
//  Created by Developer on 10/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import "TermsandConditionsViewController.h"

@interface TermsandConditionsViewController ()

@end

@implementation TermsandConditionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Button Action

- (IBAction)actionBackBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionAcceptBtn:(UIButton *)sender {
    
    //UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if ([self.checkBoxBtn isSelected])
    {
        ToilerPersonalInformationViewController *typeofUsersVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TypeofUsersVC"];
        
        [self.navigationController pushViewController:typeofUsersVC animated:YES];
    } else {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Toil.Life"
                                                                       message:@"Please accept terms & conditions."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
   
}
- (IBAction)checkBoxAction:(id)sender {
    
    if (![sender isSelected])
    {
        [sender setSelected:YES];
    } else {
        [sender setSelected:NO];
    }
    
}
@end
