//
//  SuitPitView.m
//  Kosunka
//
//  Created by Andrew Kharchyshyn on 5/9/13.
//  Copyright (c) 2013 kharchyshyn.andrew. All rights reserved.
//

#import "SuitPitView.h"

@interface SuitPitView()

@property (nonatomic,strong) PlayingCardView *copiedCard;

@property (nonatomic) CGPoint prevLocation;

@end

@implementation SuitPitView

#pragma mark Public API

-(BOOL)addCard:(PlayingCardView *)card
{
    BOOL success = NO;
    if(self.isHidden)
    {
        if(card.rank == 1)
        {
            self.faceUp = YES;
            self.rank = card.rank;
            self.suit = card.suit;
            self.hidden = NO;
            success = YES;
        }
    }
    else if((self.suit==card.suit)&&(card.rank-self.rank==1))
    {
        self.rank = card.rank;
        self.suit = card.suit;
        success = YES;
    }
    
    if(success&&self.rank==13)
    {
        self.full = YES;
    }
    
    return success;
}

#pragma mark Getters & Setters

-(void)setFull:(BOOL)full
{
    _full = full;
    if(_full)
       [self.delegate fullPit];
}

-(PlayingCardView *)copiedCard
{
    if(!_copiedCard)
    {
        _copiedCard = [[PlayingCardView alloc]initWithFrame:self.superview.frame];
        _copiedCard.opaque = NO;
        _copiedCard.faceUp = YES;
        _copiedCard.suit = self.suit;
        _copiedCard.rank = self.rank;
    }
    return _copiedCard;
}

#pragma mark View initialization

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setupGestureRecognizers];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setupGestureRecognizers];
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}

#pragma mark GestureRecognizers related

-(void)setupGestureRecognizers
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self
                                                                         action:@selector(panHappened:)];
    [self addGestureRecognizer:pan];
}

-(void)panHappened:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state==UIGestureRecognizerStateBegan)
    {
        //Gesture stared
        
        [self.superview.superview addSubview:self.copiedCard];
        [self.superview.superview bringSubviewToFront:self.copiedCard];
        self.prevLocation = [gesture locationInView:self.superview.superview];
        
        [self showNextCard];
    }
    else if(gesture.state==UIGestureRecognizerStateChanged)
    {
        //Gesture changed
        CGPoint currLocation = [gesture locationInView:self.superview.superview];
        CGFloat xDelta = currLocation.x - self.prevLocation.x;
        CGFloat yDelta = currLocation.y - self.prevLocation.y;
        self.copiedCard.center = CGPointMake(self.copiedCard.center.x+xDelta,
                                             self.copiedCard.center.y+yDelta);
        self.prevLocation = currLocation;
    }
    else if (gesture.state==UIGestureRecognizerStateEnded ||
             gesture.state==UIGestureRecognizerStateCancelled ||
             gesture.state==UIGestureRecognizerStateFailed)
    {
        //Gesture ended
        
        ColumnsOfCards *column = [self.delegate columnOnWhichCardFromSUitPitDropped:self.copiedCard];
        if(column)
        {
            ClassicPlayingCard *card = [[ClassicPlayingCard alloc]init];
            card.suit = self.copiedCard.suit;
            card.rank = self.copiedCard.rank;
            card.faceUp = YES;
            [column addCard:card];
        }else
            [self showPreviousCard];
        [self.copiedCard removeFromSuperview];
        self.copiedCard = nil;
    }
}

#pragma mark -

-(void)showPreviousCard
{
    if(self.hidden)
        self.hidden = NO;
    self.rank = self.rank + 1;
}

-(void)showNextCard
{
    if(self.rank == 1)
        self.hidden = YES;
    self.rank = self.rank - 1;
    if(self.full)
        self.full = NO;
}

@end
