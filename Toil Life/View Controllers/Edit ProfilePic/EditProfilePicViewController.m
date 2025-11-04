//
//  EditProfilePicViewController.m
//  Toil Life
//
//  Created by Rajat Lakhina on 23/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import "EditProfilePicViewController.h"

@interface EditProfilePicViewController ()
{
    LOTAnimationView *animationView;
    BOOL isImageUpdated;
}
@end

@implementation EditProfilePicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.profilePicture.image = self.profileImage;
    isImageUpdated = NO;
    if(self.profilePicture.image == nil)
    {
        animationView = [[LOTAnimationView alloc]init];
        animationView = [LOTAnimationView animationNamed:@"data"];
        animationView.contentMode = UIViewContentModeScaleAspectFit;
        double newWidth = self.view.frame.size.width;
        animationView.frame = CGRectMake(0, 0,newWidth, newWidth);
        [self.profilePicture addSubview:animationView];
        [animationView play];
    }
    
}

#pragma mark - Btn action


- (IBAction)actionNextBtn:(UIButton *)sender {
    if(_profilePicture.image == nil){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Toil.Life"
                                                                       message:@"Please select profile picture."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else{
        if (isImageUpdated==YES) {
            [self UploadProfilePic];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
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

#pragma mark - Api Method


- (void)UploadProfilePic
{
    NSLog(@"mobile no. %@",[USERDEFAULTS valueForKey:MobileNo]);
    [kAppDelegate showProgressHUD];
    
    //http://localscompass.silappdevops.com/services/update_user_image.php?user_id=1
    //http://3.214.38.142/Register.aspx
    //NSString *str=[kBaseURL stringByAppendingFormat:@"Register.aspx"];
    NSURL *str=[NSURL URLWithString:@"UploadProfilePic.aspx"];
    
    NSString *newString = [str.absoluteString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *urlString = [NSString stringWithFormat:kBaseMultipartUrl@"%@",newString];
    
    
    NSURL *siteURL = [[NSURL alloc] initWithString:urlString];
    
    // create the connection
    NSMutableURLRequest *siteRequest = [NSMutableURLRequest requestWithURL:siteURL
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:30.0];
    
    // change type to POST (default is GET)
    [siteRequest setHTTPMethod:@"POST"];
    
    // just some random text that will never occur in the body
    NSString *stringBoundary = @"0xKhTmLbOuNdArY---This_Is_ThE_BoUnDaRyy---pqo";
    
    // header value
    NSString *headerBoundary = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",
                                stringBoundary];
    
    // set header
    [siteRequest addValue:headerBoundary forHTTPHeaderField:@"Content-Type"];
    // set token
    [siteRequest addValue:[USERDEFAULTS valueForKey:Token] forHTTPHeaderField:@"Token"];
    
    //add body
    NSMutableData *postBody = [NSMutableData data];
    //    pro(@"body made");
    
    //image
            [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
            [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"%@\"\r\n",@"iphone.png"] dataUsingEncoding:NSUTF8StringEncoding]];
    
            [postBody appendData:[@"Content-Type: image/jpg\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
            NSData *imageData =UIImageJPEGRepresentation(_profilePicture.image, 0.1);
    
            [postBody appendData:imageData];
            [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //add params-
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"UserId\"\r\n\r\n%@", [[USERDEFAULTS valueForKey:userData] valueForKey:@"Id"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //for Error Remove
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"UserId\"\r\n\r\n%@", [[USERDEFAULTS valueForKey:userData] valueForKey:@"Id"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    // final boundary
    [postBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //pr(@"message data post data %@",postBody);
    
    // add body to post
    [siteRequest setHTTPBody:postBody];
    
    NSURLResponse *response;
    NSError *error;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:siteRequest
                                               returningResponse:&response
                                                           error:&error];
    
    NSString *myString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableLeaves error:nil];
    
    NSLog(@"%@",dict);
    
    
    if ([dict[@"status"] integerValue]==1) {
        
        // UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [kAppDelegate hideProgressHUD];
        [self.navigationController popViewControllerAnimated:YES];
        
        
    }
    else if([[dict valueForKey:@"message"] isEqualToString:@"Invalid Token!"])
    {
        
        [self CreateToken];
    }
    
    
}

-(void)CreateToken
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:clientSecretValue forKey:@"clientSecret"];

    
    [[NetworkEngine sharedNetworkEngine]CreateToken:^(id object)
     {
         
         if ([[object valueForKey:@"message"] isEqualToString:@"success"])
         {
             
             [USERDEFAULTS setObject:[object valueForKey:@"data"] forKey:Token];
             [self UploadProfilePic];
             
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
    isImageUpdated = YES;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
@end
