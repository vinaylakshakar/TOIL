//
//  EmployerBidViewController.m
//  Toil Life
//
//  Created by Rajat Lakhina on 16/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import "EmployerBidViewController.h"

@interface EmployerBidViewController ()
{
    NSMutableArray *arrWork;
    NSMutableArray *arrJobData;
    BOOL isSearching;
    NSArray *filterdArray;
    AppDelegate *del;
}
@end

@implementation EmployerBidViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    arrWork = [[NSMutableArray alloc]init];
    arrJobData = [[NSMutableArray alloc] init];
    filterdArray = [[NSArray alloc]init];
    
    _mostRecentView.backgroundColor = [UIColor whiteColor];
    _mostRecentBtn.titleLabel.textColor = ORANGE_COLOR;
    
    _highestRatedView.backgroundColor = [UIColor whiteColor];
    _highestRatedBtn.titleLabel.textColor = ORANGE_COLOR;
    
    _lowestBidView.backgroundColor = [UIColor whiteColor];
    _lowestBidBtn.titleLabel.textColor = ORANGE_COLOR;
    
    _allView.backgroundColor = ORANGE_COLOR;
    [_allBtn setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    _bidTableView.allowsSelection = NO;
    
    

    _filterView.clipsToBounds =YES;
    _filterView.layer.cornerRadius = 12;
    //_headerView.layer.cornerRadius = 6;
    _filterView.layer.borderColor = [Grey_COLOR CGColor];
    _filterView.layer.borderWidth = 1.0f;
    // Do any additional setup after loading the view.
    _filterView.hidden = YES;
    _blurView.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"ToilerDetailsVC"
                                               object:nil];
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

-(void)viewWillAppear:(BOOL)animated
{
    if (del.isSameTabIndex)
    {
        del.isSameTabIndex = false;
    }
    else
    {
        [self GetEmployerAllJobs];
        
    }

}

-(void)hideUnhideLable
{
    if (arrWork.count>0) {
        [self.noBidLabel setHidden:YES];
        arrJobData =[[NSMutableArray alloc]initWithArray:arrWork];
    } else {
        [self.noBidLabel setHidden:NO];
        [self.view bringSubviewToFront:self.noBidLabel];
    }
    
     _searchBar.text =@"";
}


#pragma mark- Api method

-(void)GetEmployerAllJobs
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[[USERDEFAULTS valueForKey:userData] valueForKey:@"Id"] forKey:@"employerid"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]GetEmployerAllJobs:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"message"] isEqualToString:@"success"])
         {
             [kAppDelegate hideProgressHUD];
             arrWork = [object valueForKey:@"data"];
             [self hideUnhideLable];
             [self.bidTableView reloadData];
             
             
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
             [self GetEmployerAllJobs];
             
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



#pragma mark - Button action

- (IBAction)actionCloseBtn:(UIButton *)sender {
    _filterView.hidden = YES;
    _blurView.hidden = YES;
}

- (IBAction)actionFilterBtn:(id)sender {
    _filterView.hidden = NO;
    _blurView.hidden = NO;
}

- (IBAction)actionMostRecentBtn:(UIButton *)sender {


    _mostRecentView.backgroundColor = ORANGE_COLOR;
    
    [_mostRecentBtn setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    
    [_mostRecentBtn titleColorForState:UIControlStateNormal];
    
    _lowestBidView.backgroundColor = [UIColor whiteColor];
    
    _lowestBidBtn.titleLabel.textColor = ORANGE_COLOR;
    
    _allView.backgroundColor = [UIColor whiteColor];
    
    _allBtn.titleLabel.textColor = ORANGE_COLOR;
    
    _highestRatedView.backgroundColor = WHITE_COLOR;
    _highestRatedBtn.titleLabel.textColor = ORANGE_COLOR;
    _filterView.hidden = YES;
    _blurView.hidden = YES;
}

- (IBAction)actionViewAllBtn:(UIButton *)sender {
    //UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    NSLog(@"array index is %ld",(long)sender.tag);
    
    EmployerBidListViewController *EmployerBidListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployerBidListVC"];
    EmployerBidListVC.bidlistArray =[[arrWork objectAtIndex:sender.tag] valueForKey:@"Bids"];
    EmployerBidListVC.jobTitleStr = [[arrWork objectAtIndex:sender.tag] valueForKey:@"JobTitle"];
    EmployerBidListVC.isFromAllBidScreen = YES;
    [self.navigationController pushViewController:EmployerBidListVC animated:YES];
}

- (void)receiveNotification:(NSNotification *)notification
{
    NSDictionary* userInfo = notification.userInfo;
    //NSLog(@"%@",userInfo);
    
    ToilerDetailsViewController *toilerDetailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ToilerDetailsVC"];
    toilerDetailsVC.toilerDetailDict = userInfo;
    [self.navigationController pushViewController:toilerDetailsVC animated:YES];
    
}


- (IBAction)actionLowestBidBtn:(UIButton *)sender {
    
    _mostRecentView.backgroundColor = [UIColor whiteColor];
    _mostRecentBtn.titleLabel.textColor = ORANGE_COLOR;
    
    _allView.backgroundColor = [UIColor whiteColor];
    
    _allBtn.titleLabel.textColor = ORANGE_COLOR;
    
    _highestRatedView.backgroundColor = [UIColor whiteColor];
    _highestRatedBtn.titleLabel.textColor = ORANGE_COLOR;
    
    _lowestBidView.backgroundColor = ORANGE_COLOR;
    //_lowestBidBtn.titleLabel.textColor = [UIColor whiteColor];
    [_lowestBidBtn setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    _filterView.hidden = YES;
    _blurView.hidden = YES;
}

- (IBAction)actionAllBtn:(UIButton *)sender {
    
    _mostRecentView.backgroundColor = [UIColor whiteColor];
    _mostRecentBtn.titleLabel.textColor = ORANGE_COLOR;
    
    _highestRatedView.backgroundColor = [UIColor whiteColor];
    _highestRatedBtn.titleLabel.textColor = ORANGE_COLOR;
    
    _lowestBidView.backgroundColor = [UIColor whiteColor];
    //[UIColor colorWithHue:24 saturation:100 brightness:100 alpha:1.0];
    _lowestBidBtn.titleLabel.textColor = ORANGE_COLOR;
    
    _allView.backgroundColor = ORANGE_COLOR;
    [_allBtn setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    //_allBtn.titleLabel.textColor = [UIColor whiteColor];
    _filterView.hidden = YES;
    _blurView.hidden = YES;
}

- (IBAction)actionHighestRatedBtn:(UIButton *)sender {
    
    _mostRecentView.backgroundColor = [UIColor whiteColor];
    
    _mostRecentBtn.titleLabel.textColor = ORANGE_COLOR;
 
    _lowestBidView.backgroundColor = [UIColor whiteColor];
    
    _lowestBidBtn.titleLabel.textColor = ORANGE_COLOR;
    
    _allView.backgroundColor = [UIColor whiteColor];
    
    _allBtn.titleLabel.textColor = ORANGE_COLOR;
    
    _highestRatedView.backgroundColor = ORANGE_COLOR;
    [_highestRatedBtn setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    _filterView.hidden = YES;
    _blurView.hidden = YES;
    //_highestRatedBtn.titleLabel.textColor = [UIColor whiteColor];
}


#pragma mark - Table View Delegates and Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrWork.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"BidCell";
    BidTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSMutableDictionary *dic = [arrWork objectAtIndex:indexPath.row];
    cell.lblWorkName.text = [dic valueForKey:@"JobTitle"];
    cell.BidsArray = [[dic valueForKey:@"Bids"] mutableCopy];
    NSString *indexNumber =[NSString stringWithFormat:@"%ld",(long)indexPath.row];
    [cell assignArray:indexNumber];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(IS_iPHONE_5){
        return 107;
    }
    else if (IS_STANDARD_IPHONE_6){
        return 119;
    }
    else if (IS_STANDARD_IPHONE_6_PLUS){
        return 132;
    }
    return 100;
}

#pragma mark - Searchbar delegates

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
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"JobTitle CONTAINS[cd] %@",searchtext];
        
        filterdArray = [arrJobData filteredArrayUsingPredicate:predicate];
        
        arrWork = [filterdArray mutableCopy];
        
        //[self getAnnottion];
    }
    else
    {
        arrWork = [arrJobData mutableCopy];
        
        // [self getAnnottion];
    }
    
     [self.bidTableView reloadData];
    
}

@end
