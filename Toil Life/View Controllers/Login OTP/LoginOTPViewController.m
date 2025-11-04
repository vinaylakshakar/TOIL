//
//  LoginOTPViewController.m
//  Toil Life
//
//  Created by Developer on 10/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import "LoginOTPViewController.h"

@interface LoginOTPViewController ()


@end

@implementation LoginOTPViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.txtFieldOTP.text = self.otpStr;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
}



#pragma mark - Button Action

- (IBAction)actionBackBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)actionNextBtn:(UIButton *)sender {
    if([self.txtFieldOTP.text isEqualToString:@""]){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Toil.Life"
                                                                       message:@"Please enter a valid phone number."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }
    else
    {
        
        [self ValidateOTP];

    }
}

#pragma mark- Api method

-(void)ValidateOTP
{
    
    
    if ([self.otpStr isEqualToString:self.txtFieldOTP.text])
    {
        NSString *phone = [NSString stringWithFormat:@"%@%@",self.countryCodeStr,self.phoneStr];
        // UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        if ([[[USERDEFAULTS valueForKey:userData] valueForKey:@"RoleName"] isEqualToString:@""])
        {
            TermsandConditionsViewController *termsandConditions = [self.storyboard instantiateViewControllerWithIdentifier:@"TermsandConditionsVC"];
            [USERDEFAULTS setObject:phone forKey:MobileNo];
            [self.navigationController pushViewController:termsandConditions animated:YES];
        }
        else
        {
            [USERDEFAULTS setObject:phone forKey:MobileNo];
            [self sendUserDashboard];
        }
        
        

    } else
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Toil.Life"
                                                                       message:@"InValid OTP."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }

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
    if (theTextField == self.txtFieldOTP) {
        [theTextField resignFirstResponder];
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
 
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}
-(void)sendUserDashboard
{
   
    if ([[[USERDEFAULTS valueForKey:userData] valueForKey:@"RoleName"] isEqualToString:@"Toiler"])
    {
        ToilerTabBarViewController *toilerTabBarVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ToilerTabbarVC"];
        
        toilerTabBarVC.selectedIndex = 2;
        
        [self.navigationController pushViewController:toilerTabBarVC animated:YES];
    } else
    {
        EmployerTabbarViewController *toilerTabBarVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployerTabbarVC"];
        
        toilerTabBarVC.selectedIndex = 2;
        
        [self.navigationController pushViewController:toilerTabBarVC animated:YES];
    }
    
}

#pragma mark- Api method

-(void)GenerateOTP
{
    NSString *phone = [NSString stringWithFormat:@"%@%@",_countryCodeStr,self.phoneStr];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:phone forKey:@"phone"];
    
    if ([USERDEFAULTS valueForKey:deviceId]!=nil) {
        [dict setObject:[USERDEFAULTS valueForKey:deviceId] forKey:@"devicetoken"];
        
    }
    else{
        [dict setObject:@"TheirIsNoDeviceIdRegisterTillNow" forKey:@"devicetoken"];
        
    }
    [dict setObject:@"IOS" forKey:@"devicetype"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]GenerateOTP:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"message"] isEqualToString:@"success"])
         {
            [kAppDelegate hideProgressHUD];
             //for testing-
            // self.txtFieldOTP.text = [[object valueForKey:@"data"] valueForKey:@"OTPPassword"];
             self.otpStr = [[object valueForKey:@"data"] valueForKey:@"OTPPassword"];
             
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

#pragma mark - hide keyboard

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //hides keyboard when another part of layout was touched
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)resendOtpAction:(id)sender {
    
    [self GenerateOTP];
}
@end
