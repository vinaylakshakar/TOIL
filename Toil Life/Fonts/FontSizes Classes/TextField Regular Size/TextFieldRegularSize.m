//
//  TextFieldRegularSize.m
//  Toil Life
//
//  Created by Rajat Lakhina on 18/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import "TextFieldRegularSize.h"

@implementation TextFieldRegularSize

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
    
    [self setFont:[UIFont fontWithName:@"OpenSans" size:newFontSize]];
    
}


@end
