//
//  LabelFontSize.m
//  Toil Life
//
//  Created by Rajat Lakhina on 17/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//
//OpenSansLight-Italic
//OpenSans-Bold
//OpenSans-SemiboldItalic
//OpenSans-ExtraboldItalic
//OpenSans-BoldItalic
//OpenSans-Light
//OpenSans-Semibold
//OpenSans
//OpenSans-Italic
//OpenSans-Extrabold


#define  SCALE_FACTOR_H 0.046
#import "LabelFontSize_Black.h"

@implementation LabelFontSize_Black

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
        newFontSize = self.font.pointSize;
    }
    else if (IS_STANDARD_IPHONE_6)
    {
        newFontSize = self.font.pointSize * 1.2;
    }
    else {
        newFontSize = self.font.pointSize * 1.3;
    }

    [self setFont:[UIFont fontWithName:@"OpenSans-Semibold" size:newFontSize]];
    [self setTextColor:[UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1.0]];
    
}


@end
