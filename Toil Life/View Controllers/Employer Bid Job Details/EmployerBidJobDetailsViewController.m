

#import "EmployerBidJobDetailsViewController.h"

@interface EmployerBidJobDetailsViewController ()
{
    NSMutableArray *bidsArray,*ImagesArray;
}

@end

@implementation EmployerBidJobDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@",self.bidJobDetailDict);
    if(IS_iPHONE_5){
        
        mainScl.contentSize = CGSizeMake(mainScl.frame.size.width, 700);
    }
    // Do any additional setup after loading the view.
    [self setLayout];
}

-(void)setLayout
{
        self.lblTitle.text = [self.bidJobDetailDict valueForKey:@"JobTitle"];
        self.jobTitle.text = [self.bidJobDetailDict valueForKey:@"JobTitle"];
        self.txtViewCurrentBidDetails.text = [self.bidJobDetailDict valueForKey:@"JobDescription"];
        self.lblBudgetAmount.text = [NSString stringWithFormat:@"$%@",[self.bidJobDetailDict valueForKey:@"Budget"]];
        self.lblAmount.text = [NSString stringWithFormat:@"$%@",[self.bidJobDetailDict valueForKey:@"CurrentBid"]];

        bidsArray = [[self.bidJobDetailDict valueForKey:@"Bids"] mutableCopy];
    
    CGSize sizeThatFitsTextView = [self.txtViewCurrentBidDetails sizeThatFits:CGSizeMake(self.txtViewCurrentBidDetails.frame.size.width, MAXFLOAT)];
    
    // self.TextViewHeightConstraint.constant = sizeThatFitsTextView.height;
    self.descViewHeight.constant = sizeThatFitsTextView.height+60;
    
    if(bidsArray.count>=1)
    {
        [editBtn setHidden:YES];
        [deleteBtn setHidden:YES];
        
    }
    else{
        [editBtn setHidden:false];
        [deleteBtn setHidden:false];
        [self.noBidLable setHidden:NO];
        [viewAllBidBtn setHidden:YES];
    }
        ImagesArray = [[self.bidJobDetailDict valueForKey:@"Images"] mutableCopy];
        [_topBidCollectionView reloadData];
        [_jobImagesCollectionView reloadData];
}

#pragma mark - Api method

-(void)DeleteJob
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[self.bidJobDetailDict valueForKey:@"Id"] forKey:@"jobid"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]DeleteJob:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"message"] isEqualToString:@"success"])
         {
             [kAppDelegate hideProgressHUD];
             [self.navigationController popViewControllerAnimated:YES];
             
             
         }else if ([[object valueForKey:@"message"] isEqualToString:@"Job can not be deleted!"])
         {
             [kAppDelegate hideProgressHUD];
             UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Toil.Life"
                                                                            message:@"Job cannot be deleted as toilers have already bid on it."
                                                                     preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
             [alert addAction:cancel];
             [self presentViewController:alert animated:YES completion:nil];
             //[self.navigationController popViewControllerAnimated:YES];
             
             
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
             [self DeleteJob];
             
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
- (IBAction)actionViewAll:(UIButton *)sender {
    
  //  UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EmployerBidListViewController *EmployerBidListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployerBidListVC"];
    EmployerBidListVC.bidlistArray = bidsArray;
    EmployerBidListVC.jobTitleStr = [self.bidJobDetailDict valueForKey:@"JobTitle"];
    [self.navigationController pushViewController:EmployerBidListVC animated:YES];
}

#pragma mark - CollectionView Dalagates and Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:     (NSInteger)section{
    if(collectionView == _topBidCollectionView){
        
        return bidsArray.count;;
        
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
        
       // cell.lblName.text = [self getShortName:[[bidsArray objectAtIndex:indexPath.row] valueForKey:@"Name"]];
        cell.lblName.text = [[bidsArray objectAtIndex:indexPath.row] valueForKey:@"Name"];
        cell.lblBidPrice.text = [NSString stringWithFormat:@"$%@",[[bidsArray objectAtIndex:indexPath.row] valueForKey:@"BidAmount"]];
        cell.lblToilerRatings.text = [NSString stringWithFormat:@"%@",[[bidsArray objectAtIndex:indexPath.row] valueForKey:@"Rating"]];
        
        [cell.profilePic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[bidsArray objectAtIndex:indexPath.row] valueForKey:@"ProfilePic"]]] placeholderImage:[UIImage imageNamed:@"Profile_Picture_Placeholder"] options:0 progress:nil completed:nil];
        
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
    }else
    {
        ToilerDetailsViewController *toilerDetailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ToilerDetailsVC"];
        toilerDetailsVC.toilerDetailDict = [bidsArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:toilerDetailsVC animated:YES];
    }
}

- (IBAction)editJobAction:(id)sender {
    
    CreateJobViewController *CreateJobVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateJobVC"];
    CreateJobVC.isForEditJob = YES;
    CreateJobVC.editJobDict = self.bidJobDetailDict;
    [self.navigationController pushViewController:CreateJobVC animated:YES];
}

- (IBAction)deleteJobAction:(id)sender {
    
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:nil
                                                                  message:@"Are you sure to want to delete job?"
                                                           preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Yes"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action)
    {
        [self DeleteJob];
    }];
    
    UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"No"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action)
    {
     
    }];
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(NSString *)getShortName:(NSString *)name

{   NSString *firstname,*lastname;
    
    NSArray *items = [name componentsSeparatedByString:@" "];
    
    if(items.count>=2)
        
    {
        
        firstname=[items objectAtIndex:0];   //shows Description
        
        lastname=[items objectAtIndex:1];
        
        lastname=[lastname substringToIndex:1];
        
        lastname = [NSString stringWithFormat:@"%@ %@.",firstname,lastname];
        
    }
    
    else{
        
        firstname=[items objectAtIndex:0];
        
        lastname = firstname;
        
    }
    
    return lastname;
    
}

@end
