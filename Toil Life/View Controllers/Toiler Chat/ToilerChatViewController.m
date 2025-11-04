//
//  ToilerChatViewController.m
//  Toil Life
//
//  Created by Rajat Lakhina on 22/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import "ToilerChatViewController.h"

@interface ToilerChatViewController ()
{
    NSMutableArray *arrWork;
    NSMutableArray *arrJobData;
    BOOL isSearching;
    NSArray *filterdArray;
     AppDelegate *del;
}
@end

@implementation ToilerChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
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
-(void)hideUnhideLable
{
    if (arrWork.count>0) {
        [self.noChatLable setHidden:YES];
        arrJobData = [[NSMutableArray alloc]initWithArray:arrWork];
    } else {
        [self.noChatLable setHidden:NO];
    }
    
    _searchBar.text =@"";
}


-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
    if (del.isSameTabIndex)
    {
        del.isSameTabIndex = false;
    }
    else
    {
        [self GetMemberChatList];
    }

}

#pragma mark- Api method

-(void)GetMemberChatList
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[[USERDEFAULTS valueForKey:userData] valueForKey:@"Id"] forKey:@"userId"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]GetMemberChatList:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"message"] isEqualToString:@"success"])
         {
             [kAppDelegate hideProgressHUD];
             arrWork = [object valueForKey:@"data"];
             NSArray *sortedArray;
             sortedArray = [arrWork sortedArrayUsingComparator: \
                            ^NSComparisonResult(id a, id b) {
                                NSDate *first = [NSDate dateWithTimeIntervalSince1970:([[a valueForKey:@"CreatedDate"] doubleValue] / 1000.0)];
                                NSDate *second = [NSDate dateWithTimeIntervalSince1970:([[b valueForKey:@"CreatedDate"] doubleValue] / 1000.0)];
                                return [second compare:first];
                            }];
             arrWork = [[NSMutableArray alloc]initWithArray:sortedArray];
             
            
             [self hideUnhideLable];
             [self.listChatTableView reloadData];
             
             
         }else if([[object valueForKey:@"message"] isEqualToString:@"No Data Found!"])
         {
             [kAppDelegate hideProgressHUD];
             [self hideUnhideLable];
         }
         else if([[object valueForKey:@"message"] isEqualToString:@"Invalid Token!"])
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
             [self GetMemberChatList];
             
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
    NSString *CellIdentifier = @"chatListCell";
    DashboardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSMutableDictionary *dic = [arrWork objectAtIndex:indexPath.row];
    cell.lblName.text = [dic valueForKey:@"JobTitle"];
    cell.lblWork.text = [dic valueForKey:@"Message"];
    cell.profilePic.layer.cornerRadius = cell.profilePic.frame.size.width / 2;
    cell.profilePic.clipsToBounds = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    int rate = [[dic valueForKey:@"Rating"] intValue];
    
    [self addRating:cell :rate];
    cell.profilePic.tag = indexPath.row;
    
    [cell.profilePic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic valueForKey:@"ProfilePicture"]]] placeholderImage:[UIImage imageNamed:@"Profile_Picture_Placeholder"] options:0 progress:nil completed:nil];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
ChatViewController *UserChatVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserChatVC"];
UserChatVC.recieverIDStr = [[arrWork objectAtIndex:indexPath.row] valueForKey:@"ProfileId"];
    UserChatVC.recieverNameStr = [[arrWork objectAtIndex:indexPath.row] valueForKey:@"ProfileName"];
    UserChatVC.jobIDStr = [[arrWork objectAtIndex:indexPath.row] valueForKey:@"JobId"];
[self.navigationController pushViewController:UserChatVC animated:YES];
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
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ProfileName CONTAINS[cd] %@",searchtext];
        
        filterdArray = [arrJobData filteredArrayUsingPredicate:predicate];
        
        arrWork = [filterdArray mutableCopy];
        
        //[self getAnnottion];
    }
    else
    {
        arrWork = [arrJobData mutableCopy];
        
        // [self getAnnottion];
    }
    
    [self.listChatTableView reloadData];
    
}


@end
