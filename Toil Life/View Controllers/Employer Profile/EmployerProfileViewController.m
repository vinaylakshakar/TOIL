//
//  EmployerProfileViewController.m
//  Toil Life
//
//  Created by Rajat Lakhina on 16/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import "EmployerProfileViewController.h"
#import "EmployerMyJobsViewController.h"
#import "UIImageView+WebCache.h"

@interface EmployerProfileViewController ()
{
    NSMutableDictionary *userdataDict;
    AppDelegate *del,*ad;
    NetworkEngine *sharedNetwork;
}

@end

@implementation EmployerProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sharedNetwork = [NetworkEngine sharedNetworkEngine];
    ad = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //if(IS_iPHONE_5){
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        _profilePicHeight.constant = screenRect.size.width;
    if(IS_iPHONE_5){
        mainScl.contentSize = CGSizeMake(mainScl.frame.size.width, 750);
    }
    // Do any additional setup after loading the view.

}

-(void)viewWillAppear:(BOOL)animated
{
    if (del.isSameTabIndex)
    {
        del.isSameTabIndex = false;
    }
    else
    {
        [self GetProfile];
        
    }
     [self checkStripeUpdate];
}


#pragma mark - Button action

- (IBAction)actionLogoutBtn:(UIButton *)sender {
    
    if(sharedNetwork.isNewUser){
        //UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        LoginNavigationViewController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNavigationVC"];
//
//        ad.window.rootViewController = navigationController;
//        [self.navigationController popToRootViewControllerAnimated:YES];
        [self LogoutUser];
        
        
    }
    else{
        //UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        LoginNavigationViewController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNavigationVC"];
//
//        ad.window.rootViewController = navigationController;
//        [self.navigationController popToRootViewControllerAnimated:YES];
        
         [self LogoutUser];
    }
    //[self resetDefaults];
}

-(void)LogoutUser
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[[USERDEFAULTS valueForKey:userData] valueForKey:@"Id"] forKey:@"userid"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]Logout:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"message"] isEqualToString:@"success"])
         {
             [kAppDelegate hideProgressHUD];
             LoginNavigationViewController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNavigationVC"];
             
             ad.window.rootViewController = navigationController;
             [self.navigationController popToRootViewControllerAnimated:YES];
             [self resetDefaults];
             
         } else if([[object valueForKey:@"message"] isEqualToString:@"Invalid Token!"])
         {
             
             [self CreateToken:@"LogoutUser"];
         }
         
         
         
         
     }
                                       onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
}

- (void)resetDefaults {
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
}


- (IBAction)actionUploadImg:(UIButton *)sender {
    //UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EditProfilePicViewController *editProfilePicVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EditProfilePicVC"];
    editProfilePicVC.profileImage = self.profilePic.image;
    [self.navigationController pushViewController:editProfilePicVC animated:YES];
}
- (IBAction)editProfileBtn:(UIButton *)sender {
    //UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EditProfileDetailsViewController *toilerEditProfileDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployerEditProfileDetailsVC"];
    toilerEditProfileDetailsViewController.employerDict = userdataDict;
    [self.navigationController pushViewController:toilerEditProfileDetailsViewController animated:YES];
    
    
}
-(void)selectRating:(NSString *)rating
{
    if ([rating integerValue]>=1) {
        [self.imgRating1 setImage:[UIImage imageNamed:@"Star_Selected"]];
    }
    if (([rating integerValue]>=2)) {
        [self.imgRating2 setImage:[UIImage imageNamed:@"Star_Selected"]];
    }
    if (([rating integerValue]>=3)) {
        [self.imgRating3 setImage:[UIImage imageNamed:@"Star_Selected"]];
    }
    if (([rating integerValue]>=4)) {
        [self.imgRating4 setImage:[UIImage imageNamed:@"Star_Selected"]];
    }
    if (([rating integerValue]>=5)) {
        [self.imgRating5 setImage:[UIImage imageNamed:@"Star_Selected"]];
    }
}

-(void)checkStripeUpdate
{
    NSString *token = [[USERDEFAULTS objectForKey:@"Stripe_Info"] valueForKey:@"stripe_user_id"];
    if(token.length >= 1)
    {
        self.stripeeditBtn.hidden = YES;
        self.stripeImageView.hidden = NO;
    }
    else{
        self.stripeeditBtn.hidden = YES;
        self.stripeImageView.hidden = YES;
    }
}

#pragma mark- Api method

-(void)GetProfile
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[[USERDEFAULTS valueForKey:userData] valueForKey:@"Id"] forKey:@"userid"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]GetProfile:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"message"] isEqualToString:@"success"])
         {
            [kAppDelegate hideProgressHUD];
             userdataDict =[object valueForKey:@"data"];
          self.lblName.text = [NSString stringWithFormat:@"%@ %@",[userdataDict valueForKey:@"FirstName"],[userdataDict valueForKey:@"LastName"]];
             self.lblEmail.text = [userdataDict valueForKey:@"Email"];
             self.lblAddress.text = [userdataDict valueForKey:@"UserAddress"];
             self.lblDistance.text = [NSString stringWithFormat:@"%@ KM",[userdataDict valueForKey:@"SearchJobRadius"]];
             [self.profilePic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[userdataDict valueForKey:@"ProfilePic"]]] placeholderImage:[UIImage imageNamed:@"Profile_Picture_Placeholder"] options:0 progress:nil completed:nil];
             [self selectRating:[userdataDict valueForKey:@"Rating"]];
             
         } else if([[object valueForKey:@"message"] isEqualToString:@"Invalid Token!"])
         {
             
             [self CreateToken:@"GetProfile"];
         }
         
      
         
         
     }
                                            onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
}

-(void)CreateToken:(NSString*)type
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
             
             if ([type isEqualToString:@"GetProfile"])
             {
                 [self GetProfile];
             } else {
                 [self LogoutUser];
             }
             
             
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

- (IBAction)actionLinkFacebookBtn:(UIButton *)sender {
}
- (IBAction)actionLinkTwitterBtn:(id)sender {
}
- (IBAction)actionLinkLinkedinBtn:(UIButton *)sender {
}
- (IBAction)actionSetupStripe:(UIButton *)sender {
}


- (IBAction)employerJobHistory:(UIButton *)sender {
    
    EmployerMyJobsViewController *EmployerjobHistory = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployerMyJobsVC"];
    EmployerjobHistory.isfromEmployerProfile = YES;
    [self.navigationController pushViewController:EmployerjobHistory animated:YES];
}
@end
