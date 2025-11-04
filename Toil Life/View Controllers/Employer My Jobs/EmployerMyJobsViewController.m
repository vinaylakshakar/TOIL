

#import "EmployerMyJobsViewController.h"

@interface EmployerMyJobsViewController ()
{
    NSMutableArray *arrWork;
    NSMutableArray *arrJobData;
    BOOL isSearching;
    NSArray *filterdArray;
    NetworkEngine *sharedNetwork;
    AppDelegate *del;
}
@end

@implementation EmployerMyJobsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Init Begin
      del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    sharedNetwork = [NetworkEngine sharedNetworkEngine];
    arrJobData = [[NSMutableArray alloc] init];
    filterdArray = [[NSArray alloc]init];

    
    arrWork = [[NSMutableArray alloc]init];
    [self setSearchBarFont];
}

-(void)setSearchBarFont
{
    if(IS_iPHONE_5)
    {
        for (UIView *view in [[_searchBar.subviews lastObject] subviews]) {
            if ([view isKindOfClass:[UITextField class]]) {
                [(UITextField *)view setFont:[UIFont fontWithName:@"OpenSans" size:15]];
            }
        }
    }
    else if (IS_STANDARD_IPHONE_6)
    {
        for (UIView *view in [[_searchBar.subviews lastObject] subviews]) {
            if ([view isKindOfClass:[UITextField class]]) {
                [(UITextField *)view setFont:[UIFont fontWithName:@"OpenSans" size:16]];
            }
        }
    }
    else {
        for (UIView *view in [[_searchBar.subviews lastObject] subviews]) {
            if ([view isKindOfClass:[UITextField class]]) {
                [(UITextField *)view setFont:[UIFont fontWithName:@"OpenSans" size:18]];
            }
        }
    }
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    if (_isfromEmployerProfile==YES)
       {
           self.navigationTitle.text = @"Job History";
           if(IS_iPHONE_5){
               self.selectionView.frame = CGRectMake(self.selectionView.frame.origin.x, self.selectionView.frame.origin.y, self.selectionView.frame.size.width, 0);
           }else
           {
               self.selectionViewHeight.constant = 0;
           }
           
           _completedBtn.selected = YES;
           [self GetEmployerCompletedJobs];
       }else{
           
           [self.selectionView  setHidden:NO];
           if (del.isSameTabIndex)
             {
                 del.isSameTabIndex = false;
             }
             else
             {
                 [self getjobs];
             }
             
       }
  
}

-(void)getjobs
{
    sharedNetwork = [NetworkEngine sharedNetworkEngine];
    if(sharedNetwork.completed){
        _activeBtn.selected = NO;
        _bidBtn.selected = NO;
        sharedNetwork.posted = false;
        _bidImgLine.backgroundColor = Grey_COLOR;
        _completedBtn.selected = YES;
        _CompletedImgLine.backgroundColor = ORANGE_COLOR;
        _activeImgLine.backgroundColor = Grey_COLOR;
        [self GetEmployerCompletedJobs];
    }
    else if(sharedNetwork.posted){
        _activeBtn.selected = NO;
        //_activeImgLine.backgroundColor = ORANGE_COLOR;
        _bidBtn.selected = YES;
        sharedNetwork.completed = false;
        _completedBtn.selected = NO;
        _CompletedImgLine.backgroundColor = Grey_COLOR;
        _bidImgLine.backgroundColor = ORANGE_COLOR;
        _activeImgLine.backgroundColor = Grey_COLOR;
        [self GetPostedJob];
        
    }
    else{
        _completedBtn.selected = NO;
        _bidBtn.selected = NO;
        _activeBtn.selected = YES;
        sharedNetwork.completed = false;
        sharedNetwork.posted = false;
        _CompletedImgLine.backgroundColor = Grey_COLOR;
        _activeImgLine.backgroundColor = ORANGE_COLOR;
        _bidImgLine.backgroundColor = Grey_COLOR;
        [self GetEmployerActiveJobs];
    }
    
    
}


#pragma mark - Button action

- (IBAction)actionCreateNewJob:(UIButton *)sender {
    
    
    CreateJobViewController *createJobVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateJobVC"];
    
    [self.navigationController pushViewController:createJobVC animated:YES];
    
}

- (IBAction)actionActiveBtn:(UIButton *)sender {
    _activeBtn.selected = YES;
    _bidBtn.selected = NO;
    _completedBtn.selected = NO;
    sharedNetwork.posted = false;
    sharedNetwork.completed = false;
    _activeImgLine.backgroundColor = ORANGE_COLOR;
    _bidImgLine.backgroundColor = Grey_COLOR;
    _CompletedImgLine.backgroundColor = Grey_COLOR;
    
    [self GetEmployerActiveJobs];
    
}
- (IBAction)actionBidBtn:(UIButton *)sender {
    
    _activeBtn.selected = NO;
    _bidBtn.selected = YES;
    _completedBtn.selected = NO;
    sharedNetwork.posted = true;
    sharedNetwork.completed = false;
    _activeImgLine.backgroundColor = Grey_COLOR;
    _bidImgLine.backgroundColor = ORANGE_COLOR;
    _CompletedImgLine.backgroundColor = Grey_COLOR;
    
    [self GetPostedJob];
    
}
- (IBAction)actionCompletedBtn:(UIButton *)sender {
    _activeBtn.selected = NO;
    _bidBtn.selected = NO;
    _completedBtn.selected = YES;
    sharedNetwork.posted = false;
    sharedNetwork.completed = true;
    _activeImgLine.backgroundColor = Grey_COLOR;
    _bidImgLine.backgroundColor = Grey_COLOR;
    _CompletedImgLine.backgroundColor = ORANGE_COLOR;
    
    [self GetEmployerCompletedJobs];
    //time now-
//    arrWork =[NSMutableArray new];
//    [self.myJobsTableVIew reloadData];
}

-(void)hideUnhideLable
{
    if (arrWork.count>0) {
        [self.noJobLable setHidden:YES];
        arrJobData = [[NSMutableArray alloc]initWithArray:arrWork];
    } else {
        [self.noJobLable setHidden:NO];
    }
    
    _searchBar.text =@"";
}


#pragma mark- Api method

-(void)GetPostedJob
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[[USERDEFAULTS valueForKey:userData] valueForKey:@"Id"] forKey:@"employerid"];

    
    [[NetworkEngine sharedNetworkEngine]GetPostedJob:^(id object)
     {
         
         NSLog(@"poted jobs %@",object);
         
         if ([[object valueForKey:@"message"] isEqualToString:@"success"])
         {
             [kAppDelegate hideProgressHUD];
             arrWork = [[object valueForKey:@"data"] mutableCopy];
             [self hideUnhideLable];
             NSArray *sortedArray;
             sortedArray = [arrWork sortedArrayUsingComparator: \
                            ^NSComparisonResult(id a, id b) {
                                NSDate *first = [NSDate dateWithTimeIntervalSince1970:([[a valueForKey:@"CreatedDate"] doubleValue] / 1000.0)];
                                NSDate *second = [NSDate dateWithTimeIntervalSince1970:([[b valueForKey:@"CreatedDate"] doubleValue] / 1000.0)];
                                return [second compare:first];
                            }];
             arrWork = [[NSMutableArray alloc]initWithArray:sortedArray];
             [self.myJobsTableVIew reloadData];

             
         }else if([[object valueForKey:@"message"] isEqualToString:@"Invalid Token!"])
         {
             
             [self CreateToken:@"PostedJobs"];
         }
         
         
         
         
     }
                                           onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
}

-(void)GetEmployerActiveJobs
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[[USERDEFAULTS valueForKey:userData] valueForKey:@"Id"] forKey:@"employerid"];
    
    [[NetworkEngine sharedNetworkEngine]GetEmployerActiveJobs:^(id object)
     {
         
         if ([[object valueForKey:@"message"] isEqualToString:@"success"])
         {
             [kAppDelegate hideProgressHUD];
             arrWork = [[object valueForKey:@"data"] mutableCopy];
             [self hideUnhideLable];
             NSArray *sortedArray;
             sortedArray = [arrWork sortedArrayUsingComparator: \
                            ^NSComparisonResult(id a, id b) {
                                NSDate *first = [NSDate dateWithTimeIntervalSince1970:([[a valueForKey:@"CreatedDate"] doubleValue] / 1000.0)];
                                NSDate *second = [NSDate dateWithTimeIntervalSince1970:([[b valueForKey:@"CreatedDate"] doubleValue] / 1000.0)];
                                return [second compare:first];
                            }];
             arrWork = [[NSMutableArray alloc]initWithArray:sortedArray];
             [self.myJobsTableVIew reloadData];
             
             
         }else if([[object valueForKey:@"message"] isEqualToString:@"Invalid Token!"])
         {
             
             [self CreateToken:@"ActiveJobs"];
         }
         
         
         
         
     }
                                             onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
}

-(void)GetEmployerCompletedJobs
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[[USERDEFAULTS valueForKey:userData] valueForKey:@"Id"] forKey:@"employerid"];

    
    [[NetworkEngine sharedNetworkEngine]GetEmployerCompletedJobs:^(id object)
     {
         
         if ([[object valueForKey:@"message"] isEqualToString:@"success"])
         {
             [kAppDelegate hideProgressHUD];
             arrWork = [[object valueForKey:@"data"] mutableCopy];
             NSLog(@"completed jobs-%@",arrWork);
             [self hideUnhideLable];
             [self.myJobsTableVIew reloadData];
             
             
         }else if([[object valueForKey:@"message"] isEqualToString:@"Invalid Token!"])
         {
             
             [self CreateToken:@"GetEmployerCompletedJobs"];
         }
     }
                                                      onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
}

-(void)CreateToken:(NSString*)jobtype
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:clientSecretValue forKey:@"clientSecret"];
    
    [[NetworkEngine sharedNetworkEngine]CreateToken:^(id object)
     {
         
         if ([[object valueForKey:@"message"] isEqualToString:@"success"])
         {
             
             [USERDEFAULTS setObject:[object valueForKey:@"data"] forKey:Token];
             
             if ([jobtype isEqualToString:@"ActiveJobs"])
             {
                  [self GetEmployerActiveJobs];
             }
             else if ([jobtype isEqualToString:@"GetEmployerCompletedJobs"])
             {
                 [self GetEmployerCompletedJobs];
             }
             else
             {
                  [self GetPostedJob];
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


#pragma mark - Table View Delegates and Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrWork.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"myJobsCell";
    DashboardTableViewCell *cell = [self.myJobsTableVIew dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSMutableDictionary *dic = [Utility removeNullFromDictionary:[arrWork objectAtIndex:indexPath.row]];
    
    cell.profilePic.layer.cornerRadius = cell.profilePic.frame.size.width / 2;
    cell.profilePic.clipsToBounds = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lblName.text = [dic valueForKey:@"JobTitle"];
    cell.lblWork.text = [dic valueForKey:@"JobDescription"];
    if(sharedNetwork.posted)
    {
    cell.lblBidAmount.text = [NSString stringWithFormat:@"$%@",[dic valueForKey:@"Budget"]];
    }
    else{
        cell.lblBidAmount.text = [NSString stringWithFormat:@"$%@",[dic valueForKey:@"CurrentBid"]];
    }
    int rate = [[dic valueForKey:@"EmployerRating"] intValue];
    
    [self addRating:cell :rate];
    cell.profilePic.tag = indexPath.row;
    
    [cell.profilePic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[dic valueForKey:@"Images"] firstObject]]] placeholderImage:[UIImage imageNamed:@"Profile_Picture_Placeholder"] options:0 progress:nil completed:nil];
    
    NSMutableArray *bidsArray = [dic valueForKey:@"Bids"];
    [cell.imgBidCount setHidden:NO];
    [cell.imgBid setHidden:NO];
    if (bidsArray.count>0) {
        [cell.imgBidCount setHidden:NO];
        [cell.imgBid setHidden:NO];
        cell.imgBidCount.text =[NSString stringWithFormat:@"%lu Bids",(unsigned long)bidsArray.count];
    } else {
        //          [cell.imgBid setHidden:YES];
        cell.imgBidCount.text = @"0 Bid";
        //        [cell.imgBidCount setHidden:YES];
    }
    
    if ([[dic valueForKey:@"IsDispute"] boolValue]) {
        [cell.errorImg setHidden:NO];
    }else
    {
        [cell.errorImg setHidden:YES];
    }

    
    if(!sharedNetwork.posted)
    {
          [cell.errorImg setImage:[UIImage imageNamed:@"Icon_Exclamation"]];
        [cell.imgBid setHidden:YES];
        [cell.imgBidCount setHidden:YES];
        [cell.paymentImage setHidden:YES];
        [cell.paymentDoneLbl setHidden:YES];
        
        if ([[dic valueForKey:@"IsPaymentRequested"] boolValue]) {
 
            [cell.paymentImage setHidden:NO];
             cell.paymentImage.contentMode = UIViewContentModeScaleAspectFit;
        }
        
        if ([[dic valueForKey:@"IsPaymentDone"] boolValue]) {
            
            [cell.paymentImage setHidden:YES];
            [cell.paymentDoneLbl setHidden:NO];

        }

    }
    else{
        if ([[dic valueForKey:@"IsInvited"] boolValue]) {
            [cell.errorImg setHidden:NO];
            [cell.imgBid setHidden:YES];
            [cell.imgBidCount setHidden:YES];
            [cell.errorImg setImage:[UIImage imageNamed:@"Tab_Bar_Icon_Unselected_Invites"]];
        }

        [cell.paymentImage setHidden:YES];
        [cell.paymentDoneLbl setHidden:true];
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(_bidBtn.selected){
        
        if (![[[arrWork objectAtIndex:indexPath.row] valueForKey:@"IsInvited"] boolValue])
        {
            sharedNetwork.posted = YES;
            EmployerBidJobDetailsViewController *EmployerBidJobDetailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployerBidJobDetailsVC"];
            EmployerBidJobDetailsVC.bidJobDetailDict= [arrWork objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:EmployerBidJobDetailsVC animated:YES];
            
        }
  
    }
    else if (_activeBtn.selected){
        
        if (![[[arrWork objectAtIndex:indexPath.row] valueForKey:@"IsDispute"] boolValue])
        {
            sharedNetwork.posted = false;
            sharedNetwork.completed = false;
            ActiveJobDetailsViewController *ActiveJobDetailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ActiveJobDetailsVC"];
            ActiveJobDetailsVC.activejobDetailDict = [arrWork objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:ActiveJobDetailsVC animated:YES];
        }
       
    }
    else if (_completedBtn.selected){
        sharedNetwork.completed = true;
        EmployerCompleteJobDetailsViewController *EmployerCompletedJobDetailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployerCompletedJobDetailsVC"];
        EmployerCompletedJobDetailsVC.completedJobDict = [arrWork objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:EmployerCompletedJobDetailsVC animated:YES];
    }
}

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

#pragma mark Searchbar delegates

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    //isSearching = YES;
    if([searchBar.text length] != 0) {
        isSearching = YES;
        // [self searchTableList:searchText];
    }
    else {
        isSearching = NO;
        
        [self searchTableList:searchBar.text];
    }
    
    // navTitle.text = @"Dashboard";
}

- (void)searchBar:(UISearchBar *)sBar textDidChange:(NSString *)searchText {
    
    
    if([searchText length] != 0) {
        isSearching = YES;
        // [self searchTableList:searchText];
    }
    else {
        isSearching = NO;
        
        arrWork = [arrJobData mutableCopy];
        
        //[self getAnnottion];
    }
    // [self.tblContentList reloadData];
}



- (void)searchBarSearchButtonClicked:(UISearchBar *)sBar {
    NSLog(@"Search Clicked");
    [_searchBar resignFirstResponder];
    [self searchTableList:sBar.text];
}
-(void)searchTableList:(NSString *)searchtext
{
    if(isSearching)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"JobTitle CONTAINS[cd] %@ OR JobDescription CONTAINS[cd] %@",searchtext,searchtext];
        
        filterdArray = [arrJobData filteredArrayUsingPredicate:predicate];
        
        arrWork = [filterdArray mutableCopy];
        
        //[self getAnnottion];
    }
    else
    {
        arrWork = [arrJobData mutableCopy];
        
        // [self getAnnottion];
    }
    
    [self.myJobsTableVIew reloadData];
    
}


@end
