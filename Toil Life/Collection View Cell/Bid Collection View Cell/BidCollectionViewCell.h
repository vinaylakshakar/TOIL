//
//  BidCollectionViewCell.h
//  Toil Life
//
//  Created by Rajat Lakhina on 17/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BidCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *lblRating;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblBidPrice;
@property (weak, nonatomic) IBOutlet UIImageView *imgToiler;
@property (weak, nonatomic) IBOutlet UILabel *lblToilerRatings;
@property (weak, nonatomic) IBOutlet UIImageView *imgJobImages;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightProfilePic;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weightProfilePic;
@property (weak, nonatomic) IBOutlet UIButton *deleteImage;
@property (weak, nonatomic) IBOutlet UIButton *bidDetailBtn;
@property (weak, nonatomic) IBOutlet UIImageView *firstStar;
@property (weak, nonatomic) IBOutlet UIImageView *secondStar;
@property (weak, nonatomic) IBOutlet UIImageView *thirdStar;
@property (weak, nonatomic) IBOutlet UIImageView *fourStar;
@property (weak, nonatomic) IBOutlet UIImageView *fifthStar;

@end
