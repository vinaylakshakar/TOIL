//
//  BidTableViewCell.m
//  Toil Life
//
//  Created by Rajat Lakhina on 16/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import "BidTableViewCell.h"
#import "ToilerDetailsViewController.h"

@implementation BidTableViewCell
{
    NSMutableArray *arrWork;
    NSInteger indexNumber;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.BidsArray = [[NSMutableArray alloc]init];
    arrWork = [[NSMutableArray alloc]init];
   
    _bidCollectionView.delegate = self;
    self.bidCollectionView.dataSource = self;
    
}

-(void)assignArray:(NSString *)indexValue
{
    arrWork = [[NSMutableArray alloc]initWithArray:self.BidsArray];
    indexNumber =[indexValue integerValue];
    [_bidCollectionView reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Button Action


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    if(arrWork.count >= 4){
//        return 4;
//    }
//    else{
        return arrWork.count;
        
//    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //BidCollectionViewCell
    
    if(arrWork.count > 3){
    if(indexPath.row < 3)
    {
        
     static NSString *identifier = @"topBidCell";


        BidCollectionViewCell *cell = [self.bidCollectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        NSMutableDictionary *dic = [arrWork objectAtIndex:indexPath.row];
        //cell.lblName.text = [self getShortName:[dic valueForKey:@"Name"]];
        cell.lblName.text = [dic valueForKey:@"Name"];
        cell.lblBidPrice.text = [NSString stringWithFormat:@"$%@",[dic valueForKey:@"BidAmount"]];
        
        int ratingStr =[[dic valueForKey:@"Rating"] intValue];
        cell.lblRating.text = [NSString stringWithFormat:@"%d",ratingStr];

        
        cell.profilePic.tag = indexPath.row;
        
        [cell.profilePic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic valueForKey:@"ProfilePic"]]] placeholderImage:[UIImage imageNamed:@"Profile_Picture_Placeholder"] options:0 progress:nil completed:nil];
        if(IS_iPHONE_5){
            cell.profilePic.layer.cornerRadius = 20;
            cell.profilePic.clipsToBounds = YES;
        }
        else if (IS_STANDARD_IPHONE_6){
            cell.profilePic.layer.cornerRadius = 22.5;
            cell.profilePic.clipsToBounds = YES;
        }
        else if (IS_STANDARD_IPHONE_6_PLUS){
            cell.profilePic.layer.cornerRadius = 25;
            cell.profilePic.clipsToBounds = YES;
        }
            return cell;
    }
        else if(indexPath.row == 3)
        {
        ButtonCollectionViewCell *cell1 = [self.bidCollectionView dequeueReusableCellWithReuseIdentifier:@"buttonCell" forIndexPath:indexPath];
            long arrCount = (arrWork.count - 3);
            NSString *bidCount = [NSString stringWithFormat:@"%ld", arrCount];
            NSString *tCount = [NSString stringWithFormat:@"%@%@", @"+", bidCount];
            //[tCount appendFormat:@"+%@", bidCount];
            cell1.showAllBidBtn.tag = indexNumber;
            
            cell1.lblBidCount.text = tCount;
            if(IS_iPHONE_5){
                cell1.imgRatingCircle.layer.cornerRadius = 20;
                cell1.imgRatingCircle.clipsToBounds = YES;
            }
            else if (IS_STANDARD_IPHONE_6){
                cell1.imgRatingCircle.layer.cornerRadius = 22.5;
                cell1.imgRatingCircle.clipsToBounds = YES;
            }
            else if (IS_STANDARD_IPHONE_6_PLUS){
                cell1.imgRatingCircle.layer.cornerRadius = 25;
                cell1.imgRatingCircle.clipsToBounds = YES;
            }
        return cell1;
        //cell.lblName =

        }
        //return cell;


    }
    //else{
        static NSString *identifier = @"topBidCell";

        BidCollectionViewCell *cell = [self.bidCollectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];

        NSMutableDictionary *dic = [arrWork objectAtIndex:indexPath.row];
        //cell.lblName.text = [self getShortName:[dic valueForKey:@"Name"]];
      cell.lblName.text = [dic valueForKey:@"Name"];
        cell.lblBidPrice.text = [NSString stringWithFormat:@"$%@",[dic valueForKey:@"BidAmount"]];
        //cell.lblRating.text = [dic valueForKey:@"Rating"];
    int ratingStr =[[dic valueForKey:@"Rating"] intValue];
    cell.lblRating.text = [NSString stringWithFormat:@"%d",ratingStr];
    
    cell.profilePic.tag = indexPath.row;
    cell.bidDetailBtn.tag = indexNumber;
    
    [cell.profilePic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic valueForKey:@"ProfilePic"]]] placeholderImage:[UIImage imageNamed:@"Profile_Picture_Placeholder"] options:0 progress:nil completed:nil];
    if(IS_iPHONE_5){
        cell.profilePic.layer.cornerRadius = 20;
        cell.profilePic.clipsToBounds = YES;
    }
    else if (IS_STANDARD_IPHONE_6){
        cell.profilePic.layer.cornerRadius = 22.5;
        cell.profilePic.clipsToBounds = YES;
    }
    else if (IS_STANDARD_IPHONE_6_PLUS){
        cell.profilePic.layer.cornerRadius = 25;
        cell.profilePic.clipsToBounds = YES;
    }
    
        //cell.lblName =
        return cell;
    //}
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    NSDictionary *userDict = [arrWork objectAtIndex:indexPath.row];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ToilerDetailsVC" object:self userInfo:userDict];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(IS_iPHONE_5){
         return CGSizeMake(70, 70);
    }
    else if (IS_STANDARD_IPHONE_6)
    {
        return CGSizeMake(80, 80);
    }
    else{
        return CGSizeMake(90, 90);
    }
   
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
