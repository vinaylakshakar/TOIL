//
//  BidCollectionViewCell.m
//  Toil Life
//
//  Created by Rajat Lakhina on 17/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import "BidCollectionViewCell.h"

@implementation BidCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if(IS_iPHONE_5){
        _heightProfilePic.constant = 40;
        _weightProfilePic.constant = 40;
        
    }
    else if (IS_STANDARD_IPHONE_6){
        _heightProfilePic.constant = 45;
        _weightProfilePic.constant = 45;
    }
    else if (IS_STANDARD_IPHONE_6_PLUS){
        _heightProfilePic.constant = 50;
        _weightProfilePic.constant = 50;
    }
//    self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width / 2;
}


@end
