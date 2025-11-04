

#import "ToilerMyJobsViewController.h"
#import "ToilerActiveJobDetailsViewController.h"

@interface ToilerMyJobsViewController ()
{
    NSMutableArray *arrWork;
    NSMutableArray *arrJobData;
    BOOL isSearching;
    NSArray *filterdArray;
    NetworkEngine *sharedNetwork;
    AppDelegate *del;
}
@end

@implementation ToilerMyJobsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Init Begin
    del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (_isfromToilerProfile) {
        _completedBtn.selected = YES;
    }else{
        _activeBtn.selected = YES;
    }
    
    // Do any additional setup after loading the view.
    arrWork = [[NSMutableArray alloc]init];
    arrJobData = [[NSMutableArray alloc] init];
    filterdArray = [[NSArray alloc]init];

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
    
    if (_isfromToilerProfile==YES)
    {
        self.navigationTitle.text = @"Job History";
        if(IS_iPHONE_5){
            self.myJobsTableVIew.frame = CGRectMake(self.myJobsTableVIew.frame.origin.x, self.selectionView.frame.origin.y, self.selectionView.frame.size.width, self.myJobsTableVIew.frame.size.height+self.selectionView.frame.size.height);
            self.selectionView.frame = CGRectMake(self.selectionView.frame.origin.x, self.selectionView.frame.origin.y, self.selectionView.frame.size.width, 0);
        }else
        {
            self.selectionViewHeight.constant = 0;
        }
        _completedBtn.selected = YES;
        [self GetToilerCompletedJobs];
    }else
    {
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

-(NSString*)convertDateFormate:(NSString*)dateString
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM/dd/yyyy"];
    NSDate *date = [format dateFromString:dateString];
    [format setDateFormat:@"dd MMMM yyyy"];
    NSString* finalDateString = [format stringFromDate:date];
    return finalDateString;
}

-(NSString*)getConvertedDate:(NSString*)dateStr
{
    NSDate *CreatedDate = [NSDate dateWithTimeIntervalSince1970:([dateStr doubleValue] / 1000.0)];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMMM YYYY"];
    NSString *dateString = [dateFormatter stringFromDate:CreatedDate];
    return dateString;
}

-(void)getjobs
{
    sharedNetwork = [NetworkEngine sharedNetworkEngine];
    if(sharedNetwork.completed){
        _activeBtn.selected = NO;
        sharedNetwork.posted = NO;
        _bidBtn.selected = NO;
        _bidImgLine.backgroundColor = Grey_COLOR;
        _completedBtn.selected = YES;
        _CompletedImgLine.backgroundColor = ORANGE_COLOR;
        _activeImgLine.backgroundColor = Grey_COLOR;
        
        [self GetToilerCompletedJobs];
        
    }else if(sharedNetwork.posted){
        _activeBtn.selected = NO;
        //_activeImgLine.backgroundColor = ORANGE_COLOR;
        sharedNetwork.completed = NO;
        _bidBtn.selected = YES;
        _completedBtn.selected = NO;
        _CompletedImgLine.backgroundColor = Grey_COLOR;
        _bidImgLine.backgroundColor = ORANGE_COLOR;
        _activeImgLine.backgroundColor = Grey_COLOR;
        [self GetBidJob];
        
    }
    else{
        _completedBtn.selected = NO;
        _bidBtn.selected = NO;
        _activeBtn.selected = YES;
        sharedNetwork.posted = NO;
        sharedNetwork.completed = NO;
        _CompletedImgLine.backgroundColor = Grey_COLOR;
        _activeImgLine.backgroundColor = ORANGE_COLOR;
        _bidImgLine.backgroundColor = Grey_COLOR;
        
        [self GetToilerActiveJobs];
    }
    
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

#pragma mark - Button action

- (IBAction)actionActiveBtn:(UIButton *)sender {
    _activeBtn.selected = YES;
    _bidBtn.selected = NO;
    _completedBtn.selected = NO;
    sharedNetwork.posted = false;
    sharedNetwork.completed = false;
    _activeImgLine.backgroundColor = ORANGE_COLOR;
    _bidImgLine.backgroundColor = Grey_COLOR;
    _CompletedImgLine.backgroundColor = Grey_COLOR;
    
    [self GetToilerActiveJobs];
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
    
    [self GetBidJob];
    
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
    
    [self GetToilerCompletedJobs];
}

#pragma mark- Api method

-(void)GetBidJob
{
    isSearching = false;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[[USERDEFAULTS valueForKey:userData] valueForKey:@"Id"] forKey:@"toilerid"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]GetBidJob:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"message"] isEqualToString:@"success"])
         {
             [kAppDelegate hideProgressHUD];
             arrWork = [[object valueForKey:@"data"] mutableCopy];
             [self hideUnhideLable];
             [self.myJobsTableVIew reloadData];
             
             
         }else if([[object valueForKey:@"message"] isEqualToString:@"Invalid Token!"])
         {
             
             [self CreateToken:@"GetBidJob"];
         }
         
         
         
         
     }
                                             onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
}

-(void)GetToilerActiveJobs
{
    isSearching = false;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[[USERDEFAULTS valueForKey:userData] valueForKey:@"Id"] forKey:@"employerid"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]GetToilerActiveJobs:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"message"] isEqualToString:@"success"])
         {
             [kAppDelegate hideProgressHUD];
             arrWork = [[object valueForKey:@"data"] mutableCopy];
             [self hideUnhideLable];
             [self.myJobsTableVIew reloadData];
             
             
         }else if([[object valueForKey:@"message"] isEqualToString:@"Invalid Token!"])
         {
             
             [self CreateToken:@"GetToilerActiveJobs"];
         }
         
         
         
         
     }
                                          onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
}

-(void)GetToilerCompletedJobs
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[[USERDEFAULTS valueForKey:userData] valueForKey:@"Id"] forKey:@"employerid"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]GetToilerCompletedJobs:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"message"] isEqualToString:@"success"])
         {
             [kAppDelegate hideProgressHUD];
             arrWork = [[object valueForKey:@"data"] mutableCopy];
             [self hideUnhideLable];
             [self.myJobsTableVIew reloadData];
             
             
         }else if([[object valueForKey:@"message"] isEqualToString:@"Invalid Token!"])
         {
             
             [self CreateToken:@"GetToilerCompletedJobs"];
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
             
             if ([jobtype isEqualToString:@"GetBidJob"]) {
                 [self GetBidJob];
             }
             if ([jobtype isEqualToString:@"GetToilerActiveJobs"]) {
                 [self GetToilerActiveJobs];
             }
             if ([jobtype isEqualToString:@"GetToilerCompletedJobs"]) {
                 [self GetToilerCompletedJobs];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (!_completedBtn.isSelected) {
        return arrWork.count;
    }
    return 1;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (arrWork.count>0&&!_completedBtn.isSelected&&!isSearching) {
        NSMutableDictionary *dic = [Utility removeNullFromDictionary:[arrWork objectAtIndex:section]];
        //NSString *endDate = [NSString stringWithFormat:@"Created Date:%@",[self getConvertedDate:[dic valueForKey:@"CreatedDate"]]];
        NSString *endDate = [NSString stringWithFormat:@"Created Date:%@",[self convertDateFormate:[dic valueForKey:@"CreatedDate"]]];
        return endDate;
    }
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!_completedBtn.isSelected&&!isSearching)
    {
        NSMutableDictionary *dic = [Utility removeNullFromDictionary:[arrWork objectAtIndex:section]];
        NSMutableArray *jobdataArray = [dic valueForKey:@"jobdata"];
        return jobdataArray.count;
    }
    return arrWork.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"myJobsCell";
    DashboardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.profilePic.layer.cornerRadius = cell.profilePic.frame.size.width / 2;
    cell.profilePic.clipsToBounds = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //vinay here-
    if (!_completedBtn.isSelected) {
         
        NSMutableDictionary *ActiveJobdict;
        NSMutableDictionary *SectionDict;
         
        if (isSearching) {
            SectionDict = [Utility removeNullFromDictionary:[arrWork objectAtIndex:indexPath.row]];
        } else {
            ActiveJobdict = [Utility removeNullFromDictionary:[arrWork objectAtIndex:indexPath.section]];
            SectionDict = [[ActiveJobdict valueForKey:@"jobdata"] objectAtIndex:indexPath.row];
        }
        
          cell.lblName.text = [SectionDict valueForKey:@"JobTitle"];
          cell.lblWork.text = [SectionDict valueForKey:@"JobDescription"];
        //vinay here-
        [cell.lblEndDate  setHidden:NO];
        
        if ([SectionDict valueForKey:@"EndDate"]==[NSNull null]||![SectionDict valueForKey:@"EndDate"]) {
            cell.lblEndDate.text =@"";
        }else{
             cell.lblEndDate.text = [NSString stringWithFormat:@"End Date:%@",[self getConvertedDate:[SectionDict valueForKey:@"EndDate"]]];
        }
       
        if(_bidBtn.selected)
        {
          cell.lblBidAmount.text = [NSString stringWithFormat:@"$%@",[SectionDict valueForKey:@"Budget"]];
        }
        else{
            cell.lblBidAmount.text = [NSString stringWithFormat:@"$%@",[SectionDict valueForKey:@"CurrentBid"]];
        }
          int rate = [[SectionDict valueForKey:@"EmployerRating"] intValue];
          [self addRating:cell :rate];
          cell.profilePic.tag = indexPath.row;
          
          [cell.profilePic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[SectionDict valueForKey:@"Images"] firstObject]]] placeholderImage:[UIImage imageNamed:@"Profile_Picture_Placeholder"] options:0 progress:nil completed:nil];
          
          NSMutableArray *bidsArray = [SectionDict valueForKey:@"Bids"];
          
          if (bidsArray.count>0) {
              cell.imgBidCount.text =[NSString stringWithFormat:@"%lu Bids",(unsigned long)bidsArray.count];
          } else {
              cell.imgBidCount.text = @"0 Bid";
          }
          
          if ([[SectionDict valueForKey:@"IsDispute"] boolValue]) {
              [cell.errorImg setHidden:NO];
          }else
          {
              [cell.errorImg setHidden:YES];
          }
          
          return cell;
    }
    
    
    NSMutableDictionary *dic = [Utility removeNullFromDictionary:[arrWork objectAtIndex:indexPath.row]];
    cell.lblName.text = [dic valueForKey:@"JobTitle"];
    cell.lblWork.text = [dic valueForKey:@"JobDescription"];
    [cell.lblEndDate  setHidden:YES];
    [self.activeImgLine setHidden:YES];
  if(_bidBtn.selected)
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
    
    if (bidsArray.count>0) {
        cell.imgBidCount.text =[NSString stringWithFormat:@"%lu Bids",(unsigned long)bidsArray.count];
    } else {
        cell.imgBidCount.text = @"0 Bid";
    }
    
    if ([[dic valueForKey:@"IsDispute"] boolValue]) {
        [cell.errorImg setHidden:NO];
    }else
    {
        [cell.errorImg setHidden:YES];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(_bidBtn.selected)
    {
         sharedNetwork.posted = YES;
         BidsJobDetailsViewController *BidsJobDetailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BidsJobDetailsVC"];
        BidsJobDetailsVC.jobBidDetailDict = [arrWork objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:BidsJobDetailsVC animated:YES];
        
    }
    else if (_activeBtn.selected){
 
          NSMutableDictionary *ActiveJobdict = [Utility removeNullFromDictionary:[arrWork objectAtIndex:indexPath.section]];
            
        if (![[[[ActiveJobdict valueForKey:@"jobdata"] objectAtIndex:indexPath.row] valueForKey:@"IsDispute"] boolValue])
        {
            ToilerActiveJobDetailsViewController *ActiveJobDetailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ToilerActiveJobDetailsViewController"];
            ActiveJobDetailsVC.activejobDetailDict = [[ActiveJobdict valueForKey:@"jobdata"] objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:ActiveJobDetailsVC animated:YES];
        }
       
    }
    else if (_completedBtn.selected){
        
        CompletedJobDetailsViewController *CompletedJobDetailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CompletedJobDetailsVC"];
        CompletedJobDetailsVC.completedJobDict = [arrWork objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:CompletedJobDetailsVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
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

#pragma mark - Searchbar delegates

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
   // isSearching = YES;
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
        
        if (!_completedBtn.selected)
        {
            NSMutableArray *rows = [NSMutableArray array];
            for(NSDictionary *dict in arrJobData)
            {
                NSArray *tempRows = dict[@"jobdata"];
                if([tempRows isKindOfClass: [NSArray class]] && tempRows.count)
                {
                    [rows addObjectsFromArray:tempRows];
                }
            }
           // NSArray *filteredArray = [rows filteredArrayUsingPredicate: predicate];
            filterdArray = [rows filteredArrayUsingPredicate:predicate];
                   
            arrWork = [filterdArray mutableCopy];
        } else {
             filterdArray = [arrJobData filteredArrayUsingPredicate:predicate];
                   
            arrWork = [filterdArray mutableCopy];
        }
        
       
        
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
