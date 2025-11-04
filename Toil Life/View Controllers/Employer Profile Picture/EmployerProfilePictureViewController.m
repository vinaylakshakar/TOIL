//
//  EmployerProfilePictureViewController.m
//  Toil Life
//
//  Created by Rajat Lakhina on 11/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import "EmployerProfilePictureViewController.h"
#import "AppDelegate.h"

@interface EmployerProfilePictureViewController ()
{
    LOTAnimationView *animationView;
}
@end

@implementation EmployerProfilePictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    animationView = [[LOTAnimationView alloc]init];
    animationView = [LOTAnimationView animationNamed:@"data"];
    animationView.contentMode = UIViewContentModeScaleAspectFit;
    double newWidth = self.view.frame.size.width;
    animationView.frame = CGRectMake(0, 0,newWidth, newWidth);
    [self.profilePicture addSubview:animationView];
    [animationView play];
    
}

#pragma mark - Btn action

- (IBAction)actionBackBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionNextBtn:(UIButton *)sender {
    
    if(_profilePicture.image == nil)
    {
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:nil
                                                                      message:@"Are you sure you don't want to upload an image?"
                                                               preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Yes"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        [self RegisterEmployer];
                                    }];
        UIAlertAction* CancelButton = [UIAlertAction actionWithTitle:@"No"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action)
                                       {
                                           
                                       }];
        
        [alert addAction:yesButton];
        [alert addAction:CancelButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        [self RegisterEmployer];
    }
}

#pragma mark- Api method

-(void)RegisterEmployer
{
    [kAppDelegate showProgressHUD];
    
    [self.employerInfoDict setObject:@"" forKey:@"categories"];
    [self.employerInfoDict setObject:@"IOS" forKey:@"devicetype"];
    
    if ([USERDEFAULTS valueForKey:deviceId]!=nil) {
        [self.employerInfoDict setObject:[USERDEFAULTS valueForKey:deviceId] forKey:@"devicetoken"];
        
    }
    else{
        [self.employerInfoDict setObject:@"TheirIsNoDeviceIdRegisterTillNow" forKey:@"devicetoken"];
        
    }
    [self.employerInfoDict setObject:[USERDEFAULTS valueForKey:AddressLatitude] forKey:AddressLatitude];
    [self.employerInfoDict setObject:[USERDEFAULTS valueForKey:AddressLongitude] forKey:AddressLongitude];
    [self.employerInfoDict setObject:@"" forKey:@"AboutMe"];
    
    NSLog(@"%@",self.employerInfoDict);
    
    [self sendImageToServer];

}

#pragma mark - uploadProfileImage


- (void) sendImageToServer {
    
    if(_profilePicture.image != nil)
    {
        [self.employerInfoDict setObject:_profilePicture.image forKey:@"image"];

    }else
    {
        [self.employerInfoDict setObject:@"" forKey:@"image"];
    }
    
    NSLog(@"Edit Employer %@",self.employerInfoDict);
    [kAppDelegate showProgressHUD];
    [[NetworkEngine sharedNetworkEngine]OnboardingMultipartWithImage:^(id object) {
        
        if ([object[@"status"] integerValue]==1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [kAppDelegate hideProgressHUD];
//                EmployerPaymentSetupViewController *EmployerPaymentSetupVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployerPaymentSetupVC"];
                 NSMutableDictionary *dic = [kAppDelegate CreateNonNullDictionary:[object valueForKey:@"data"]];
                [USERDEFAULTS setObject:dic forKey:userData];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"alreadyLoggedIn"];
                [[NSUserDefaults standardUserDefaults] synchronize];
//                [self.navigationController pushViewController:EmployerPaymentSetupVC animated:YES];
                
                EmployerTabbarViewController *toilerTabBarVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployerTabbarVC"];
                
                toilerTabBarVC.selectedIndex = 2;
                
                [self.navigationController pushViewController:toilerTabBarVC animated:YES];
                
                
            });
            
            
            
        }
        else if([[object valueForKey:@"message"] isEqualToString:@"Invalid Token!"])
        {
            
            [self CreateToken];
        }
        
    } onError:^(NSError *error) {
        NSLog(@"Error : %@",error);
    } params:self.employerInfoDict];
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

- (IBAction)actionCameraBtn:(UIButton *)sender {
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped do nothing.
        
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Take photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // take photo button tapped.
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                  message:@"Device has no camera."
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
            
            [myAlertView show];
            
        }
        else{
            [self takePhoto];
            //other action
        }
        
        
        
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Choose photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // choose photo button tapped.
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                  message:@"Device has no PhotoLibrary."
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
            
            [myAlertView show];
            
        }
        else{
            
            [self choosePhoto];
        }
        
    }]];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark – Custom Methods

-(void)takePhoto{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.delegate= self;
    
    picker.allowsEditing = YES;
    
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

-(void)choosePhoto{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.delegate= self;
    
    picker.allowsEditing = YES;
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

#pragma mark – Camera Delegate Methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    self.profilePicture.image = info[UIImagePickerControllerEditedImage];
    _profilePicture.contentMode = UIViewContentModeScaleAspectFit;
    animationView.hidden = YES;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

@end
