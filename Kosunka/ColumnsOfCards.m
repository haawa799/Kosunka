//
//  ColumnsOfCards.m
//  Kosunka
//
//  Created by Andrew Kharchyshyn on 5/4/13.
//  Copyright (c) 2013 kharchyshyn.andrew. All rights reserved.
//

#import "ColumnsOfCards.h"

#define kFaceDownCardsDelta 0.05f
#define kFaceUpCardsDelta 0.25f

@interface ColumnsOfCards()

@property (nonatomic) CGSize cardSize;

@property (strong,nonatomic) NSMutableArray *cardsFaceUp;//ClassicPlayingCard
@property (strong,nonatomic) NSMutableArray *cardsFaceDown;//ClassicPlayingCard
@property (strong,nonatomic) ClassicPlayingCard *lastCardFaceDown;

@property (strong,nonatomic) NSMutableArray *cardViewsFaceUp;//PlayingCardView
@property (strong,nonatomic) NSMutableArray *cardViewsFaceDown;//PlayingCardsView

//Subcolumn draging

@property (nonatomic) CGPoint startPosition;
@property (nonatomic) CGPoint prevLocation;
@property (nonatomic) BOOL isOneCardDrag;
@property (strong,nonatomic) NSMutableArray *cardViewsToDrag; //of PlayingCardViews

@end

@implementation ColumnsOfCards

#pragma mark Setters & Getters

-(NSMutableArray *)cardViewsFaceUp
{
    if(!_cardViewsFaceUp)
    {
        _cardViewsFaceUp = [[NSMutableArray alloc]init];
    }
    return _cardViewsFaceUp;
}

-(ClassicPlayingCard *)lastCardFaceUp
{
    return [self.cardsFaceUp lastObject];
}

-(PlayingCardView *)lastCardViewFaceUp
{
    return [self.cardViewsFaceUp lastObject];
}

-(PlayingCardView *)lastCardViewFaceDown
{
    return [self.cardViewsFaceDown lastObject];
}

-(ClassicPlayingCard *)lastCardFaceDown
{
    return [self.cardsFaceDown lastObject];
}

-(NSMutableArray *)cardViewsFaceDown
{
    if(!_cardViewsFaceDown)
    {
        NSInteger numberOfCards = [self.cardsFaceDown count];
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:numberOfCards];
        for (int i = 0; i<numberOfCards; i++)
        {
            ClassicPlayingCard *card = self.cardsFaceDown[i];
            CGRect frame = CGRectMake(0,
                                      0+i*(kFaceDownCardsDelta*self.cardSize.height),
                                      self.cardSize.width,
                                      self.cardSize.height);
            PlayingCardView *playingCardView = [[PlayingCardView alloc]initWithFrame:frame];
            playingCardView.suit = card.suit;
            playingCardView.rank = card.rank;
            playingCardView.faceUp =NO;
            playingCardView.opaque = NO;
            [array insertObject:playingCardView atIndex:i];
        }
        _cardViewsFaceDown = array;
    }
    return _cardViewsFaceDown;
}


#pragma mark Initialization

-(void)awakeFromNib
{
    [self setupView];
}

-(id)initWithSingleCardSize:(CGSize)cardSize
                 withOrigin:(CGPoint)origin
             withCardsArray:(NSMutableArray *)cardsArray
{
    CGRect frame = [self calculateFrameWithSingleCardSize:cardSize withOrigin:origin withNumberOfCards:[cardsArray count]];
    self = [super initWithFrame:frame];
    if(self)
    {
        //
        _cardsFaceDown = cardsArray;
        _cardSize = cardSize;
        [self setupView];
    }
    return self;
    
}

//this method is used for initialization only!
-(CGRect)calculateFrameWithSingleCardSize:(CGSize)cardSize withOrigin:(CGPoint)origin withNumberOfCards:(NSInteger)numb
{
    int height = (cardSize.height * kFaceDownCardsDelta)*(numb - 1) + cardSize.height;
    CGRect frame;
    frame.origin = origin;
    frame.size = CGSizeMake(cardSize.width, height);
    return frame;
}

-(void)setupView
{
    for (PlayingCardView *view in self.cardViewsFaceDown)
    {
        [self addSubview:view];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapOnLastFaceDownCard:)];
    [tap setNumberOfTapsRequired:2];
    [self.lastCardViewFaceDown addGestureRecognizer:tap];
}

-(void)doubleTapOnLastFaceDownCard:(UITapGestureRecognizer *)sender
{
    if(!self.lastCardViewFaceUp)
    {
        [self.lastCardViewFaceDown removeGestureRecognizer:sender];
        self.lastCardViewFaceDown.faceUp = YES;
        
        [self.cardViewsFaceUp addObject:self.lastCardViewFaceDown];
        [self.cardsFaceUp addObject:self.lastCardFaceDown];
        [self setupCardDragingGesture:self.lastCardViewFaceUp];
        
        [self.cardViewsFaceDown removeLastObject];
        [self.cardsFaceDown removeLastObject];
        
        [self.lastCardViewFaceDown addGestureRecognizer:sender];
    }
}

-(BOOL)transferCards:(NSMutableArray *)cards toColumn:(ColumnsOfCards *)column
{
    BOOL success = NO;
    
    BOOL kingOnEmpty = (!column.lastCardViewFaceDown)&&(!column.lastCardViewFaceUp)&&(((PlayingCardView *)cards[0]).rank==13);
    
    if(column!=self)
        if(column.lastCardViewFaceUp||kingOnEmpty)
            
            if([cards count])
            {
                id obj = cards[0];
                if([obj isKindOfClass:[PlayingCardView class]])
                {
                    PlayingCardView *topCard = (PlayingCardView *)obj;
                    BOOL cardMatch = [ClassicPlayingCard counterColorsForSuit1:topCard.suit suit2:column.lastCardViewFaceUp.suit] &&
                                     ((column.lastCardViewFaceUp.rank - topCard.rank) == 1);
                    if(cardMatch||kingOnEmpty)
                    {
                        for (NSInteger i = 0; i < [cards count]; i++)
                        {
                            PlayingCardView *cardView = cards[i];
                            ClassicPlayingCard *card = [[ClassicPlayingCard alloc]init];
                            card.suit = cardView.suit;
                            card.rank = cardView.rank;
                            card.faceUp = YES;
                            [column addCard:card];
                            [cardView removeFromSuperview];
                            cardView = nil;
                        }
                        success = YES;
                    }
                }
            }
    return success;
}


-(void)addCardView:(PlayingCardView *)cardView
{
    
    CGRect newCardFrame = CGRectMake(self.lastCardViewFaceUp.frame.origin.x, self.lastCardViewFaceUp.frame.origin.y + kFaceUpCardsDelta*self.cardSize.height, self.cardSize.width, self.cardSize.height);
    cardView.frame = newCardFrame;
    
    [self.cardViewsFaceUp insertObject:cardView atIndex:[self.cardViewsFaceUp count]];
    
    //change frame of column
    self.frame = CGRectMake(self.frame.origin.x,
                            self.frame.origin.y,
                            self.frame.size.width,
                            self.frame.size.height + (kFaceUpCardsDelta)*self.cardSize.height);
}

-(void)addCard:(ClassicPlayingCard *)card
{
    BOOL noCardsInColumn = (!self.lastCardViewFaceDown)&&(!self.lastCardViewFaceUp);
    
    BOOL cardMatch = self.lastCardViewFaceUp
                            && [ClassicPlayingCard counterColorsForSuit1:self.lastCardViewFaceUp.suit suit2:card.suit]
                            && (self.lastCardViewFaceUp.rank -card.rank)==1;
    
    if(noCardsInColumn||cardMatch)
    {
        [self.cardsFaceUp insertObject:card atIndex:[self.cardsFaceUp count]];
        
        CGRect newCardFrame;
        if(noCardsInColumn)
            newCardFrame = CGRectMake(self.bounds.origin.x,
                                      self.bounds.origin.y,
                                      self.cardSize.width,
                                      self.cardSize.height);
        else
            newCardFrame = CGRectMake(self.lastCardViewFaceUp.frame.origin.x,
                                      self.lastCardViewFaceUp.frame.origin.y + kFaceUpCardsDelta*self.cardSize.height,
                                      self.cardSize.width,
                                      self.cardSize.height);
        
        PlayingCardView *newCardView = [[PlayingCardView alloc]initWithFrame:newCardFrame];
        newCardView.suit = card.suit;
        newCardView.rank = card.rank;
        newCardView.faceUp = YES;
        newCardView.opaque = NO;
        [self setupCardDragingGesture:newCardView];
        [self addSubview:newCardView];
        [self.cardViewsFaceUp insertObject:newCardView atIndex:[self.cardViewsFaceUp count]];
        
        //change frame of column
        self.frame = CGRectMake(self.frame.origin.x,
                                self.frame.origin.y,
                                self.frame.size.width,
                                self.frame.size.height + (kFaceUpCardsDelta)*self.cardSize.height);
    }
}

-(void)setupCardDragingGesture:(PlayingCardView *)cardView
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(columnDragging:)];
    [pan setMaximumNumberOfTouches:1];
    [pan setMinimumNumberOfTouches:1];
    [cardView addGestureRecognizer:pan];
}

-(void)columnDragging:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state==UIGestureRecognizerStateBegan)
    {
        //Gesture stared
        if([gesture.view isKindOfClass:[PlayingCardView class]])
        {
            self.prevLocation = [gesture locationInView:self.superview];
            self.startPosition = self.prevLocation;
            
            PlayingCardView *cardView = (PlayingCardView *)gesture.view;
            NSInteger index  = [self.cardViewsFaceUp indexOfObject:cardView];
            NSInteger numberOfCardsToDrag = [self.cardViewsFaceUp count] - (index+1);
            
            if(numberOfCardsToDrag==1)
                self.isOneCardDrag = YES;
            
            self.cardViewsToDrag = [[NSMutableArray alloc]initWithCapacity:numberOfCardsToDrag];
            
            for (int i = index; i<[self.cardViewsFaceUp count]; i++)
            {
                PlayingCardView *cardView = self.cardViewsFaceUp[i];
                [self.superview bringSubviewToFront:self];
                [self.cardViewsToDrag addObject:cardView];
            }
        }
    }
    else if(gesture.state==UIGestureRecognizerStateChanged)
    {
        //Gesture changed
        
        CGPoint newLocation = [gesture locationInView:self.superview];
        [self moveDragedCardsTo:newLocation];
        self.prevLocation = newLocation;
        
    }
    else if (gesture.state==UIGestureRecognizerStateEnded ||
             gesture.state==UIGestureRecognizerStateCancelled ||
             gesture.state==UIGestureRecognizerStateFailed)
    {
        //Gesture ended
        //;
        CGPoint endPoint = [gesture locationInView:self.superview];
        PlayingCardView *lastCard = [self.cardViewsToDrag lastObject];
        SuitPitView *suitPit = [self.delegate suitPitViewOnWhichDropHappend:endPoint withDroppedCard:lastCard];
        if(suitPit)
        {
            BOOL success = [suitPit addCard:lastCard];
            if(!success)
                [self moveDragedCardsTo:self.startPosition];
            else
            {
                [[self.cardViewsToDrag lastObject] removeFromSuperview];
                [self.cardViewsToDrag removeLastObject];
                [self.cardViewsFaceUp removeLastObject];
            }
        }else
        {
            ColumnsOfCards *column = [self.delegate columnClosestToDropLocation:endPoint withTopCardView:self.cardViewsToDrag[0]];
            if(column)
            {
                BOOL success = [self transferCards:self.cardViewsToDrag toColumn:column];
                if(success)
                {
                    for (PlayingCardView *cardView in self.cardViewsToDrag)
                    {
                        [self.cardViewsFaceUp removeObject:cardView];
                        
//                        //shrink column frame
//                        self.frame = CGRectMake(self.frame.origin.x,
//                                                self.frame.origin.y,
//                                                self.frame.size.width,
//                                                self.frame.size.height - kFaceUpCardsDelta*self.cardSize.height);
                    }
                }
                
            }else
                [self moveDragedCardsTo:self.startPosition];
        }
        self.cardViewsToDrag = nil;
    }
}


-(void)moveDragedCardsTo:(CGPoint)newLocation
{
    CGFloat xDelta = newLocation.x - self.prevLocation.x;
    CGFloat yDelta = newLocation.y - self.prevLocation.y;
    
    for(PlayingCardView *card in self.cardViewsToDrag)
    {
        card.center = CGPointMake(card.center.x + xDelta, card.center.y + yDelta);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
