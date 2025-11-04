//
//  ToilerDetailsViewController.m
//  Toil Life
//
//  Created by Rajat Lakhina on 19/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import "ToilerDetailsViewController.h"
@interface ToilerDetailsViewController ()
{
    NSArray *arrayOfStats;
    NSMutableArray *arrWork;
    NSMutableDictionary *userdataDict;
}
@end

@implementation ToilerDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(IS_iPHONE_5){
       
        sclView.contentSize = CGSizeMake(sclView.frame.size.width, 850);
    }
    CGRect screenRect = [[UIScreen mainScreen] bounds];
            _profilePicHeight.constant = screenRect.size.width;

    arrWork = [[NSMutableArray alloc]init];

    // Do any additional setup after loading the view.
    [_commentTableView reloadData];
    [self setLayout];
}
-(void)setLayout
{
      NSLog(@"toilerDetail %@", self.toilerDetailDict);
    
    if (!_isFromDashboard==YES) {
        [self.btnSendInvite setImage:[UIImage imageNamed:@"Hire_Now"] forState:UIControlStateNormal];
        self.lblAmount.text = [NSString stringWithFormat:@"$%@",[self.toilerDetailDict valueForKey:@"BidAmount"]];
        userdataDict =[self.toilerDetailDict valueForKey:@"ToilerProfile"];
    }else
    {
        [self.lblAmount setHidden:YES];
        userdataDict = self.toilerDetailDict;
    }

    self.lblName.text = [NSString stringWithFormat:@"%@ %@",[userdataDict valueForKey:@"FirstName"],[userdataDict valueForKey:@"LastName"]];
    self.lblAddress.text = [userdataDict valueForKey:@"AboutMe"];
    self.lblDistance.text = [NSString stringWithFormat:@"%@ KM",[userdataDict valueForKey:@"SearchJobRadius"]];
    [self.profilePic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[userdataDict valueForKey:@"ProfilePic"]]] placeholderImage:[UIImage imageNamed:@"Profile_Picture_Placeholder"] options:0 progress:nil completed:nil];
    arrayOfStats = [[userdataDict valueForKey:@"Categories"] componentsSeparatedByString:@","];
    arrWork = [[userdataDict valueForKey:@"ToilerRating"] mutableCopy];
    [self selectRating:[userdataDict valueForKey:@"Rating"]];
    [self.keywordsCollectionView reloadData];
    [self hideUnhideLable];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self hideUnhideLable];
}

-(void)hideUnhideLable
{
    if (arrWork.count>0) {
        [self.noCommentLable setHidden:YES];
        _commentTableView.hidden = false;
        [_commentTableView sizeToFit];
        dispatch_async(dispatch_get_main_queue(), ^{
            //This code will run in the main thread:
            CGRect frame = _commentTableView.frame;
            frame.size.height = _commentTableView.contentSize.height;
            _commentTableView.frame = frame;
            
            sclView.contentSize = CGSizeMake(sclView.frame.size.width, 2*(_profilePic.frame.size.height)+frame.size.height);
        });
        
    } else {
        _commentTableView.hidden = true;
        [self.noCommentLable setHidden:NO];
        //CGRect tableframe = self.tableContainerView.frame;
//        self.tableContainerView.translatesAutoresizingMaskIntoConstraints = YES;
//        self.commentTableView.translatesAutoresizingMaskIntoConstraints = YES;;
       // self.tableContainerView.frame = CGRectMake( tableframe.origin.x, tableframe.origin.y, tableframe.size.width, tableframe.size.height);
        //sclView.contentSize = CGSizeMake(sclView.frame.size.width, 1900);
    }
    
}

-(void)selectRating:(NSString *)rating
{
    if ([rating integerValue]>=1) {
        [self.ratingFirstStar setImage:[UIImage imageNamed:@"Star_Selected"]];
    }
    if (([rating integerValue]>=2)) {
        [self.rating2ndStar setImage:[UIImage imageNamed:@"Star_Selected"]];
    }
    if (([rating integerValue]>=3)) {
        [self.rating3Star setImage:[UIImage imageNamed:@"Star_Selected"]];
    }
    if (([rating integerValue]>=4)) {
        [self.rating4star setImage:[UIImage imageNamed:@"Star_Selected"]];
    }
    if (([rating integerValue]>=5)) {
        [self.rating5Star setImage:[UIImage imageNamed:@"Star_Selected"]];
    }
}

#pragma mark- Api method

-(void)HireForJob
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[self.toilerDetailDict valueForKey:@"BidId"] forKey:@"BidId"];
     [dict setObject:stripeToken forKey:@"stripetoken"];
     [dict setObject:stripeCustomerID forKey:@"customerid"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]HireForJob:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"message"] isEqualToString:@"success"])
         {
             [kAppDelegate hideProgressHUD];

             UIAlertController * alert=[UIAlertController alertControllerWithTitle:nil
                                                                           message:[object valueForKey:@"data"]
                                                                    preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action)
             {
                 [self.navigationController popToRootViewControllerAnimated:YES];
             }];
             
             [alert addAction:yesButton];
             [self presentViewController:alert animated:YES completion:nil];
             
             
         }else if([[object valueForKey:@"message"] isEqualToString:@"Invalid Token!"])
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
             [self HireForJob];
             
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


#pragma mark - Button Action

- (IBAction)actionBackBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)PaymentCompleted:(NSTimer *)token
{
     NSMutableDictionary *dic = (NSMutableDictionary *)token.userInfo;
    stripeToken = [dic objectForKey:@"TokenID"];
    stripeCustomerID = [dic objectForKey:@"CustomerID"];
        if (!_isFromDashboard==YES)
        {
            NSLog(@"not from dashboard");
            [self HireForJob];
    
        }else
        {
         
        }
}

- (IBAction)actionSendInvite:(id)sender {
    
    if(_isFromDashboard)
    {
        SendInviteViewController *sendInviteVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SendInviteVC"];
        sendInviteVC.toilerID = [self.toilerDetailDict valueForKey:@"Id"];
        [self.navigationController pushViewController:sendInviteVC animated:YES];
    }
    else
    {
        
    
    [self.tabBarController.tabBar setHidden:YES];
    CreditCardViewController *sendInviteVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CreditCardViewController"];
    sendInviteVC.cardDelegate = self;
         sendInviteVC.fromCreateJob = false;
    [self.navigationController pushViewController:sendInviteVC animated:YES];
    }

}

- (IBAction)actionLinkFacebook:(UIButton *)sender {
}

- (IBAction)actionLinkLinkedIn:(id)sender {
}

- (IBAction)actionLinkTwitter:(UIButton *)sender {
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
    
    
    
    UIButton* btntitle = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
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

#pragma mark - Table View Data Source and Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrWork.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"ToilerCellCommentCell";
    DashboardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSMutableDictionary *dic = [arrWork objectAtIndex:indexPath.row];
    cell.lblComment.text = [dic valueForKey:@"RateComment"];
    
    NSDate *CreatedDate = [NSDate dateWithTimeIntervalSince1970:([[dic valueForKey:@"CreatedDate"] doubleValue] / 1000.0)];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMMM YYYY"];
    NSString *dateString = [dateFormatter stringFromDate:CreatedDate];
    
    cell.lblDate.text = dateString;
    int rate = [[dic valueForKey:@"RateCount"] intValue];
    
    [self addRating:cell :rate];
    
    
    return cell;
}

#pragma mark - Rating Image Alloc

-(void)addRating:(DashboardTableViewCell *)cell :(int)rating
{
    
    cell.firstStar.image = [UIImage imageNamed:@"Star_Grey" ];
    cell.secondStar.image = [UIImage imageNamed:@"Star_Grey" ];
    cell.thirdStar.image = [UIImage imageNamed:@"Star_Grey" ];
    cell.fourStar.image = [UIImage imageNamed:@"Star_Grey" ];
    cell.fifthStar.image = [UIImage imageNamed:@"Star_Grey" ];
    
    switch (rating) {
        case 1:
            cell.firstStar.image = [UIImage imageNamed:@"Star_Selected" ];
            cell.secondStar.image = [UIImage imageNamed:@"Star_Grey" ];
            cell.thirdStar.image = [UIImage imageNamed:@"Star_Grey" ];
            cell.fourStar.image = [UIImage imageNamed:@"Star_Grey" ];
            cell.fifthStar.image = [UIImage imageNamed:@"Star_Grey" ];
            break;
        case 2:
            cell.firstStar.image = [UIImage imageNamed:@"Star_Selected" ];
            cell.secondStar.image = [UIImage imageNamed:@"Star_Selected" ];
            cell.thirdStar.image = [UIImage imageNamed:@"Star_Grey" ];
            cell.fourStar.image = [UIImage imageNamed:@"Star_Grey" ];
            cell.fifthStar.image = [UIImage imageNamed:@"Star_Grey" ];
            break;
        case 3:
            cell.firstStar.image = [UIImage imageNamed:@"Star_Selected" ];
            cell.secondStar.image = [UIImage imageNamed:@"Star_Selected" ];
            cell.thirdStar.image = [UIImage imageNamed:@"Star_Selected" ];
            cell.fourStar.image = [UIImage imageNamed:@"Star_Grey" ];
            cell.fifthStar.image = [UIImage imageNamed:@"Star_Grey" ];
            break;
        case 4:
            cell.firstStar.image = [UIImage imageNamed:@"Star_Selected" ];
            cell.secondStar.image = [UIImage imageNamed:@"Star_Selected" ];
            cell.thirdStar.image = [UIImage imageNamed:@"Star_Selected" ];
            cell.fourStar.image = [UIImage imageNamed:@"Star_Selected" ];
            cell.fifthStar.image = [UIImage imageNamed:@"Star_Grey" ];
            break;
        case 5:
            cell.firstStar.image = [UIImage imageNamed:@"Star_Selected" ];
            cell.secondStar.image = [UIImage imageNamed:@"Star_Selected" ];
            cell.thirdStar.image = [UIImage imageNamed:@"Star_Selected" ];
            cell.fourStar.image = [UIImage imageNamed:@"Star_Selected" ];
            cell.fifthStar.image = [UIImage imageNamed:@"Star_Selected" ];
            break;
            
        default:
            break;
    }
}



@end
