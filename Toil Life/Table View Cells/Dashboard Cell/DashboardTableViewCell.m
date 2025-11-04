//
//  DashboardTableViewCell.m
//  Toil Life
//
//  Created by Rajat Lakhina on 16/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import "DashboardTableViewCell.h"

@implementation DashboardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _errorImg.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
