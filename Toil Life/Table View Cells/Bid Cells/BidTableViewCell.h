//
//  BidTableViewCell.h
//  Toil Life
//
//  Created by Rajat Lakhina on 16/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BidTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *bidCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *lblWorkName;
@property (strong, nonatomic) NSMutableArray *BidsArray;
//@property (weak, nonatomic) IBOutlet UIView *contentView;
-(void)assignArray:(NSString *)indexValue;
@end
