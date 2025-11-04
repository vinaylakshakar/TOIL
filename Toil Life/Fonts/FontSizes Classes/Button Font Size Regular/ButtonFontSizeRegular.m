//
//  ButtonFontSizeRegular.m
//  Toil Life
//
//  Created by Rajat Lakhina on 18/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import "ButtonFontSizeRegular.h"

@implementation ButtonFontSizeRegular

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
        newFontSize = self.titleLabel.font.pointSize;
    }
    else if (IS_STANDARD_IPHONE_6)
    {
        newFontSize = self.titleLabel.font.pointSize * 1.2;
    }
    else {
        newFontSize = self.titleLabel.font.pointSize * 1.3;
    }
    
    [self.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:newFontSize]];
    
}


@end
