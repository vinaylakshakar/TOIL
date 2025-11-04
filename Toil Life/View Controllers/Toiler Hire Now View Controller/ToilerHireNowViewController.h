//
//  ToilerHireNowViewController.h
//  Toil Life
//
//  Created by Rajat Lakhina on 21/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToilerHireNowViewController : UIViewController
{
     IBOutlet UIScrollView *mainScl;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profilePicHeight;

@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *keywordsCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblAmount;
@property (weak, nonatomic) IBOutlet UIImageView *ratingFirstStar;
@property (weak, nonatomic) IBOutlet UIImageView *rating2ndStar;
@property (weak, nonatomic) IBOutlet UIImageView *rating3Star;
@property (weak, nonatomic) IBOutlet UIImageView *rating4star;
@property (weak, nonatomic) IBOutlet UIImageView *rating5Star;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profilePicHeight;


@end
