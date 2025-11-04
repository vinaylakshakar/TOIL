//
//  ToilerProfilePictureViewController.m
//  Toil Life
//
//  Created by Developer on 10/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import "ToilerProfilePictureViewController.h"

@interface ToilerProfilePictureViewController ()
{
    LOTAnimationView *animationView;
}
@end

@implementation ToilerProfilePictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%@",self.toilerInfoDict);
    
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
                                        Onboarding3ViewController *onboarding3VC = [self.storyboard instantiateViewControllerWithIdentifier:@"Onboarding3VC"];
                                        onboarding3VC.toilerInfoDict = self.toilerInfoDict;
                                         onboarding3VC.toilerImage = nil;
                                        [self.navigationController pushViewController:onboarding3VC animated:YES];
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
    else{
        //UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
         Onboarding3ViewController *onboarding3VC = [self.storyboard instantiateViewControllerWithIdentifier:@"Onboarding3VC"];
        onboarding3VC.toilerInfoDict = self.toilerInfoDict;
        onboarding3VC.toilerImage = self.profilePicture;
        onboarding3VC.latitude = self.latitude;
        onboarding3VC.longitude = self.longitude;
        [self.navigationController pushViewController:onboarding3VC animated:YES];
    }
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
