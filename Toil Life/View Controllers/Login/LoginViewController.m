//
//  LoginViewController.m
//  Toil Life
//
//  Created by Developer on 10/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import "LoginViewController.h"
#import "Utility.h"
#import <Crashlytics/Crashlytics.h>



@interface LoginViewController ()
{
    CGFloat height;
    NSString *countryCode;
}
@end

@implementation LoginViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    //CGFloat width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSString *countryIdentifier = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
    
    // Do any additional setup after loading the view.
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.barTintColor = [UIColor colorWithRed:(255/255.0) green:(102/255.0) blue:(1/255.0) alpha:1];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)];
    numberToolbar.items = @[
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            barButton];
    [numberToolbar sizeToFit];
    barButton.tintColor = [UIColor whiteColor];
    _txtFieldPhoneNumber.inputAccessoryView = numberToolbar;
    
    countryCode =[NSString stringWithFormat:@"+%@",[[Utility getCountryCodeDictionary] objectForKey:countryIdentifier]];
    self.countryCodeLabel.text = countryCode;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];    
 
}

-(void)viewWillAppear:(BOOL)animated
{
      [self updateLocation];
    AppDelegate *dele = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [dele registerForRemoteNotifications];
}

-(void)updateLocation
{
    if ([USERDEFAULTS valueForKey:AddressLatitude]==nil||[USERDEFAULTS valueForKey:AddressLongitude]==nil)
    {
        AppDelegate *ad = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [ad CurrentLocationIdentifier];
    }
 
}

-(void)doneWithNumberPad{
    [_txtFieldPhoneNumber resignFirstResponder];
}

#pragma mark - Button Action

- (IBAction)actionNextBtn:(UIButton *)sender {
    if([_txtFieldPhoneNumber.text isEqualToString:@""]){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Toil.Life"
                                                                       message:@"Please enter a valid phone number."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }
    else{
        LoginProcess *sharedManager = [LoginProcess sharedManager];
        bool phoneNumberValidate = [sharedManager validatePhone:_txtFieldPhoneNumber];
        if(phoneNumberValidate){
            
            [self GenerateOTP];

        }
        else{
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Toil.Life"
                                                                           message:@"Please enter a valid phone number."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    
}

#pragma mark- Api method

-(void)GenerateOTP
{
    //comment for build-
    if ([USERDEFAULTS valueForKey:deviceId]==nil)
    {
        countryCode = @"+91";
    }
//     countryCode = @"+91";
    
    NSString *phone = [NSString stringWithFormat:@"%@%@",countryCode,self.txtFieldPhoneNumber.text];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:phone forKey:@"phone"];
 
    if ([USERDEFAULTS valueForKey:deviceId]!=nil) {
        [dict setObject:[USERDEFAULTS valueForKey:deviceId] forKey:@"devicetoken"];
        
    }
    else{
        [dict setObject:@"TheirIsNoDeviceIdRegisterTillNow" forKey:@"devicetoken"];
        
    }
    [dict setObject:@"IOS" forKey:@"devicetype"];
    
    NSLog(@"devicetoken %@",dict);
    
    
    
    [[NetworkEngine sharedNetworkEngine]GenerateOTP:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"message"] isEqualToString:@"success"])
         {
             [kAppDelegate hideProgressHUD];
              NSLog(@"login token %@",[USERDEFAULTS valueForKey:Token]);
             //UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
             LoginOTPViewController *loginOTP = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginOTP"];
             loginOTP.otpStr = [[object valueForKey:@"data"] valueForKey:@"OTPPassword"];
             loginOTP.phoneStr = self.txtFieldPhoneNumber.text;
             loginOTP.countryCodeStr = countryCode;
             
             NSMutableDictionary *dic = [kAppDelegate CreateNonNullDictionary:[object valueForKey:@"data"]];
             [USERDEFAULTS setObject:dic forKey:userData];
//              [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"alreadyLoggedIn"];
//             [[NSUserDefaults standardUserDefaults] synchronize];
             [self.navigationController pushViewController:loginOTP animated:YES];

  
         } else if([[object valueForKey:@"message"] isEqualToString:@"Invalid Token!"])
         {
            
             [self CreateToken];
         }
         
         
         
         
     }
                                          onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
}

-(void)CreateToken
{

    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:clientSecretValue forKey:@"clientSecret"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]CreateToken:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"message"] isEqualToString:@"success"])
         {
             
             [USERDEFAULTS setObject:[object valueForKey:@"data"] forKey:Token];
             [self GenerateOTP];
             
         } else
         {
             
             UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Toil.Life"
                                                                            message:[object valueForKey:@"message"]
                                                                     preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
             [alert addAction:cancel];
             [self presentViewController:alert animated:YES completion:nil];
         }
         
         //[kAppDelegate hideProgressHUD];
         
         
     }
                                            onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
}

#pragma mark - textfield delegates
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
        return newLength <= 10;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.txtFieldPhoneNumber) {
        [theTextField resignFirstResponder];
    }
    return YES;
}

#pragma mark - hide keyboard

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //hides keyboard when another part of layout was touched
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}




- (IBAction)actionGuestAccess:(id)sender
{
    TermsandConditionsViewController *termsandConditions = [self.storyboard instantiateViewControllerWithIdentifier:@"TermsandConditionsVC"];
    [self.navigationController pushViewController:termsandConditions animated:YES];
 
}
@end
