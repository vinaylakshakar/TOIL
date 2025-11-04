

#import "BidsJobDetailsViewController.h"

@interface BidsJobDetailsViewController ()
{
    NSString *createddate;
    NSMutableArray *bidsArray,*ImagesArray;
}

@end

@implementation BidsJobDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    _imgJobImageHeight.constant = screenRect.size.width;
    
    _bidAmountView.hidden = YES;
    _blurView.hidden = YES;
    _bidAmountView.layer.borderColor = [Grey_COLOR CGColor];
    _bidAmountView.layer.borderWidth = 1.0f;
    _bidAmountView.layer.cornerRadius = 12;
    _bidAmountView.clipsToBounds =YES;
    
    // Do any additional setup after loading the view.
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    createddate = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"%@",_jobBidDetailDict);
    if(IS_iPHONE_5){
       
        mainScl.contentSize = CGSizeMake(mainScl.frame.size.width, 900);
    }
    [self setLayout];
}

-(void)setLayout
{
    self.lblTitle.text = [_jobBidDetailDict valueForKey:@"JobTitle"];
    self.jobTitle.text = [_jobBidDetailDict valueForKey:@"JobTitle"];
    self.txtViewCurrentBidDetails.text = [_jobBidDetailDict valueForKey:@"JobDescription"];
    self.lblBudgetAmount.text = [NSString stringWithFormat:@"$%@",[_jobBidDetailDict valueForKey:@"Budget"]];
    self.lblAmount.text = [NSString stringWithFormat:@"$%@",[_jobBidDetailDict valueForKey:@"CurrentBid"]];
    [self.jobImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[_jobBidDetailDict valueForKey:@"Images"] firstObject]]] placeholderImage:[UIImage imageNamed:@"pipe"] options:0 progress:nil completed:nil];
    bidsArray = [[_jobBidDetailDict valueForKey:@"Bids"] mutableCopy];
    
//    if (bidsArray.count==0) {
//        [self.noBidLable setHidden:NO];
//    }
    CGSize sizeThatFitsTextView = [self.txtViewCurrentBidDetails sizeThatFits:CGSizeMake(self.txtViewCurrentBidDetails.frame.size.width, MAXFLOAT)];
    
   // self.TextViewHeightConstraint.constant = sizeThatFitsTextView.height;
    self.descViewHeight.constant = sizeThatFitsTextView.height+60;
    
    ImagesArray = [[_jobBidDetailDict valueForKey:@"Images"] mutableCopy];
    [_topBidCollectionView reloadData];
    [_jobImagesCollectionView reloadData];
    
    if ([[_jobBidDetailDict valueForKey:@"CurrentBid"] isEqualToString:@"0"]) {
       
        [self.currentBidView setHidden:YES];
    }
    
}

#pragma mark - Button Action

- (IBAction)actionCloseBtn:(UIButton *)sender {

    _bidAmountView.hidden = YES;
    _blurView.hidden = YES;
    [self.view endEditing:YES];

}
- (IBAction)actionBidBtn:(UIButton *)sender
{
    
    if (![[USERDEFAULTS objectForKey:@"Stripe_Info"] valueForKey:@"stripe_user_id"])
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Toil.Life"
                                                                       message:@"Please add your Stripe Account to make bid."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }else
    if ([self.txtBidAmount.text isEqualToString:@""])
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Toil.Life"
                                                                       message:@"Please enter a valid bid amount."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    } else
    {
        [self BidForAJob];
    }
    
}
- (IBAction)actionMakeBid:(UIButton *)sender {
    _bidAmountView.hidden = NO;
    _blurView.hidden = NO;
    [_txtBidAmount isEditing];
    [_txtBidAmount becomeFirstResponder];
}
- (IBAction)actionBackBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- Api method

-(void)BidForAJob
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[[USERDEFAULTS valueForKey:userData] valueForKey:@"Id"] forKey:@"userid"];
    [dict setObject:[self.jobBidDetailDict valueForKey:@"Id"] forKey:@"jobid"];
    [dict setObject:self.txtBidAmount.text forKey:@"bidamount"];
    [dict setObject:createddate forKey:@"createddate"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]BidForAJob:^(id object)
     {
         //NSLog(@"%@",object);
         
         if ([[object valueForKey:@"message"] isEqualToString:@"success"])
         {
             [kAppDelegate hideProgressHUD];
             _bidAmountView.hidden = YES;
             _blurView.hidden = YES;
             [self.currentBidView setHidden:NO];
             self.lblAmount.text = [NSString stringWithFormat:@"$%@",self.txtBidAmount.text];
             [self.view endEditing:YES];

            // [self.navigationController popViewControllerAnimated:YES];
             
             
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

    [[NetworkEngine sharedNetworkEngine]CreateToken:^(id object)
     {
         
         if ([[object valueForKey:@"message"] isEqualToString:@"success"])
         {
             
             [USERDEFAULTS setObject:[object valueForKey:@"data"] forKey:Token];
             [self BidForAJob];
             
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

#pragma mark - CollectionView Dalagates and Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:     (NSInteger)section{
    if(collectionView == _topBidCollectionView){
        
        return 1;
        
    }else if(collectionView == _jobImagesCollectionView){
        
    }
         return ImagesArray.count;
   
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if(collectionView == _topBidCollectionView){
        
        return 1;
        
    }else if(collectionView == _jobImagesCollectionView){
        
        return 1;
        
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(collectionView == _topBidCollectionView){
        BidCollectionViewCell *cell = (BidCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:@"topBidCell" forIndexPath:indexPath];
        
        cell.lblName.text = [_jobBidDetailDict valueForKey:@"EmployerName"];
//        cell.lblBidPrice.text = [NSString stringWithFormat:@"$%@",[[bidsArray objectAtIndex:indexPath.row] valueForKey:@"BidAmount"]];
//        cell.lblToilerRatings.text = [NSString stringWithFormat:@"%@",[_jobBidDetailDict valueForKey:@"EmployerRating"]];
        
       int rate = [[_jobBidDetailDict valueForKey:@"EmployerRating"] intValue];
        [self addRating:cell :rate];
        
        [cell.profilePic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[_jobBidDetailDict valueForKey:@"EmployerPic"]]] placeholderImage:[UIImage imageNamed:@"Profile_Picture_Placeholder"] options:0 progress:nil completed:nil];
        cell.profilePic.layer.cornerRadius = cell.profilePic.frame.size.width / 2;
        cell.profilePic.clipsToBounds = YES;
        
        return cell;
        
    }else{
        BidCollectionViewCell *cell = (BidCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:@"JobImageCell" forIndexPath:indexPath];
        [cell.imgJobImages sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[ImagesArray objectAtIndex:indexPath.row]]] placeholderImage:[UIImage imageNamed:@"pipe"] options:0 progress:nil completed:nil];
        
        return cell;
        
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(collectionView == _jobImagesCollectionView){
    //UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    JobImagesViewController *jobImageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"JobImagesVC"];
        jobImageVC.imageIndex = indexPath.row;
        jobImageVC.jobImagesArray = ImagesArray;
    [self.navigationController pushViewController:jobImageVC animated:YES];
    }
}

-(void)addRating:(BidCollectionViewCell *)cell :(int)rating
{
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
