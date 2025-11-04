//
//  ButtonCollectionViewCell.h
//  Toil Life
//
//  Created by Rajat Lakhina on 25/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblBidCount;
@property (weak, nonatomic) IBOutlet UIImageView *imgRatingCircle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightRatingCircle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthRatingCircle;
@property (weak, nonatomic) IBOutlet UIButton *showAllBidBtn;

@end
