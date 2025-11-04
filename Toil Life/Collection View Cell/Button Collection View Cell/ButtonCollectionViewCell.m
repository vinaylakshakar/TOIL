//
//  ButtonCollectionViewCell.m
//  Toil Life
//
//  Created by Rajat Lakhina on 25/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import "ButtonCollectionViewCell.h"

@implementation ButtonCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if(IS_iPHONE_5){
        _heightRatingCircle.constant = 40;
        _widthRatingCircle.constant = 40;
        
    }
    else if (IS_STANDARD_IPHONE_6){
        _heightRatingCircle.constant = 45;
        _widthRatingCircle.constant = 45;
    }
    else if (IS_STANDARD_IPHONE_6_PLUS){
        _heightRatingCircle.constant = 50;
        _widthRatingCircle.constant = 50;
    }
    //    self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width / 2;
}


@end
