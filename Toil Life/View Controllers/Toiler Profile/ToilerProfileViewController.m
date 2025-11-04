//
//  ToilerProfileViewController.m
//  Toil Life
//
//  Created by Rajat Lakhina on 16/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import "ToilerProfileViewController.h"
#import "ToilerMyJobsViewController.h"
#import "UIImageView+WebCache.h"

@interface ToilerProfileViewController ()
{
    NSArray *arrayOfStats;
    NSMutableDictionary *userdataDict;
    AppDelegate *del,*ad;
    NetworkEngine *sharedNetwork;
}
@end

@implementation ToilerProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    sharedNetwork = [NetworkEngine sharedNetworkEngine];
    ad = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //if(IS_iPHONE_5){
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        _profilePicHeight.constant = screenRect.size.width;
         arrayOfStats = [[NSMutableArray alloc]init];
    if(IS_iPHONE_5){
        mainScl.contentSize = CGSizeMake(mainScl.frame.size.width, 900);
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkStripeUpdate) name:@"updateStripe"
                                               object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    if (del.isSameTabIndex)
    {
        del.isSameTabIndex = false;
    }else
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
//          [self.navigationController popToRootViewControllerAnimated:YES];
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

- (IBAction)actionEditOccupation:(UIButton *)sender {
    
            //UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            EditOccupationViewController *EditOccupationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EditOccupationVC"];
            EditOccupationVC.occupationArray = [[NSMutableArray alloc]initWithArray:arrayOfStats];
            EditOccupationVC.profileDict = userdataDict;
            [self.navigationController pushViewController:EditOccupationVC animated:YES];
    
}
- (IBAction)actionUploadImg:(UIButton *)sender {
    
    //UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    EditProfilePicViewController *editProfilePicVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EditProfilePicVC"];
    editProfilePicVC.profileImage = self.profilePic.image;
    [self.navigationController pushViewController:editProfilePicVC animated:YES];
    
}
- (IBAction)editProfileBtn:(UIButton *)sender {
    
    //UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ToilerEditProfileDetailsViewController *toilerEditProfileDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ToilerEditProfileDetailsVC"];
    toilerEditProfileDetailsViewController.toilerProfileDict = userdataDict;
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
             arrayOfStats = [[userdataDict valueForKey:@"Categories"] componentsSeparatedByString:@","];
             [self selectRating:[userdataDict valueForKey:@"Rating"]];
             [self.categoryCollection reloadData];
             
             
         }else if([[object valueForKey:@"message"] isEqualToString:@"Invalid Token!"])
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
    
    NSDictionary *dic = [[NSDictionary alloc]init];
    NSString *str =[NSString stringWithFormat:@"https://connect.stripe.com/oauth/authorize?response_type=code&client_id=%@&scope=read_write&redirect_uri=%@",stripe_Client_id,stripe_redirect_uri];
    NSURL *URL = [NSURL URLWithString:str];
    [[UIApplication sharedApplication]openURL:URL options:dic completionHandler:^(BOOL success) {
        NSLog(@"%d",success);
        
    }];
}

-(void)checkStripeUpdate
{
    NSString *token = [[USERDEFAULTS objectForKey:@"Stripe_Info"] valueForKey:@"stripe_user_id"];
    if(token.length >= 1)
    {
        self.stripeBtn.hidden = YES;
        self.stripeImageView.hidden = NO;
    }
    else{
         self.stripeBtn.hidden = NO;
         self.stripeImageView.hidden = YES;
    }
}

#pragma mark - CollectionView Dalagates and Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:     (NSInteger)section{
    return arrayOfStats.count;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BidCollectionViewCell *cell = (BidCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:@"KeywordsCell" forIndexPath:indexPath];
    
    for (UIButton *lbl in cell.contentView.subviews)
    {
        if ([lbl isKindOfClass:[UIButton class]])
        {
            [lbl removeFromSuperview];
        }
    }
    
    UIButton* btntitle = [UIButton buttonWithType:UIButtonTypeSystem];
    
    
    [btntitle setFrame:CGRectMake(0, 0, cell.bounds.size.width-15, 30)];
    
    [btntitle.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:13]];
    
    [btntitle setTitle:(NSString *)[arrayOfStats objectAtIndex:indexPath.item] forState:UIControlStateNormal] ;
    
    btntitle.backgroundColor = ORANGE_COLOR;
    
    [btntitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    btntitle.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    btntitle.tag = indexPath.row;
    
    btntitle.layer.cornerRadius = 5; // this value vary as per your desire
    btntitle.clipsToBounds = YES;
    
    [cell.contentView addSubview:btntitle];
    
    // [cell layoutIfNeeded];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CGSize size = CGSizeMake([(NSString *)[arrayOfStats objectAtIndex:indexPath.item] length]*10, CGFLOAT_MAX);
    
    size.height= 30;
    
    return size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}


- (IBAction)jobHistoryAction:(UIButton *)sender {
    
    ToilerMyJobsViewController * toilerHistory = [self.storyboard instantiateViewControllerWithIdentifier:@"ToilerMyJobsVC"];
    toilerHistory.isfromToilerProfile = YES;
    [self.navigationController pushViewController:toilerHistory animated:YES];
}
@end
