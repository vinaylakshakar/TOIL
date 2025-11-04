//
//  TextViewR.m
//  Toil Life
//
//  Created by Rajat Lakhina on 30/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import "TextViewR.h"

@implementation TextViewR

- (id)initWithFrame:(CGRect)frame {
    if( (self = [super initWithFrame:frame]) ){
        [self layoutIfNeeded];
        [self configurefont];
    }
    return self;
}


- (void) configurefont {
    CGFloat newFontSize;
    
    if (IS_STANDARD_IPHONE_6)
    {
        newFontSize = self.font.pointSize * 1.2;
    }
    else {
        newFontSize = self.font.pointSize * 1.3;
    }
    
    [self setFont:[UIFont fontWithName:@"OpenSans" size:newFontSize]];
    
}


@end
