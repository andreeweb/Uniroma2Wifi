//
//  MTTextField.m
//  MyTalo
//
//  Created by Andrea Cerra on 03/11/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import "UWTextField.h"

@implementation UWTextField

static CGFloat leftMargin = 10;

- (CGRect)textRectForBounds:(CGRect)bounds
{
    bounds.origin.x += leftMargin;
    
    return bounds;
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    bounds.origin.x += leftMargin;
    
    return bounds;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
