
#import "EmployerBidListViewController.h"

@interface EmployerBidListViewController ()
{
    NSMutableArray *arrWork;
    NSMutableArray *arrJobData;
    BOOL isSearching;
    NSArray *filterdArray;
}
@end

@implementation EmployerBidListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _allBtn.selected = YES;
    
    arrWork = [[NSMutableArray alloc]init];
    arrJobData = [[NSMutableArray alloc] init];
    filterdArray = [[NSArray alloc]init];
    
    NSLog(@"%@",self.bidlistArray);
    self.lblTitle.text = self.jobTitleStr;
    // Do any additional setup after loading the view.
    [self setLayout];
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

-(void)setLayout
{
    arrWork = self.bidlistArray;
    arrJobData = self.bidlistArray;
    [self hideUnhideLable];
    [self.toilerBidsTable reloadData];
}

-(void)hideUnhideLable
{
    if (arrWork.count>0) {
        [self.noBidLable setHidden:YES];
    } else {
        [self.noBidLable setHidden:NO];
    }
    
    _searchBar.text =@"";
}

-(void)sortAllBids:(NSString*)type
{
    [self setLayout];
    
    if ([type isEqualToString:@"BidAmount"])
    {
        NSArray *sorted_Array = [arrWork sortedArrayUsingDescriptors:
                                 @[[NSSortDescriptor sortDescriptorWithKey:@"BidAmount"
                                                                 ascending:NO]]];
        arrWork = [[NSMutableArray alloc]initWithArray:sorted_Array];
        [self.toilerBidsTable reloadData];
    }
    
    if ([type isEqualToString:@"Rating"])
    {
        NSArray *sorted_Array = [arrWork sortedArrayUsingDescriptors:
                                 @[[NSSortDescriptor sortDescriptorWithKey:@"Rating"
                                                                 ascending:NO]]];
        arrWork = [[NSMutableArray alloc]initWithArray:sorted_Array];
        [self.toilerBidsTable reloadData];
    }
    
    if ([type isEqualToString:@"CreatedDate"])
    {

        NSArray *sortedArray;
        sortedArray = [arrWork sortedArrayUsingComparator: \
                       ^NSComparisonResult(id a, id b) {
                           NSDate *first = [NSDate dateWithTimeIntervalSince1970:([[a valueForKey:@"CreatedDate"] doubleValue] / 1000.0)];
                           NSDate *second = [NSDate dateWithTimeIntervalSince1970:([[b valueForKey:@"CreatedDate"] doubleValue] / 1000.0)];
                           return [second compare:first];
                       }];
        arrWork = [[NSMutableArray alloc]initWithArray:sortedArray];
        [self.toilerBidsTable reloadData];

    }

    [self hideUnhideLable];
}


#pragma mark - Button Action

- (IBAction)actionBidBtn:(UIButton *)sender {
    _allBtn.selected = NO;
    _bidBtn.selected = YES;
    _ratingBtn.selected = NO;
    _recentBtn.selected = NO;
    _imgBid.backgroundColor = ORANGE_COLOR;
    _imgAll.backgroundColor = Grey_COLOR;
    _imgRating.backgroundColor = Grey_COLOR;
    _imgRecent.backgroundColor = Grey_COLOR;
    [self sortAllBids:@"BidAmount"];
   
}
- (IBAction)actionRatingBtn:(UIButton *)sender {
    _allBtn.selected = NO;
    _bidBtn.selected = NO;
    _ratingBtn.selected = YES;
    _recentBtn.selected = NO;
    _imgBid.backgroundColor = Grey_COLOR;
    _imgAll.backgroundColor = Grey_COLOR;
    _imgRating.backgroundColor = ORANGE_COLOR;
    _imgRecent.backgroundColor = Grey_COLOR;
    [self sortAllBids:@"Rating"];
}
- (IBAction)actionRecentBtn:(UIButton *)sender {
    _allBtn.selected = NO;
    _bidBtn.selected = NO;
    _ratingBtn.selected = NO;
    _recentBtn.selected = YES;
    _imgBid.backgroundColor = Grey_COLOR;
    _imgAll.backgroundColor = Grey_COLOR;
    _imgRating.backgroundColor = Grey_COLOR;
    _imgRecent.backgroundColor = ORANGE_COLOR;
    [self sortAllBids:@"CreatedDate"];
}
- (IBAction)actionBackBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)actionAllBtn:(UIButton *)sender {
    
    _allBtn.selected = YES;
    _bidBtn.selected = NO;
    _ratingBtn.selected = NO;
    _recentBtn.selected = NO;
    _imgBid.backgroundColor = Grey_COLOR;
    _imgAll.backgroundColor = ORANGE_COLOR;
    _imgRating.backgroundColor = Grey_COLOR;
    _imgRecent.backgroundColor = Grey_COLOR;
    [self setLayout];
}

#pragma mark - Table View Delegates and Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrWork.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"BidListCell";
    DashboardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSMutableDictionary *dic = [arrWork objectAtIndex:indexPath.row];
    
    cell.profilePic.layer.cornerRadius = cell.profilePic.frame.size.width / 2;
    cell.profilePic.clipsToBounds = YES;
    
    cell.lblName.text = [dic valueForKey:@"Name"];
    //cell.lblWork.text = [dic valueForKey:@"Work"];
    cell.lblBidAmount.text = [NSString stringWithFormat:@"$%@",[dic valueForKey:@"BidAmount"]];
    int rate = [[dic valueForKey:@"Rating"] intValue];
    cell.profilePic.tag = indexPath.row;
    
    [cell.profilePic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic valueForKey:@"ProfilePic"]]] placeholderImage:[UIImage imageNamed:@"Profile_Picture_Placeholder"] options:0 progress:nil completed:nil];
    
    [self addRating:cell :rate];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    


        ToilerDetailsViewController *toilerDetailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ToilerDetailsVC"];
        toilerDetailsVC.toilerDetailDict = [arrWork objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:toilerDetailsVC animated:YES];
 
    
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
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Name CONTAINS[cd] %@",searchtext];
        
        filterdArray = [arrJobData filteredArrayUsingPredicate:predicate];
        
        arrWork = [filterdArray mutableCopy];
        
        //[self getAnnottion];
    }
    else
    {
        arrWork = [arrJobData mutableCopy];
        
        // [self getAnnottion];
    }
    
    [self.toilerBidsTable reloadData];
    
}

@end
