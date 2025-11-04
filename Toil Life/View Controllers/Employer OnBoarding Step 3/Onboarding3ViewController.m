//
//  EmployerOnboarding3ViewController.m
//  Toil Life
//
//  Created by Rajat Lakhina on 11/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import "Onboarding3ViewController.h"

@interface Onboarding3ViewController ()
{
    NSMutableArray *arrKeywords;
}
@end

@implementation Onboarding3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arrKeywords = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
}

#pragma mark - Button Action

- (IBAction)actionNextBtn:(UIButton *)sender {
    
    if(_tradeBtn.selected || _farmBtn.selected || _serviceBtn.selected || _choresBtn.selected || _deliveryBtn.selected || _oddJobsBtn.selected){
    
        [self RegisterUser];
    
    }
    else{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Toil.Life"
                                                                       message:@"Please select an occupation."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

#pragma mark- Api method

-(void)RegisterUser
{
    [kAppDelegate showProgressHUD];

    [self.toilerInfoDict setObject:[self getCategoriesName] forKey:@"categories"];
    [self.toilerInfoDict setObject:@"IOS" forKey:@"devicetype"];
    
    if ([USERDEFAULTS valueForKey:deviceId]!=nil) {
        [self.toilerInfoDict setObject:[USERDEFAULTS valueForKey:deviceId] forKey:@"devicetoken"];
        
    }
    else{
        [self.toilerInfoDict setObject:@"TheirIsNoDeviceIdRegisterTillNow" forKey:@"devicetoken"];
        
    }
    [self.toilerInfoDict setObject:[USERDEFAULTS valueForKey:AddressLatitude] forKey:AddressLatitude];
    [self.toilerInfoDict setObject:[USERDEFAULTS valueForKey:AddressLongitude] forKey:AddressLongitude];
    [self.toilerInfoDict setObject:@"" forKey:@"BusinessName"];
    
    NSLog(@"%@",self.toilerInfoDict);
    
    [self sendImageToServer];
}

#pragma mark - uploadProfileImage


- (void)sendImageToServer {
    if(_toilerImage!=nil)
    {
    if(_toilerImage.image != nil)
    {
        [self.toilerInfoDict setObject:_toilerImage.image forKey:@"image"];
    }else
    {
        [self.toilerInfoDict setObject:@"" forKey:@"image"];
    }
    }else{
       [self.toilerInfoDict setObject:@"" forKey:@"image"];
    }
    NSLog(@"Edit Employer %@",self.toilerInfoDict);
    [kAppDelegate showProgressHUD];
    [[NetworkEngine sharedNetworkEngine]OnboardingMultipartWithImage:^(id object) {
        
        if ([object[@"status"] integerValue]==1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [kAppDelegate hideProgressHUD];
                ToilerPaymentSetupViewController *toilerPaymentSetupVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ToilerPaymentSetupVC"];
                 NSMutableDictionary *dic = [kAppDelegate CreateNonNullDictionary:[object valueForKey:@"data"]];
                [USERDEFAULTS setObject:dic forKey:userData];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"alreadyLoggedIn"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self.navigationController pushViewController:toilerPaymentSetupVC animated:YES];
            });
            
            
            
        }
        else if([[object valueForKey:@"message"] isEqualToString:@"Invalid Token!"])
        {
            
            [self CreateToken];
        }
        
    } onError:^(NSError *error) {
        NSLog(@"Error : %@",error);
    } params:self.toilerInfoDict];
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
             [self sendImageToServer];
             
         } else
         {
             [kAppDelegate hideProgressHUD];
             UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Toil.Life"
                                                                            message:[object valueForKey:@"message"]
                                                                     preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
             [alert addAction:cancel];
             [self presentViewController:alert animated:YES completion:nil];
         }
         
         
         
         
     }
                                            onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
}

-(NSString *)getCategoriesName
{
    NSMutableArray *categoryArray = [[NSMutableArray alloc]init];
    
    if(_tradeBtn.selected)
    {
        [categoryArray addObject:@"Trades and Construction"];
    }

    if(_farmBtn.selected)
    {
        [categoryArray addObject:@"Farm Hand"];
    }
    
    if(_serviceBtn.selected)
    {
        [categoryArray addObject:@"Service/Retail Industry"];
    }
    
    if(_choresBtn.selected)
    {
        [categoryArray addObject:@"Household Chores"];
    }
    
    if(_deliveryBtn.selected )
    {
        [categoryArray addObject:@"Delivery/Moving Person"];
    }
    if(_oddJobsBtn.selected)
    {
        [categoryArray addObject:@"Odd Jobs"];
    }
    
    NSString * categories =[categoryArray componentsJoinedByString:@","];

    return categories;
}

- (IBAction)actionBackBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)actionChores:(UIButton *)sender {
    
    if(_choresBtn.selected){
        
        _choresBtn.selected = NO;
        [arrKeywords removeObject:@"Household Chores"];
    }
    else{
        _choresBtn.selected = YES;
        [arrKeywords addObject:@"Household Chores"];
    }
    
}

- (IBAction)actionDelivery:(UIButton *)sender {
    
    if(_deliveryBtn.selected){
        
        _deliveryBtn.selected = NO;
        [arrKeywords removeObject:@"Delivery / Moving Person"];
    }
    else{
        
        _deliveryBtn.selected = YES;
        [arrKeywords addObject:@"Delivery / Moving Person"];
    }
    
}

- (IBAction)actionOddJobs:(UIButton *)sender {
    
    if( _oddJobsBtn.selected){
        _oddJobsBtn.selected = NO;
        [arrKeywords removeObject:@"Odd Jobs"];
    }
    else{
        _oddJobsBtn.selected = YES;
        [arrKeywords addObject:@"Odd Jobs"];
    }
    
}

- (IBAction)actionTrade:(id)sender {
    
    if(_tradeBtn.selected){
        _tradeBtn.selected = NO;
        [arrKeywords removeObject:@"Trades and Construction"];
        
    }
    else{
        _tradeBtn.selected = YES;
        [arrKeywords addObject:@"Trades and Construction"];
    }
    
}

- (IBAction)actionFarm:(UIButton *)sender {
    
    if(_farmBtn.selected){
        _farmBtn.selected = NO;
        [arrKeywords removeObject:@"Farm Hand"];
    }
    else{
        _farmBtn.selected = YES;
        [arrKeywords addObject:@"Farm Hand"];
    }
    
}

- (IBAction)actionService:(UIButton *)sender {
    
    if(_serviceBtn.selected){
        
        _serviceBtn.selected = NO;
        [arrKeywords removeObject:@"Service / Retail Industry"];
        
    }
    else{
        _serviceBtn.selected = YES;

        [arrKeywords addObject:@"Service / Retail Industry"];
    }
    
}


@end
