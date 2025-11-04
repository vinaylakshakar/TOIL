//
//  ToilerDetailsViewController.h
//  Toil Life
//
//  Created by Rajat Lakhina on 19/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreditCardViewController.h"

@interface ToilerDetailsViewController : UIViewController<CardPaymentDelegate>
{
    NSString *stripeToken;
    NSString *stripeCustomerID;
    IBOutlet UIScrollView *sclView;
}
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *keywordsCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;
@property (weak, nonatomic) IBOutlet UIImageView *ratingFirstStar;
@property (weak, nonatomic) IBOutlet UIImageView *rating2ndStar;
@property (weak, nonatomic) IBOutlet UIImageView *rating3Star;
@property (weak, nonatomic) IBOutlet UIImageView *rating4star;
@property (weak, nonatomic) IBOutlet UIImageView *rating5Star;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profilePicHeight;
@property BOOL isFromDashboard;
@property (weak, nonatomic) IBOutlet UIButton *btnSendInvite;
@property (weak, nonatomic) NSDictionary *toilerDetailDict;
@property (weak, nonatomic) IBOutlet UILabel *noCommentLable;
@property (weak, nonatomic) IBOutlet UIView *tableContainerView;

@end
