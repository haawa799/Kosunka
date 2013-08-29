//
//  ColumnsOfCards.h
//  Kosunka
//
//  Created by Andrew Kharchyshyn on 5/4/13.
//  Copyright (c) 2013 kharchyshyn.andrew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassicPlayingCard.h"
#import "PlayingCardView.h"
#import "SuitPitView.h"

@class ColumnsOfCards,SuitPitView;

@protocol ColumnOfCardsDraggingProtocol <NSObject>

-(ColumnsOfCards *)columnClosestToDropLocation:(CGPoint)endLocation
                               withTopCardView:(PlayingCardView *)topCardView;

-(SuitPitView *)suitPitViewOnWhichDropHappend:(CGPoint)endLocation
                              withDroppedCard:(PlayingCardView *)droppedCard;

@end

@interface ColumnsOfCards : UIView

@property (weak,nonatomic) id<ColumnOfCardsDraggingProtocol> delegate;

@property (strong,nonatomic) ClassicPlayingCard *lastCardFaceUp;
@property (strong,nonatomic) PlayingCardView *lastCardViewFaceDown;
@property (strong,nonatomic) PlayingCardView *lastCardViewFaceUp;

-(id)initWithSingleCardSize:(CGSize)cardSize withOrigin:(CGPoint)origin withCardsArray:(NSMutableArray *)cardsArray;

-(void)addCard:(ClassicPlayingCard *)card;

-(void)addCardView:(PlayingCardView *)cardView;

-(BOOL)transferCards:(NSMutableArray *)cards toColumn:(ColumnsOfCards *)column;

-(BOOL)transferCard:(PlayingCardView *)card toSuitPit:(PlayingCardView *)suitPit;

@end
