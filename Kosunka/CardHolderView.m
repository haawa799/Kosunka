//
//  CardHolderView.m
//  Kosunka
//
//  Created by Andrew Kharchyshyn on 5/9/13.
//  Copyright (c) 2013 kharchyshyn.andrew. All rights reserved.
//

#import "CardHolderView.h"

@implementation CardHolderView

#pragma mark Initialization

-(void)awakeFromNib
{
    [self setupView];
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setupView];
    }
    return self;
}

-(void)setupView
{
    //initialization here
    [self setNeedsDisplay];
}

#define kCornerRadius 12.0f
#define kMargin 10.0f

-(void)drawRect:(CGRect)rect
{
    //
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:12.0f];
    [path addClip];
    
    [[UIColor blackColor] setStroke];
    [path stroke];
    
    
}

@end
