//
//  LoginViewController.h
//  Toil Life
//
//  Created by Developer on 10/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtFieldPhoneNumber;
@property (strong, nonatomic) IBOutlet UILabel *countryCodeLabel;
- (IBAction)actionGuestAccess:(id)sender;


@end
