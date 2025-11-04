//
//  TextViewRegularSize.m
//  Toil Life
//
//  Created by Rajat Lakhina on 18/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import "TextViewRegularSize_Black.h"

@implementation TextViewRegularSize_Black

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
    
    [self setFont:[UIFont fontWithName:@"OpenSans" size:newFontSize]];
    [self setTextColor:[UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1.0]];
}

@end
