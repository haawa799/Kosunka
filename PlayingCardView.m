//
//  PlayingCardView.m
//  SuperCard
//
//  Created by Andrew Kharchyshyn on 4/30/13.
//  Copyright (c) 2013 kharchyshyn.andrew. All rights reserved.
//

#import "PlayingCardView.h"


@interface PlayingCardView()

@property(nonatomic) CGFloat faceCardScaleFactor;

@end


@implementation PlayingCardView


@synthesize faceCardScaleFactor = _faceCardScaleFactor;

#define DEFAULT_FACE_CARD_SCALE_FACTOR 0.90

-(CGFloat)faceCardScaleFactor
{
    if(!_faceCardScaleFactor) _faceCardScaleFactor = DEFAULT_FACE_CARD_SCALE_FACTOR;
    return _faceCardScaleFactor;
}

-(void)setFaceCardScaleFactor:(CGFloat)faceCardScaleFactor
{
    _faceCardScaleFactor = faceCardScaleFactor;
    [self setNeedsDisplay];
}

-(void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if((gesture.state==UIGestureRecognizerStateChanged) ||(gesture.state==UIGestureRecognizerStateEnded))
    {
        self.faceCardScaleFactor *= gesture.scale;
        gesture.scale = 1;
    }
}

-(void)drawRect:(CGRect)rect
{
    //Drawing code
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:12.0];
    
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    if(self.isFaceUp)
    {
        if(self.rank > 10)
        {
            UIImage *faceImage = [UIImage imageNamed:@"card_front.png"];//[NSString stringWithFormat:@"%@%@.png",[self rankAsString],self.suit]];
            CGRect imageRect = CGRectInset(self.bounds,
                                           self.bounds.size.width * (1.0 - self.faceCardScaleFactor),
                                           self.bounds.size.height * (1.0 - self.faceCardScaleFactor));
            [faceImage drawInRect:imageRect];
        }else
        {
            [self drawPips];
        }
        
        [self drawCorners];
    }else
    {
        [[UIImage imageNamed:@"background.png"] drawInRect:self.bounds];
    }
}

#define PIP_FONT_SCALE_FACTOR 0.2
#define PIP_HOFFSET_PERCENTAGE 0.165
#define PIP_VOFFSET1_PERCENTAGE 0.165
#define PIP_VOFFSET2_PERCENTAGE 0.165
#define PIP_VOFFSET3_PERCENTAGE 0.165
-(void)drawPips
{
    if( (self.rank == 1) || (self.rank == 5) || (self.rank == 9) || (self.rank == 3))
    {
        [self drawPipsWithHorizontalOffset:0
                            verticalOffset:0
                        mirroredVertically:NO];
    }
    if( (self.rank == 6) || (self.rank == 7) || (self.rank == 8))
    {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                            verticalOffset:0
                        mirroredVertically:NO];
    }
    if( (self.rank == 2) || (self.rank == 3) || (self.rank == 7) || (self.rank == 8) || (self.rank == 10))
    {
        [self drawPipsWithHorizontalOffset:0
                            verticalOffset:PIP_VOFFSET2_PERCENTAGE
                        mirroredVertically:(self.rank != 7)];
    }
    if( (self.rank == 4) || (self.rank == 5) || (self.rank == 6) || (self.rank == 7) || (self.rank == 8) || (self.rank == 9) || (self.rank == 10))
    {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                            verticalOffset:PIP_VOFFSET3_PERCENTAGE
                        mirroredVertically:YES];
    }
    if( (self.rank == 9) || (self.rank == 10))
    {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                        verticalOffset:PIP_VOFFSET1_PERCENTAGE
                    mirroredVertically:YES];
    }

}

-(void)drawPipsWithHorizontalOffset:(CGFloat)hoffset
                     verticalOffset:(CGFloat)voffset
                         upsideDown:(BOOL)upsideDown
{
    if(upsideDown) [self pushContextAndRotateUpsideDown];
    CGPoint middle = CGPointMake(self.bounds.size.width*0.5f, self.bounds.size.height*0.5f);
    UIFont *pipFont = [UIFont systemFontOfSize:self.bounds.size.width * PIP_FONT_SCALE_FACTOR];
    NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:self.suit attributes:@{NSFontAttributeName : pipFont}];
    CGSize pipSize = [attributedString size];
    CGPoint pipOrigin = CGPointMake(
                                    middle.x - pipSize.width/2.0 - hoffset*self.bounds.size.width,
                                    middle.y - pipSize.height/2.0 - voffset*self.bounds.size.height);
    [attributedString drawAtPoint:pipOrigin];
    
    if(hoffset)
    {
        pipOrigin.x += hoffset*2.0*self.bounds.size.width;
        [attributedString drawAtPoint:pipOrigin];
    }
    
    if(upsideDown) [self popContext];
}

-(void)drawPipsWithHorizontalOffset:(CGFloat)hoffset
                     verticalOffset:(CGFloat)voffset
                 mirroredVertically:(BOOL)mirroredVertically
{
    [self drawPipsWithHorizontalOffset:hoffset verticalOffset:voffset upsideDown:NO];
    if(mirroredVertically)
        [self drawPipsWithHorizontalOffset:hoffset verticalOffset:voffset upsideDown:YES];
}

-(void)drawCorners
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont *font = [UIFont systemFontOfSize:self.bounds.size.width * 0.20];
    
    NSAttributedString *cornerString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n%@",[self rankAsString],self.suit] attributes:@{NSParagraphStyleAttributeName : paragraphStyle , NSFontAttributeName : font}];
    
    CGRect textBounds;
    textBounds.origin = CGPointMake(2.0, 2.0);
    textBounds.size = [cornerString size];
    [cornerString drawInRect:textBounds];
    
    [self pushContextAndRotateUpsideDown];
    [cornerString drawInRect:textBounds];
    [self popContext];
}

-(void)pushContextAndRotateUpsideDown
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
    CGContextRotateCTM(context, M_PI);
}

-(void)popContext
{
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

-(NSString *)rankAsString
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"][self.rank];
}

#pragma mark Setters and Getters

-(void)setFaceUp:(BOOL)faceUp
{
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

-(void)setSuit:(NSString *)suit
{
    _suit = suit;
    [self setNeedsDisplay];
}

-(void)setRank:(NSUInteger)rank
{
    _rank = rank;
    [self setNeedsDisplay];
}

#pragma mark - Initializatio

-(void)setup
{
    //do initialization jere
}

-(void)awakeFromNib
{
    [self setup];
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

@end
