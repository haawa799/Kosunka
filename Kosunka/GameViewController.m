//
//  GameViewController.m
//  Kosunka
//
//  Created by Andrew Kharchyshyn on 5/3/13.
//  Copyright (c) 2013 kharchyshyn.andrew. All rights reserved.
//

#import "GameViewController.h"
#import "ClassicPlayingCardDeck.h"
#import "UIBAlertView.h"

#define kSpacingUpponColumns 70.0f

@interface GameViewController ()

@property (strong,nonatomic) PlayingCardView *copiedView;
@property (strong,nonatomic) NSMutableArray *arrayOfColumnViews;//ColumnsOfCards

@property (nonatomic) NSInteger indexOfCardShowedInCurrentCard;

@property (strong,nonatomic) ClassicPlayingCard *prevCurrCard;

@end

@implementation GameViewController

#pragma mark Setters & Getters

-(void)setIndexOfCardShowedInCurrentCard:(NSInteger)indexOfCardShowedInCurrentCard
{
    _indexOfCardShowedInCurrentCard = indexOfCardShowedInCurrentCard;
}

-(ClassicPlayingCard *)prevCurrCard
{
    if(!_prevCurrCard)
        _prevCurrCard = [[ClassicPlayingCard alloc]init];
    return _prevCurrCard;
}

-(NSMutableArray *)arrayOfColumnViews
{
    if(!_arrayOfColumnViews)
        _arrayOfColumnViews = [[NSMutableArray alloc]init];
    return _arrayOfColumnViews;
}

-(Game *)game
{
    if(!_game)
    {
        _game = [[Game alloc]init];
    }
    return _game;
}

#pragma mark ViewController lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.currentCardFromDeck.faceUp = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setupColumns];
    [self setupSuitPits];
}

#pragma mark ColumnsDraggingProtocol implementation

-(ColumnsOfCards *)columnClosestToDropLocation:(CGPoint)endLocation
                               withTopCardView:(PlayingCardView *)topCardView
{
    NSInteger index = [self indexOfColumnsClosestTo:topCardView];
    if(index!=-1){
        ColumnsOfCards *column = self.arrayOfColumnViews[index];
        return column;
    }else
        return nil;
}

-(SuitPitView *)suitPitViewOnWhichDropHappend:(CGPoint)endLocation
                              withDroppedCard:(PlayingCardView *)droppedCard
{
    CGFloat minLength = INFINITY;
    SuitPitView *closestPit = nil;
    for (SuitPitView *suitPit in self.suitPits)
    {
        ColumnsOfCards *column = (ColumnsOfCards *)droppedCard.superview;
        CGRect frame = CGRectMake(column.frame.origin.x+droppedCard.frame.origin.x,
                                  column.frame.origin.y+droppedCard.frame.origin.y,
                                  droppedCard.frame.size.width,
                                  droppedCard.frame.size.height);
        if(CGRectIntersectsRect(suitPit.superview.frame, frame))
        {
            CGFloat length = droppedCard.center.x - suitPit.center.x;
            length = length>0?length:-1*length;
            if(minLength>length)
            {
                closestPit = suitPit;
                minLength = length;
            }
        }
    }
    return closestPit;
}

#pragma mark SuitPitDragAndDropProtocol 

-(ColumnsOfCards *)columnOnWhichCardFromSUitPitDropped:(PlayingCardView *)card
{
    NSInteger index = [self indexOfColumnsClosestTo:card];
    ColumnsOfCards *closestColumn = nil;
    if(index!=-1)
    {
        closestColumn = self.arrayOfColumnViews[index];
    }
    return closestColumn;
}

-(void)fullPit
{
    BOOL allFull = YES;
    for (SuitPitView *pit in self.suitPits)
    {
        if(!pit.full)
        {
            allFull = NO;
            break;
        }
    }
    
    if(allFull)
        [self finishGame];
}

#pragma mark Columns related

-(void)setupColumns
{
    NSInteger numbOfColumns = [self.game.arrayOfSubDecks count];
    for (NSInteger i = 0; i< numbOfColumns;i++)
    {
        Deck *subDeck = self.game.arrayOfSubDecks[i];
        NSMutableArray *cards = subDeck.cardsArray;
        
        ColumnsOfCards *column = [[ColumnsOfCards alloc]initWithSingleCardSize:self.currentCardFromDeck.frame.size withOrigin:[self originForColumnWithIndex:i withMaxNumOfColumns:numbOfColumns] withCardsArray:cards];
        column.delegate = self;
        [self.arrayOfColumnViews addObject:column];
        [self.view addSubview:column];
        
//        [column setBackgroundColor:[UIColor redColor]];
    }
}

-(CGPoint)originForColumnWithIndex:(NSInteger)index withMaxNumOfColumns:(NSInteger)max
{
    CGPoint origin;
    origin.y = self.deckCardView.frame.origin.y + self.deckCardView.frame.size.height + kSpacingUpponColumns;
    CGFloat columnsTotalWidth = self.view.frame.size.width - 2*self.deckCardView.frame.origin.x;
    CGFloat singleCardMaxWidth = columnsTotalWidth / max;
    NSAssert(singleCardMaxWidth >= self.deckCardView.frame.size.width, @"");
    CGFloat delta = singleCardMaxWidth - self.deckCardView.frame.size.width;
    origin.x = self.deckCardView.frame.origin.x + index*(singleCardMaxWidth) + delta;
    
    return origin;
}

#pragma mark - 

-(void)setupSuitPits
{
    for (SuitPitView *suitPit in self.suitPits)
    {
        suitPit.delegate = self;
    }
}

-(NSInteger)indexOfColumnsClosestTo:(PlayingCardView *)cardView
{
    NSInteger index = -1;
    CGFloat minLength = INFINITY;
    for (NSInteger i = 0;i<[self.arrayOfColumnViews count];i++)
    {
        ColumnsOfCards *column = self.arrayOfColumnViews[i];
        PlayingCardView *lastColumnCard = column.lastCardViewFaceUp;
        
        BOOL kingOnEmpty = (cardView.rank == 13)&&(!lastColumnCard)&&(!column.lastCardViewFaceDown);
        
        NSInteger del = lastColumnCard.rank-cardView.rank;
        
        if(((del==1)&&([ClassicPlayingCard counterColorsForSuit1:column.lastCardViewFaceUp.suit suit2:cardView.suit]))||kingOnEmpty)
        {
            CGRect frame = cardView.frame;
            if([cardView.superview isKindOfClass:[ColumnsOfCards class]])
            {
                CGRect superViewFrame = cardView.superview.frame;
                frame = CGRectMake(superViewFrame.origin.x + frame.origin.x,
                                   superViewFrame.origin.y + frame.origin.y,
                                   frame.size.width,
                                   frame.size.height);
            }
            if(CGRectIntersectsRect(column.frame, frame))
            {
                CGFloat tempLength = [self xLengthBetween:column.center and:cardView.center];
                if(tempLength<=minLength)
                {
                    index = i;
                    minLength = tempLength;
                }
            }
        }
    }
    return index;
}

-(CGFloat)lengthBetween:(CGPoint)point1 and:(CGPoint)point2
{
    CGFloat xDelta = point1.x - point2.x;
    CGFloat yDelta = point1.y - point2.y;
    CGFloat length =  sqrtf(powf(xDelta, 2)+powf(yDelta, 2));
    return length;
}

-(CGFloat)xLengthBetween:(CGPoint)point1 and:(CGPoint)point2
{
    CGFloat xDist = point1.x - point2.x;
    return xDist>=0?xDist:-1*xDist;
}



-(void)changeView:(PlayingCardView *)cardView toShowCard:(ClassicPlayingCard *)card
{
    self.currentCardFromDeck.suit = card.suit;
    self.currentCardFromDeck.rank = card.rank;
}


- (IBAction)deckCardViewTapped:(UITapGestureRecognizer *)sender
{
    
    [self showNextCardOnCurrentCard];
    
//    [UIView transitionWithView:self.cardView
//                      duration:0.0
//                       options:UIViewAnimationOptionTransitionFlipFromLeft
//                    animations:^{
//                        self.cardView.FaceUp = !self.cardView.isFaceUp;
//                    }completion:NULL];
}

-(void)showNextCardOnCurrentCard
{
    if(self.currentCardFromDeck.hidden)
    
        self.currentCardFromDeck.hidden = NO;
    else
        self.indexOfCardShowedInCurrentCard++;
    if(self.indexOfCardShowedInCurrentCard==[[[self.game mainDeck] cardsArray] count])
    {
        self.currentCardFromDeck.hidden = YES;
        self.indexOfCardShowedInCurrentCard = 0;
    }else
    {
    ClassicPlayingCard *card = (ClassicPlayingCard *)[[self.game mainDeck] cardsArray][self.indexOfCardShowedInCurrentCard];
    [self changeView:self.currentCardFromDeck toShowCard:card];
    }
}

- (IBAction)currentCardFromDeckTaped:(UIPanGestureRecognizer *)sender
{
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        //save current card in case user will drop card where it doesen't belong
        self.prevCurrCard.suit = self.currentCardFromDeck.suit;
        self.prevCurrCard.rank = self.currentCardFromDeck.rank;
        
        //create card wich is exact copy of currentCard which we can drag over
        self.copiedView = [[PlayingCardView alloc]initWithFrame:self.currentCardFromDeck.superview.frame];
        self.copiedView.suit = self.currentCardFromDeck.suit;
        self.copiedView.rank = self.currentCardFromDeck.rank;
        self.copiedView.faceUp = YES;
        self.copiedView.opaque =NO;
        [self.view addSubview:self.copiedView];
        
        //change current card to show next card while draging copy
        ClassicPlayingCard *nextCardFromDeck = nil;
        
        NSInteger count = [[self.game.mainDeck cardsArray] count];
        NSInteger index = self.indexOfCardShowedInCurrentCard + 1;

        if(index<count)
        {
            nextCardFromDeck = [self.game.mainDeck cardsArray][index];
            self.currentCardFromDeck.suit = nextCardFromDeck.suit;
            self.currentCardFromDeck.rank = nextCardFromDeck.rank;
        }else
            self.currentCardFromDeck.hidden = YES;
    }
    else if(sender.state == UIGestureRecognizerStateChanged)
    {
        //dragging copied card
        CGPoint newLocation = [sender locationInView:self.view];
        newLocation = CGPointMake(newLocation.x - self.copiedView.frame.size.width*0.5f,
                                  newLocation.y - self.copiedView.frame.size.height*0.5f);
        self.copiedView.frame = CGRectMake(newLocation.x,
                                           newLocation.y,
                                           self.copiedView.frame.size.width,
                                           self.copiedView.frame.size.height);
    }
    else if (sender.state == UIGestureRecognizerStateEnded||sender.state == UIGestureRecognizerStateFailed || sender.state == UIGestureRecognizerStateCancelled)
    {
        //card droping handling
        
        NSInteger closestColumnIndex = [self indexOfColumnsClosestTo:self.copiedView];
        if(closestColumnIndex!=-1)
        {
            //drop happend upon one of columns
            
            ClassicPlayingCard *card = [[ClassicPlayingCard alloc]init];
            card.suit = self.copiedView.suit;
            card.rank = self.copiedView.rank;
            [(ColumnsOfCards *)self.arrayOfColumnViews[closestColumnIndex] addCard:card];
            
            [self.copiedView removeFromSuperview];
            self.copiedView = nil;
            
            //copied card was succesfully transported, change currentCard to next (not just visually as it is so far)
            [[self.game.mainDeck cardsArray] removeObjectAtIndex:self.indexOfCardShowedInCurrentCard];
            //[self showNextCardOnCurrentCard];
            
        }else
        {
            //drop happend in unappropriate place
            
            //change currentCard to display dropped card
            if(self.currentCardFromDeck.hidden)
                self.currentCardFromDeck.hidden = NO;
            
            self.currentCardFromDeck.suit = self.prevCurrCard.suit;
            self.currentCardFromDeck.rank = self.prevCurrCard.rank;
            
            //remove copied card
            [self.copiedView removeFromSuperview];
            self.copiedView = nil;
            
        }
    }
}

-(void)finishGame
{
    NSString *title = @"Перемога!";
    NSString *message = @"Ваш результат пошерений vk.com!";
    UIBAlertView *alert = [[UIBAlertView alloc]initWithTitle:title message:message cancelButtonTitle:@"Завершити" otherButtonTitles: nil];
    [alert showWithDismissHandler:^(NSInteger selectedIndex, BOOL didCancel) {
        if(didCancel)
           [self.navigationController popViewControllerAnimated:YES];
    }];
}

@end
