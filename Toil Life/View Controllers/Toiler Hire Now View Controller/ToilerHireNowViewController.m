//
//  ToilerHireNowViewController.m
//  Toil Life
//
//  Created by Rajat Lakhina on 21/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import "ToilerHireNowViewController.h"

@interface ToilerHireNowViewController ()
{
    NSMutableArray *arrayOfStats;
    NSMutableArray *arrWork;
}
@end

@implementation ToilerHireNowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(IS_iPHONE_5){
       
        mainScl.contentSize = CGSizeMake(mainScl.frame.size.width, 650);
    }
    arrayOfStats = [[NSMutableArray alloc]initWithObjects:@"Trades and Construction", @"Domastic Help", nil ];
    arrWork = [[NSMutableArray alloc]init];
    NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
    for(int i=0;i<5;i++)
    {
        // Init End
        
        [data setObject:@"22 December 2017" forKey:@"Date"];
        [data setObject:@"Helper Needed" forKey:@"Comment"];
        [data setObject:@"1" forKey:@"ratings"];
        
        [arrWork addObject:data];
    }
    
    ///if(I)
    
    // Do any additional setup after loading the view.
}

#pragma mark - Button Action

- (IBAction)actionHireNow:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)actionSendInvite:(id)sender {
    
    //UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EmployerTabbarViewController *employerTabBarVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployerTabbarVC"];
    
    
    [self.navigationController pushViewController:employerTabBarVC animated:YES];
    
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
    
    [btntitle setFrame:CGRectMake(0, 0, cell.bounds.size.width-10, 30)];
    
    [btntitle.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:13]];
    
    [btntitle setTitle:(NSString *)[arrayOfStats objectAtIndex:indexPath.item] forState:UIControlStateNormal] ;
    
    btntitle.backgroundColor = ORANGE_COLOR;
    
    [btntitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    btntitle.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    btntitle.tag = indexPath.row;
    
    btntitle.layer.cornerRadius = 15; // this value vary as per your desire
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
    cell.lblComment.text = [dic valueForKey:@"Comment"];
    cell.lblDate.text = [dic valueForKey:@"Date"];
    int rate = [[dic valueForKey:@"ratings"] intValue];
    
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
