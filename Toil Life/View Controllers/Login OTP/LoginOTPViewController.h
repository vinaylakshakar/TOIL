//
//  LoginOTPViewController.h
//  Toil Life
//
//  Created by Developer on 10/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginOTPViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *txtFieldOTP;
@property (strong, nonatomic) NSString *otpStr;
@property (strong, nonatomic) NSString *phoneStr;
@property (strong, nonatomic) NSString *countryCodeStr;
- (IBAction)resendOtpAction:(id)sender;


@end
