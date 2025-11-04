//
//  InvitesViewController.m
//  Toil Life
//
//  Created by Rajat Lakhina on 16/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import "InvitesViewController.h"

@interface InvitesViewController ()
{
    NSMutableArray *arrWork;
    NSMutableArray *arrJobData;
    BOOL isSearching;
    NSArray *filterdArray;
    AppDelegate *del;
}
@end

@implementation InvitesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Init Begin
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

-(void)viewWillAppear:(BOOL)animated
{
    if (del.isSameTabIndex)
    {
        del.isSameTabIndex = false;
    }
    else
    {
        [self GetToilerInvites];
    }
 
}

-(void)hideUnhideLable
{
    if (arrWork.count>0) {
        [self.noJobLabel setHidden:YES];
    } else {
        [self.noJobLabel setHidden:NO];
    }
    
    _searchBar.text =@"";
}

#pragma mark- Api method

-(void)GetToilerInvites
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[[USERDEFAULTS valueForKey:userData] valueForKey:@"Id"] forKey:@"toilerid"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]GetToilerInvites:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"message"] isEqualToString:@"success"])
         {
             [kAppDelegate hideProgressHUD];
             arrJobData = [[object valueForKey:@"data"] mutableCopy];
             arrWork = [[NSMutableArray alloc]initWithArray:arrJobData];
             [self hideUnhideLable];
             [self.invitesTableView reloadData];

             
             
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
             [self GetToilerInvites];
             
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
     InviteDetailsViewController *inviteDetailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"InviteDetailsVC"];
    inviteDetailsVC.inviteJobDetailDict = [arrWork objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:inviteDetailsVC animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"InviteCell";
    DashboardTableViewCell *cell = [self.invitesTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSMutableDictionary *dic = [Utility removeNullFromDictionary:[arrWork objectAtIndex:indexPath.row]];
    
    cell.profilePic.layer.cornerRadius = cell.profilePic.frame.size.width / 2;
    cell.profilePic.clipsToBounds = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.lblName.text = [dic valueForKey:@"EmployerName"];
    cell.lblWork.text = [dic valueForKey:@"JobTitle"];
    
    if (![[dic valueForKey:@"EmployerRating"] isEqual:[NSNull null]])
    {
        int rate = [[dic valueForKey:@"EmployerRating"] intValue];
        
        [self addRating:cell :rate];
    }
    
    
    cell.profilePic.tag = indexPath.row;
    
    [cell.profilePic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic valueForKey:@"EmployerPic"]]] placeholderImage:[UIImage imageNamed:@"Profile_Picture_Placeholder"] options:0 progress:nil completed:nil];

    
    return cell;
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
    
        [self.invitesTableView reloadData];
    
}


@end
