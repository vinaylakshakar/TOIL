//
//  ButtonFontSizeRegular.m
//  Toil Life
//
//  Created by Rajat Lakhina on 18/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import "ButtonFontSizeRegular_Black.h"

@implementation ButtonFontSizeRegular_Black

- (id)initWithCoder:(NSCoder *)aDecoder {
    if( (self = [super initWithCoder:aDecoder]) ){
        [self layoutIfNeeded];
        [self configurefont];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if( (self = [super initWithFrame:frame]) ){
        [self layoutIfNeeded];
        [self configurefont];
    }
    return self;
}


- (void) configurefont {
    CGFloat newFontSize;
    if(IS_iPHONE_5)
    {
        newFontSize = self.titleLabel.font.pointSize * SCALE_FACTOR_H;
    }
    else if (IS_STANDARD_IPHONE_6)
    {
        newFontSize = self.titleLabel.font.pointSize * 1.2;
    }
    else {
        newFontSize = self.titleLabel.font.pointSize * 1.3;
    }
    
    [self.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:newFontSize]];
    [self.titleLabel setTextColor:[UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1.0]];
}


@end
