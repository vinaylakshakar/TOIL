//
//  DashboardTableViewCell.h
//  Toil Life
//
//  Created by Rajat Lakhina on 16/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *lblWork;
@property (weak, nonatomic) IBOutlet UIImageView *firstStar;
@property (weak, nonatomic) IBOutlet UIImageView *secondStar;
@property (weak, nonatomic) IBOutlet UIImageView *thirdStar;
@property (weak, nonatomic) IBOutlet UIImageView *fourStar;
@property (weak, nonatomic) IBOutlet UIImageView *fifthStar;
@property (weak, nonatomic) IBOutlet UILabel *lblNew;
@property (weak, nonatomic) IBOutlet UIImageView *errorImg;
@property (weak, nonatomic) IBOutlet UILabel *lblBidAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblComment;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UIImageView *imgBid;
@property (weak, nonatomic) IBOutlet UILabel *imgBidCount;
@property (weak, nonatomic) IBOutlet UILabel *lblEndDate;

@property (strong, nonatomic) IBOutlet UILabel *paymentDoneLbl;
@property (weak, nonatomic) IBOutlet UIImageView *paymentImage;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@end
